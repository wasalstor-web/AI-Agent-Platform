#!/bin/bash

#############################################################################
# Docker Compose Test Script
# سكريبت اختبار Docker Compose
#
# This script tests the Docker Compose setup to ensure everything works
# يختبر هذا السكريبت إعداد Docker Compose للتأكد من أن كل شيء يعمل
#############################################################################

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    print_info "اختبار | Testing: $test_name"
    
    if eval "$test_command"; then
        print_success "$test_name نجح | passed"
        ((TESTS_PASSED++))
        return 0
    else
        print_error "$test_name فشل | failed"
        ((TESTS_FAILED++))
        return 1
    fi
}

#############################################################################
# Test 1: Check Docker and Docker Compose
#############################################################################

test_docker() {
    print_header "اختبار 1: فحص Docker | Test 1: Check Docker"
    
    run_test "Docker مثبت | Docker installed" "command -v docker &> /dev/null"
    run_test "Docker يعمل | Docker running" "docker info &> /dev/null"
    run_test "Docker Compose مثبت | Docker Compose installed" "docker compose version &> /dev/null"
}

#############################################################################
# Test 2: Check Configuration Files
#############################################################################

test_config_files() {
    print_header "اختبار 2: فحص الملفات | Test 2: Check Files"
    
    run_test "Dockerfile موجود | Dockerfile exists" "[ -f Dockerfile ]"
    run_test "docker-compose.yml موجود | docker-compose.yml exists" "[ -f docker-compose.yml ]"
    run_test "docker-start.sh موجود | docker-start.sh exists" "[ -f docker-start.sh ]"
    run_test "docker-start.sh قابل للتنفيذ | docker-start.sh executable" "[ -x docker-start.sh ]"
    run_test ".dockerignore موجود | .dockerignore exists" "[ -f .dockerignore ]"
}

#############################################################################
# Test 3: Validate Docker Compose Configuration
#############################################################################

test_compose_config() {
    print_header "اختبار 3: التحقق من التكوين | Test 3: Validate Config"
    
    # Docker Compose config validation (ignore version warning)
    if docker compose config > /dev/null 2>&1; then
        print_success "تكوين Docker Compose صحيح | Docker Compose config valid"
        ((TESTS_PASSED++))
    else
        print_error "تكوين Docker Compose غير صحيح | Docker Compose config invalid"
        ((TESTS_FAILED++))
    fi
}

#############################################################################
# Test 4: Build Images
#############################################################################

test_build() {
    print_header "اختبار 4: بناء الصور | Test 4: Build Images"
    
    print_info "بناء صورة DL+ | Building DL+ image..."
    if docker compose build dlplus; then
        print_success "تم بناء الصورة | Image built successfully"
        ((TESTS_PASSED++))
        return 0
    else
        print_error "فشل بناء الصورة | Image build failed"
        ((TESTS_FAILED++))
        return 1
    fi
}

#############################################################################
# Test 5: Start Services
#############################################################################

test_start_services() {
    print_header "اختبار 5: بدء الخدمات | Test 5: Start Services"
    
    print_info "بدء خدمة DL+ | Starting DL+ service..."
    if docker compose up -d dlplus; then
        print_success "تم بدء الخدمة | Service started"
        ((TESTS_PASSED++))
    else
        print_error "فشل بدء الخدمة | Service start failed"
        ((TESTS_FAILED++))
        return 1
    fi
    
    # Wait for service to be ready
    print_info "انتظار جاهزية الخدمة | Waiting for service to be ready..."
    sleep 10
}

#############################################################################
# Test 6: Check Service Health
#############################################################################

test_service_health() {
    print_header "اختبار 6: فحص صحة الخدمة | Test 6: Check Service Health"
    
    run_test "حاوية DL+ تعمل | DL+ container running" "docker compose ps | grep -q 'ai-agent-dlplus.*Up'"
    
    # Test API endpoints
    print_info "اختبار نقاط النهاية | Testing endpoints..."
    
    if curl -s -f http://localhost:8000/ > /dev/null; then
        print_success "نقطة النهاية الرئيسية تعمل | Root endpoint working"
        ((TESTS_PASSED++))
    else
        print_error "نقطة النهاية الرئيسية لا تعمل | Root endpoint not working"
        ((TESTS_FAILED++))
    fi
    
    if curl -s -f http://localhost:8000/api/health > /dev/null; then
        print_success "فحص الصحة يعمل | Health check working"
        ((TESTS_PASSED++))
    else
        print_error "فحص الصحة لا يعمل | Health check not working"
        ((TESTS_FAILED++))
    fi
    
    if curl -s -f http://localhost:8000/api/status > /dev/null; then
        print_success "نقطة الحالة تعمل | Status endpoint working"
        ((TESTS_PASSED++))
    else
        print_error "نقطة الحالة لا تعمل | Status endpoint not working"
        ((TESTS_FAILED++))
    fi
}

#############################################################################
# Test 7: Check Logs
#############################################################################

test_logs() {
    print_header "اختبار 7: فحص السجلات | Test 7: Check Logs"
    
    print_info "عرض آخر 10 أسطر من السجل | Showing last 10 log lines:"
    docker compose logs --tail=10 dlplus
    
    if docker compose logs dlplus 2>&1 | grep -q "Uvicorn running"; then
        print_success "الخادم يعمل بشكل صحيح | Server running correctly"
        ((TESTS_PASSED++))
    else
        print_error "مشكلة في السجلات | Issue in logs"
        ((TESTS_FAILED++))
    fi
}

#############################################################################
# Test 8: Stop Services
#############################################################################

test_stop_services() {
    print_header "اختبار 8: إيقاف الخدمات | Test 8: Stop Services"
    
    print_info "إيقاف الخدمات | Stopping services..."
    if docker compose down; then
        print_success "تم إيقاف الخدمات | Services stopped successfully"
        ((TESTS_PASSED++))
    else
        print_error "فشل إيقاف الخدمات | Failed to stop services"
        ((TESTS_FAILED++))
    fi
}

#############################################################################
# Main Test Runner
#############################################################################

main() {
    print_header "🧪 Docker Compose Test Suite"
    print_header "مجموعة اختبارات Docker Compose"
    
    echo ""
    print_info "بدء الاختبارات | Starting tests..."
    echo ""
    
    # Run all tests
    test_docker
    test_config_files
    test_compose_config
    test_build
    test_start_services
    test_service_health
    test_logs
    test_stop_services
    
    # Print summary
    print_header "النتائج النهائية | Final Results"
    
    TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))
    
    echo ""
    echo -e "  ${GREEN}نجح | Passed: $TESTS_PASSED${NC}"
    echo -e "  ${RED}فشل | Failed: $TESTS_FAILED${NC}"
    echo -e "  ${BLUE}الإجمالي | Total: $TOTAL_TESTS${NC}"
    echo ""
    
    if [ $TESTS_FAILED -eq 0 ]; then
        print_header "✅ جميع الاختبارات نجحت! | All Tests Passed!"
        echo ""
        print_info "Docker Compose جاهز للاستخدام | Docker Compose is ready to use"
        echo ""
        echo "للبدء | To start:"
        echo "  ./docker-start.sh start basic"
        echo ""
        echo "للوصول | To access:"
        echo "  http://localhost:8000"
        echo ""
        exit 0
    else
        print_header "❌ بعض الاختبارات فشلت | Some Tests Failed"
        echo ""
        print_info "يرجى مراجعة الأخطاء أعلاه | Please review errors above"
        echo ""
        exit 1
    fi
}

# Run tests
main
