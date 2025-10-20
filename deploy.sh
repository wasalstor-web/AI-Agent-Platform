#!/bin/bash

#############################################################################
# VPS Connection Check Script
# Smart deployment script for Hostinger VPS with connection verification
# Features: SSH test, HTTP/HTTPS check, port scanning, health monitoring
#############################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration variables (can be set via environment variables)
VPS_HOST="${VPS_HOST:-}"
VPS_USER="${VPS_USER:-root}"
VPS_PORT="${VPS_PORT:-22}"
HTTP_PORT="${HTTP_PORT:-80}"
HTTPS_PORT="${HTTPS_PORT:-443}"
TIMEOUT="${TIMEOUT:-5}"

#############################################################################
# Display Functions
#############################################################################

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

#############################################################################
# Connection Test Functions
#############################################################################

# Test SSH connection
check_ssh_connection() {
    print_header "فحص اتصال SSH / SSH Connection Check"
    
    if [ -z "$VPS_HOST" ]; then
        print_error "لم يتم تحديد عنوان VPS / VPS host not specified"
        print_info "استخدم: VPS_HOST=your-server.com $0"
        print_info "Usage: VPS_HOST=your-server.com $0"
        return 1
    fi
    
    print_info "جاري الاتصال بـ: $VPS_USER@$VPS_HOST:$VPS_PORT"
    print_info "Connecting to: $VPS_USER@$VPS_HOST:$VPS_PORT"
    
    # Test SSH connection with timeout
    if timeout "$TIMEOUT" ssh -o ConnectTimeout="$TIMEOUT" \
        -o StrictHostKeyChecking=no \
        -o BatchMode=yes \
        -p "$VPS_PORT" \
        "$VPS_USER@$VPS_HOST" \
        "echo 'SSH Connection Successful'" 2>/dev/null; then
        print_success "اتصال SSH ناجح / SSH connection successful"
        return 0
    else
        print_error "فشل اتصال SSH / SSH connection failed"
        print_warning "تحقق من: / Check:"
        echo "  - عنوان الخادم صحيح / Server address is correct"
        echo "  - منفذ SSH مفتوح / SSH port is open"
        echo "  - مفاتيح SSH مُعدة بشكل صحيح / SSH keys configured properly"
        echo "  - جدار الحماية يسمح بالاتصالات / Firewall allows connections"
        return 1
    fi
}

# Check if port is open
check_port() {
    local port=$1
    local service=$2
    
    print_info "جاري فحص المنفذ $port ($service) / Checking port $port ($service)"
    
    if timeout "$TIMEOUT" bash -c "echo >/dev/tcp/$VPS_HOST/$port" 2>/dev/null; then
        print_success "المنفذ $port مفتوح / Port $port is open"
        return 0
    else
        print_error "المنفذ $port مغلق أو غير قابل للوصول / Port $port is closed or unreachable"
        return 1
    fi
}

# Test HTTP/HTTPS connectivity
check_http_connection() {
    print_header "فحص اتصال HTTP/HTTPS / HTTP/HTTPS Connection Check"
    
    if [ -z "$VPS_HOST" ]; then
        print_error "لم يتم تحديد عنوان VPS / VPS host not specified"
        return 1
    fi
    
    local http_success=0
    local https_success=0
    
    # Check HTTP
    print_info "جاري فحص HTTP (المنفذ $HTTP_PORT) / Checking HTTP (port $HTTP_PORT)"
    if curl -s -o /dev/null -w "%{http_code}" --connect-timeout "$TIMEOUT" \
        "http://$VPS_HOST:$HTTP_PORT" | grep -q "^[2-3][0-9][0-9]"; then
        print_success "خادم HTTP يعمل / HTTP server is responding"
        http_success=1
    else
        print_warning "خادم HTTP لا يستجيب أو غير متاح / HTTP server not responding or unavailable"
    fi
    
    # Check HTTPS
    print_info "جاري فحص HTTPS (المنفذ $HTTPS_PORT) / Checking HTTPS (port $HTTPS_PORT)"
    if curl -s -o /dev/null -w "%{http_code}" --connect-timeout "$TIMEOUT" -k \
        "https://$VPS_HOST:$HTTPS_PORT" | grep -q "^[2-3][0-9][0-9]"; then
        print_success "خادم HTTPS يعمل / HTTPS server is responding"
        https_success=1
    else
        print_warning "خادم HTTPS لا يستجيب أو غير متاح / HTTPS server not responding or unavailable"
    fi
    
    if [ $http_success -eq 1 ] || [ $https_success -eq 1 ]; then
        return 0
    else
        return 1
    fi
}

# Measure server response time
check_response_time() {
    print_header "قياس وقت الاستجابة / Response Time Measurement"
    
    if [ -z "$VPS_HOST" ]; then
        print_error "لم يتم تحديد عنوان VPS / VPS host not specified"
        return 1
    fi
    
    print_info "جاري قياس وقت الاستجابة / Measuring response time..."
    
    # Ping test
    if command -v ping >/dev/null 2>&1; then
        local ping_result=$(ping -c 4 -W "$TIMEOUT" "$VPS_HOST" 2>/dev/null | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
        if [ -n "$ping_result" ]; then
            print_success "متوسط وقت الاستجابة: ${ping_result}ms / Average response time: ${ping_result}ms"
        else
            print_warning "فشل اختبار Ping / Ping test failed"
        fi
    fi
    
    # HTTP response time
    if command -v curl >/dev/null 2>&1; then
        local http_time=$(curl -o /dev/null -s -w '%{time_total}\n' --connect-timeout "$TIMEOUT" "http://$VPS_HOST" 2>/dev/null)
        if [ -n "$http_time" ]; then
            print_success "وقت استجابة HTTP: ${http_time}s / HTTP response time: ${http_time}s"
        fi
    fi
}

# Comprehensive port scan
comprehensive_port_check() {
    print_header "فحص المنافذ الشائعة / Common Ports Check"
    
    if [ -z "$VPS_HOST" ]; then
        print_error "لم يتم تحديد عنوان VPS / VPS host not specified"
        return 1
    fi
    
    local ports=("22:SSH" "80:HTTP" "443:HTTPS" "3306:MySQL" "5432:PostgreSQL" "27017:MongoDB" "6379:Redis" "8080:Alt-HTTP")
    
    for port_service in "${ports[@]}"; do
        IFS=':' read -r port service <<< "$port_service"
        check_port "$port" "$service"
    done
}

# Check DNS resolution
check_dns() {
    print_header "فحص DNS / DNS Resolution Check"
    
    if [ -z "$VPS_HOST" ]; then
        print_error "لم يتم تحديد عنوان VPS / VPS host not specified"
        return 1
    fi
    
    print_info "جاري فحص DNS لـ $VPS_HOST / Resolving DNS for $VPS_HOST"
    
    if command -v nslookup >/dev/null 2>&1; then
        local ip_address=$(nslookup "$VPS_HOST" 2>/dev/null | awk '/^Address: / { print $2 }' | tail -1)
        if [ -n "$ip_address" ]; then
            print_success "DNS resolved: $VPS_HOST → $ip_address"
            echo "  عنوان IP / IP Address: $ip_address"
        else
            print_error "فشل في حل DNS / DNS resolution failed"
            return 1
        fi
    elif command -v host >/dev/null 2>&1; then
        local ip_address=$(host "$VPS_HOST" 2>/dev/null | awk '/has address/ { print $4 }' | head -1)
        if [ -n "$ip_address" ]; then
            print_success "DNS resolved: $VPS_HOST → $ip_address"
            echo "  عنوان IP / IP Address: $ip_address"
        else
            print_error "فشل في حل DNS / DNS resolution failed"
            return 1
        fi
    else
        print_warning "أدوات DNS غير متوفرة / DNS tools not available"
        return 1
    fi
}

#############################################################################
# Main Function
#############################################################################

run_full_check() {
    print_header "فحص شامل لاتصال VPS / Comprehensive VPS Connection Check"
    
    echo -e "${BLUE}الخادم / Server: ${NC}${VPS_HOST:-'not specified'}"
    echo -e "${BLUE}المستخدم / User: ${NC}$VPS_USER"
    echo -e "${BLUE}المنفذ / Port: ${NC}$VPS_PORT"
    echo ""
    
    local checks_passed=0
    local total_checks=0
    
    # DNS Check
    ((total_checks++))
    if check_dns; then
        ((checks_passed++))
    fi
    
    # SSH Check
    ((total_checks++))
    if check_ssh_connection; then
        ((checks_passed++))
    fi
    
    # HTTP/HTTPS Check
    ((total_checks++))
    if check_http_connection; then
        ((checks_passed++))
    fi
    
    # Response Time Check
    check_response_time
    
    # Comprehensive Port Check
    comprehensive_port_check
    
    # Summary
    print_header "ملخص النتائج / Results Summary"
    echo -e "الفحوصات الناجحة / Successful Checks: ${GREEN}$checks_passed${NC}/$total_checks"
    
    if [ $checks_passed -eq $total_checks ]; then
        print_success "جميع الفحوصات نجحت! / All checks passed!"
        return 0
    elif [ $checks_passed -gt 0 ]; then
        print_warning "بعض الفحوصات فشلت / Some checks failed"
        return 1
    else
        print_error "جميع الفحوصات فشلت / All checks failed"
        return 2
    fi
}

# Display usage information
show_usage() {
    cat << EOF
استخدام / Usage:
    $0 [options]

الخيارات / Options:
    -h, --host HOST     عنوان VPS / VPS hostname or IP
    -u, --user USER     اسم المستخدم (افتراضي: root) / Username (default: root)
    -p, --port PORT     منفذ SSH (افتراضي: 22) / SSH port (default: 22)
    -t, --timeout SEC   مهلة الاتصال بالثواني / Connection timeout in seconds
    --help              عرض هذه المساعدة / Show this help

أمثلة / Examples:
    $0 --host example.com
    $0 --host example.com --user admin --port 2222
    VPS_HOST=example.com $0
    VPS_HOST=example.com VPS_USER=admin VPS_PORT=2222 $0

متغيرات البيئة / Environment Variables:
    VPS_HOST        عنوان الخادم / Server hostname
    VPS_USER        اسم المستخدم / Username
    VPS_PORT        منفذ SSH / SSH port
    HTTP_PORT       منفذ HTTP / HTTP port
    HTTPS_PORT      منفذ HTTPS / HTTPS port
    TIMEOUT         مهلة الاتصال / Connection timeout

EOF
}

#############################################################################
# Parse Arguments
#############################################################################

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--host)
            VPS_HOST="$2"
            shift 2
            ;;
        -u|--user)
            VPS_USER="$2"
            shift 2
            ;;
        -p|--port)
            VPS_PORT="$2"
            shift 2
            ;;
        -t|--timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo "خيار غير معروف / Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

#############################################################################
# Main Execution
#############################################################################

# Check if VPS_HOST is set
if [ -z "$VPS_HOST" ]; then
    echo -e "${RED}خطأ: لم يتم تحديد عنوان VPS${NC}"
    echo -e "${RED}Error: VPS host not specified${NC}"
    echo ""
    show_usage
    exit 1
fi

# Run the full check
run_full_check
exit $?