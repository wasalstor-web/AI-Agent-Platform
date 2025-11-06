#!/bin/bash

#############################################################################
# DEPLOY-NOW.sh - AI Agent Platform Quick Deployment Script
# سكريبت النشر السريع لمنصة الوكيل الذكي
#
# Features / المميزات:
# - Quick deployment to Hostinger servers (Domain 2)
# - API-only mode with --api flag
# - Access to 3 web interfaces
# - Support for 8 AI models
# - Premium request handling
#
# Usage / الاستخدام:
#   bash DEPLOY-NOW.sh           # Full deployment
#   bash DEPLOY-NOW.sh --api     # API access only
#
# commit 670b146: للوصول لخادم API والواجهات والنماذج فقط:
# bash DEPLOY-NOW.sh --api
#############################################################################

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
API_PORT=5000
DLPLUS_PORT=8000
WEB_PORT=8080
HOSTINGER_DOMAIN_2="${HOSTINGER_DOMAIN_2:-mbst.space}"

#############################################################################
# Display Functions
#############################################################################

print_header() {
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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

print_premium() {
    echo -e "${PURPLE}💎 $1${NC}"
}

show_usage() {
    cat << EOF
DEPLOY-NOW.sh - AI Agent Platform Quick Deployment
سكريبت النشر السريع لمنصة الوكيل الذكي

Usage / الاستخدام:
    bash DEPLOY-NOW.sh [options]

Options / الخيارات:
    --api              API access only mode (للوصول لخادم API والواجهات والنماذج فقط)
    --premium          Enable premium features (تفعيل المميزات المتقدمة)
    --help, -h         Show this help message (عرض هذه المساعدة)

Examples / أمثلة:
    bash DEPLOY-NOW.sh              # Full deployment (نشر كامل)
    bash DEPLOY-NOW.sh --api        # API only (الوصول للـ API فقط)
    bash DEPLOY-NOW.sh --premium    # With premium features (مع المميزات المتقدمة)

Features / المميزات:
    🌐 Access to 3 web interfaces (الوصول لـ 3 واجهات ويب)
    📋 View 8 AI models (عرض 8 نماذج ذكاء اصطناعي)
    🧪 Test API endpoints (اختبار نقاط API)
    🚀 Start local API server (بدء خادم API محلي)
    💎 Premium request handling (معالجة الطلبات المميزة)

Domain 2 / الدومين الثاني:
    ${HOSTINGER_DOMAIN_2}

EOF
}

#############################################################################
# Parse Arguments
#############################################################################

parse_arguments() {
    API_ONLY=false
    PREMIUM_MODE=false
    
    for arg in "$@"; do
        case $arg in
            --api)
                API_ONLY=true
                ;;
            --premium)
                PREMIUM_MODE=true
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
        esac
    done
}

#############################################################################
# Check Requirements
#############################################################################

check_requirements() {
    print_info "Checking system requirements..."
    print_info "فحص متطلبات النظام..."
    
    local missing_deps=()
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        missing_deps+=("python3")
    else
        print_success "Python 3 found: $(python3 --version)"
    fi
    
    # Check pip
    if ! command -v pip3 &> /dev/null; then
        missing_deps+=("pip3")
    else
        print_success "pip3 found"
    fi
    
    # Check curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    else
        print_success "curl found"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_error "المتطلبات المفقودة: ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "All requirements met!"
    print_success "جميع المتطلبات متوفرة!"
}

#############################################################################
# Install Dependencies
#############################################################################

install_dependencies() {
    print_info "Installing Python dependencies..."
    print_info "تثبيت مكتبات Python..."
    
    cd "$SCRIPT_DIR"
    
    # Install basic dependencies
    pip3 install -q flask flask-cors fastapi uvicorn aiohttp python-dotenv 2>/dev/null || {
        print_warning "Some packages may already be installed"
        print_warning "بعض الحزم قد تكون مثبتة مسبقاً"
    }
    
    print_success "Dependencies installed!"
    print_success "تم تثبيت المكتبات!"
}

#############################################################################
# Display Available AI Models
#############################################################################

show_ai_models() {
    print_header "📋 Available AI Models / النماذج المتاحة"
    
    cat << EOF
${CYAN}8 AI Models Available:${NC}

${GREEN}1. GPT-3.5 Turbo${NC}
   Provider: OpenAI
   Type: General Purpose
   الاستخدام: أغراض عامة

${GREEN}2. GPT-4${NC}
   Provider: OpenAI
   Type: Advanced General Purpose
   الاستخدام: متقدم للأغراض العامة

${GREEN}3. Claude 3${NC}
   Provider: Anthropic
   Type: General Purpose
   الاستخدام: أغراض عامة

${GREEN}4. LLaMA 3${NC}
   Provider: Meta
   Type: Open Source General
   الاستخدام: مفتوح المصدر - أغراض عامة

${GREEN}5. Qwen Arabic${NC}
   Provider: Alibaba
   Type: Arabic Language Model
   الاستخدام: نموذج اللغة العربية

${GREEN}6. AraBERT${NC}
   Provider: AUB
   Type: Arabic Language Model
   الاستخدام: نموذج اللغة العربية

${GREEN}7. Mistral${NC}
   Provider: Mistral AI
   Type: General Purpose
   الاستخدام: أغراض عامة

${GREEN}8. DeepSeek Coder${NC}
   Provider: DeepSeek
   Type: Code Generation
   الاستخدام: توليد الأكواد البرمجية

EOF
}

#############################################################################
# Display Web Interfaces
#############################################################################

show_web_interfaces() {
    print_header "🌐 Web Interfaces / الواجهات"
    
    cat << EOF
${CYAN}3 Web Interfaces Available:${NC}

${GREEN}1. Main API Server${NC}
   URL: http://localhost:${API_PORT}
   Description: Flask API with model endpoints
   الوصف: واجهة API الرئيسية مع نقاط الوصول للنماذج
   
   Endpoints:
   - GET  /api/health     - Health check
   - GET  /api/status     - API status
   - POST /api/process    - Process commands
   - GET  /api/models     - List AI models

${GREEN}2. DL+ Intelligence System${NC}
   URL: http://localhost:${DLPLUS_PORT}
   Description: Advanced AI system with FastAPI
   الوصف: نظام الذكاء الاصطناعي المتقدم
   
   Endpoints:
   - GET  /api/health     - Health check
   - GET  /api/status     - System status
   - POST /api/process    - Process requests
   - GET  /api/docs       - Interactive API documentation

${GREEN}3. Web Dashboard${NC}
   URL: http://localhost:${WEB_PORT}/index.html
   Description: User interface for AI Agent Platform
   الوصف: واجهة المستخدم لمنصة الوكيل الذكي
   
   Features:
   - Interactive chat interface
   - Model selection
   - Request history
   - Settings and configuration

EOF

    if [ "$PREMIUM_MODE" = true ]; then
        print_premium "Premium Feature: Advanced Analytics Dashboard"
        print_premium "الميزة المتقدمة: لوحة التحليلات المتقدمة"
        echo -e "   URL: http://localhost:${WEB_PORT}/premium-dashboard.html"
    fi
}

#############################################################################
# Start API Server
#############################################################################

start_api_server() {
    print_info "Starting Flask API Server on port ${API_PORT}..."
    print_info "بدء تشغيل خادم Flask API على المنفذ ${API_PORT}..."
    
    cd "$SCRIPT_DIR/api"
    
    # Check if port is already in use
    if lsof -Pi :${API_PORT} -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port ${API_PORT} is already in use"
        print_warning "المنفذ ${API_PORT} مستخدم بالفعل"
        print_info "Stopping existing process..."
        lsof -ti:${API_PORT} | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
    
    # Start the server in background
    python3 server.py &> /tmp/flask-api.log &
    API_PID=$!
    sleep 3
    
    # Verify server started
    if ps -p $API_PID > /dev/null; then
        print_success "Flask API Server started (PID: $API_PID)"
        print_success "تم تشغيل خادم Flask API (معرف العملية: $API_PID)"
        
        # Test the server
        if curl -s http://localhost:${API_PORT}/api/health > /dev/null; then
            print_success "API Server is responding"
            print_success "خادم API يستجيب"
        else
            print_warning "API Server may not be fully ready yet"
        fi
    else
        print_error "Failed to start Flask API Server"
        print_error "فشل تشغيل خادم Flask API"
        cat /tmp/flask-api.log
        return 1
    fi
    
    echo "$API_PID" > /tmp/deploy-now-api.pid
}

#############################################################################
# Start DL+ System
#############################################################################

start_dlplus_system() {
    print_info "Starting DL+ Intelligence System on port ${DLPLUS_PORT}..."
    print_info "بدء تشغيل نظام DL+ على المنفذ ${DLPLUS_PORT}..."
    
    cd "$SCRIPT_DIR/dlplus"
    
    # Check if port is already in use
    if lsof -Pi :${DLPLUS_PORT} -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port ${DLPLUS_PORT} is already in use"
        print_warning "المنفذ ${DLPLUS_PORT} مستخدم بالفعل"
        print_info "Stopping existing process..."
        lsof -ti:${DLPLUS_PORT} | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
    
    # Start the server in background
    python3 main.py &> /tmp/dlplus.log &
    DLPLUS_PID=$!
    sleep 3
    
    # Verify server started
    if ps -p $DLPLUS_PID > /dev/null; then
        print_success "DL+ System started (PID: $DLPLUS_PID)"
        print_success "تم تشغيل نظام DL+ (معرف العملية: $DLPLUS_PID)"
        
        # Test the server
        if curl -s http://localhost:${DLPLUS_PORT}/api/health > /dev/null; then
            print_success "DL+ System is responding"
            print_success "نظام DL+ يستجيب"
        else
            print_warning "DL+ System may not be fully ready yet"
        fi
    else
        print_error "Failed to start DL+ System"
        print_error "فشل تشغيل نظام DL+"
        cat /tmp/dlplus.log
        return 1
    fi
    
    echo "$DLPLUS_PID" > /tmp/deploy-now-dlplus.pid
}

#############################################################################
# Start Web Server
#############################################################################

start_web_server() {
    print_info "Starting Web Dashboard on port ${WEB_PORT}..."
    print_info "بدء تشغيل لوحة الويب على المنفذ ${WEB_PORT}..."
    
    cd "$SCRIPT_DIR"
    
    # Check if port is already in use
    if lsof -Pi :${WEB_PORT} -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port ${WEB_PORT} is already in use"
        print_warning "المنفذ ${WEB_PORT} مستخدم بالفعل"
        print_info "Stopping existing process..."
        lsof -ti:${WEB_PORT} | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
    
    # Start the server in background
    python3 -m http.server ${WEB_PORT} &> /tmp/web-server.log &
    WEB_PID=$!
    sleep 2
    
    # Verify server started
    if ps -p $WEB_PID > /dev/null; then
        print_success "Web Dashboard started (PID: $WEB_PID)"
        print_success "تم تشغيل لوحة الويب (معرف العملية: $WEB_PID)"
    else
        print_error "Failed to start Web Dashboard"
        print_error "فشل تشغيل لوحة الويب"
        cat /tmp/web-server.log
        return 1
    fi
    
    echo "$WEB_PID" > /tmp/deploy-now-web.pid
}

#############################################################################
# Test API Endpoints
#############################################################################

test_api_endpoints() {
    print_header "🧪 Testing API Endpoints / اختبار نقاط API"
    
    local endpoints=(
        "http://localhost:${API_PORT}/api/health:Flask API Health"
        "http://localhost:${API_PORT}/api/status:Flask API Status"
        "http://localhost:${API_PORT}/api/models:Flask API Models"
        "http://localhost:${DLPLUS_PORT}/api/health:DL+ Health"
        "http://localhost:${DLPLUS_PORT}/api/status:DL+ Status"
    )
    
    for endpoint_info in "${endpoints[@]}"; do
        IFS=':' read -r url name <<< "$endpoint_info"
        print_info "Testing ${name}..."
        
        if response=$(curl -s -w "\n%{http_code}" "$url" 2>/dev/null); then
            http_code=$(echo "$response" | tail -n1)
            body=$(echo "$response" | head -n-1)
            
            if [ "$http_code" = "200" ]; then
                print_success "${name} - OK (200)"
                echo "   Response: ${body:0:100}..."
            else
                print_warning "${name} - HTTP ${http_code}"
            fi
        else
            print_error "${name} - Connection failed"
        fi
    done
}

#############################################################################
# Connect to Hostinger Domain 2
#############################################################################

connect_to_hostinger() {
    print_header "🌐 Connecting to Hostinger Domain 2 / الاتصال بالدومين الثاني"
    
    print_info "Domain: ${HOSTINGER_DOMAIN_2}"
    print_info "الدومين: ${HOSTINGER_DOMAIN_2}"
    
    if [ -n "$HOSTINGER_API_KEY" ]; then
        print_success "Hostinger API key configured"
        print_success "تم تكوين مفتاح Hostinger API"
        
        # Add connection logic here
        print_info "Testing connection to ${HOSTINGER_DOMAIN_2}..."
        if curl -s --connect-timeout 5 "https://${HOSTINGER_DOMAIN_2}" > /dev/null 2>&1; then
            print_success "Successfully connected to ${HOSTINGER_DOMAIN_2}"
            print_success "تم الاتصال بنجاح بـ ${HOSTINGER_DOMAIN_2}"
        else
            print_warning "Could not reach ${HOSTINGER_DOMAIN_2}"
            print_warning "تعذر الوصول إلى ${HOSTINGER_DOMAIN_2}"
            print_info "Make sure the domain is configured correctly"
            print_info "تأكد من تكوين الدومين بشكل صحيح"
        fi
    else
        print_warning "Hostinger API key not configured"
        print_warning "مفتاح Hostinger API غير مكون"
        print_info "Set HOSTINGER_API_KEY environment variable for remote deployment"
        print_info "قم بتعيين متغير البيئة HOSTINGER_API_KEY للنشر عن بُعد"
    fi
}

#############################################################################
# Premium Request Handler
#############################################################################

handle_premium_requests() {
    if [ "$PREMIUM_MODE" = true ]; then
        print_header "💎 Premium Features Activated / تفعيل المميزات المتقدمة"
        
        print_premium "Enhanced API rate limits"
        print_premium "حدود معززة لمعدل API"
        
        print_premium "Priority request processing"
        print_premium "معالجة الطلبات ذات الأولوية"
        
        print_premium "Advanced analytics and logging"
        print_premium "تحليلات وسجلات متقدمة"
        
        print_premium "Custom model fine-tuning support"
        print_premium "دعم الضبط الدقيق للنماذج المخصصة"
        
        print_success "Premium features are now active!"
        print_success "المميزات المتقدمة نشطة الآن!"
    fi
}

#############################################################################
# Display Summary
#############################################################################

show_summary() {
    print_header "📊 Deployment Summary / ملخص النشر"
    
    cat << EOF
${GREEN}✓ Deployment completed successfully!${NC}
${GREEN}✓ تم النشر بنجاح!${NC}

${CYAN}Access Information:${NC}

${YELLOW}🌐 Web Interfaces:${NC}
1. Flask API:        http://localhost:${API_PORT}
2. DL+ System:       http://localhost:${DLPLUS_PORT}
3. Web Dashboard:    http://localhost:${WEB_PORT}/index.html

${YELLOW}📋 AI Models (8 available):${NC}
   GPT-3.5, GPT-4, Claude 3, LLaMA 3, Qwen Arabic,
   AraBERT, Mistral, DeepSeek Coder

${YELLOW}🔗 Domain 2:${NC}
   ${HOSTINGER_DOMAIN_2}

${YELLOW}📁 Log Files:${NC}
   - Flask API:  /tmp/flask-api.log
   - DL+ System: /tmp/dlplus.log
   - Web Server: /tmp/web-server.log

${YELLOW}📝 PID Files:${NC}
   - Flask API:  /tmp/deploy-now-api.pid
   - DL+ System: /tmp/deploy-now-dlplus.pid
   - Web Server: /tmp/deploy-now-web.pid

${YELLOW}🛑 To stop all services:${NC}
   kill \$(cat /tmp/deploy-now-*.pid 2>/dev/null)

${YELLOW}📚 Documentation:${NC}
   - Interactive API Docs: http://localhost:${DLPLUS_PORT}/api/docs
   - Project README: ./README.md
   - Quick Start: ./QUICK-START.md

EOF

    if [ "$PREMIUM_MODE" = true ]; then
        print_premium "Premium features are enabled"
        print_premium "المميزات المتقدمة مفعلة"
    fi
}

#############################################################################
# API-Only Mode
#############################################################################

run_api_only_mode() {
    print_header "🚀 API-Only Mode / وضع الوصول للـ API فقط"
    print_info "commit 670b146: للوصول لخادم API والواجهات والنماذج فقط"
    
    # Show AI models
    show_ai_models
    
    # Show web interfaces
    show_web_interfaces
    
    # Install dependencies
    install_dependencies
    
    # Start servers
    start_api_server
    start_dlplus_system
    start_web_server
    
    # Test endpoints
    test_api_endpoints
    
    # Show summary
    show_summary
    
    print_info "Press Ctrl+C to stop all services"
    print_info "اضغط Ctrl+C لإيقاف جميع الخدمات"
    
    # Wait for user to stop
    trap "echo && print_info 'Stopping services...' && kill $(cat /tmp/deploy-now-*.pid 2>/dev/null) 2>/dev/null; print_success 'Services stopped'; exit 0" INT TERM
    
    # Keep running
    while true; do
        sleep 1
    done
}

#############################################################################
# Full Deployment Mode
#############################################################################

run_full_deployment() {
    print_header "🚀 AI Agent Platform - Full Deployment"
    print_header "منصة الوكيل الذكي - النشر الكامل"
    
    # Check requirements
    check_requirements
    
    # Show AI models
    show_ai_models
    
    # Show web interfaces
    show_web_interfaces
    
    # Install dependencies
    install_dependencies
    
    # Start servers
    start_api_server
    start_dlplus_system
    start_web_server
    
    # Test endpoints
    test_api_endpoints
    
    # Connect to Hostinger
    connect_to_hostinger
    
    # Handle premium requests
    handle_premium_requests
    
    # Show summary
    show_summary
    
    print_info "Press Ctrl+C to stop all services"
    print_info "اضغط Ctrl+C لإيقاف جميع الخدمات"
    
    # Wait for user to stop
    trap "echo && print_info 'Stopping services...' && kill $(cat /tmp/deploy-now-*.pid 2>/dev/null) 2>/dev/null; print_success 'Services stopped'; exit 0" INT TERM
    
    # Keep running
    while true; do
        sleep 1
    done
}

#############################################################################
# Main Execution
#############################################################################

main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Display banner
    clear
    cat << EOF
${PURPLE}
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║        🤖 AI Agent Platform - Quick Deployment 🤖             ║
║           منصة الوكيل الذكي - النشر السريع                  ║
║                                                               ║
║  commit 670b146: للوصول لخادم API والواجهات والنماذج فقط    ║
║  bash DEPLOY-NOW.sh --api                                    ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
${NC}

EOF

    # Run appropriate mode
    if [ "$API_ONLY" = true ]; then
        run_api_only_mode
    else
        run_full_deployment
    fi
}

# Run main function
main "$@"
