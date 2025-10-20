#!/bin/bash
#######################################################################
# OpenWebUI Integration Test Script
# سكريبت اختبار دمج OpenWebUI
#
# This script tests the OpenWebUI integration with all features
# هذا السكريبت يختبر دمج OpenWebUI مع جميع الميزات
#
# المؤسس: خليف 'ذيبان' العنزي
# الموقع: القصيم – بريدة – المملكة العربية السعودية
#######################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}      🧪 OpenWebUI Integration Test Suite${NC}"
echo -e "${CYAN}      مجموعة اختبارات دمج OpenWebUI${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to print section headers
print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to print error
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to print info
print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_section "📋 Step 1: Pre-test Checks / الفحوصات الأولية"

# Check if Python is installed
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_success "Python installed: $PYTHON_VERSION"
else
    print_error "Python 3 is not installed"
    exit 1
fi

# Check if test script exists
if [ ! -f "test-openwebui-integration.py" ]; then
    print_error "Test script not found: test-openwebui-integration.py"
    exit 1
fi

print_success "Test script found"

print_section "📦 Step 2: Installing Test Dependencies / تثبيت متطلبات الاختبار"

# Create virtual environment if needed
if [ ! -d "venv" ]; then
    print_info "Creating virtual environment..."
    python3 -m venv venv
    print_success "Virtual environment created"
fi

# Activate virtual environment
print_info "Activating virtual environment..."
source venv/bin/activate
print_success "Virtual environment activated"

# Install required packages
print_info "Installing test dependencies..."
pip3 install -q --upgrade pip
pip3 install -q httpx pytest pytest-asyncio

print_success "Test dependencies installed"

print_section "⚙️ Step 3: Configuration / الإعدادات"

# Get test URL from argument or use default
TEST_URL="${1:-http://localhost:8080}"

print_info "Test URL: $TEST_URL"

# Load environment variables if .env exists
if [ -f ".env" ]; then
    print_info "Loading environment variables from .env"
    export $(grep -v '^#' .env | xargs)
    print_success "Environment variables loaded"
else
    print_info "No .env file found, using defaults"
fi

# Check if integration server is running
print_info "Checking if integration server is running..."

if curl -s --max-time 5 "$TEST_URL/" > /dev/null 2>&1; then
    print_success "Integration server is running"
else
    print_error "Integration server is not running at $TEST_URL"
    echo ""
    print_info "To start the server, run:"
    echo "  ./deploy-openwebui-integration.sh"
    echo "  or"
    echo "  python3 openwebui-integration.py"
    echo ""
    exit 1
fi

print_section "🧪 Step 4: Running Tests / تشغيل الاختبارات"

# Make test script executable
chmod +x test-openwebui-integration.py

# Run the tests
print_info "Starting comprehensive test suite..."
echo ""

python3 test-openwebui-integration.py "$TEST_URL"

TEST_EXIT_CODE=$?

print_section "📊 Step 5: Test Results / نتائج الاختبار"

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ All tests passed successfully!${NC}"
    echo -e "${GREEN}✓ جميع الاختبارات نجحت بنجاح!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ -f "test-results-openwebui.json" ]; then
        print_success "Detailed results saved to: test-results-openwebui.json"
    fi
else
    echo -e "${RED}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}✗ Some tests failed${NC}"
    echo -e "${RED}✗ بعض الاختبارات فشلت${NC}"
    echo -e "${RED}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ -f "test-results-openwebui.json" ]; then
        print_info "Check test-results-openwebui.json for detailed failure information"
    fi
fi

echo ""
print_info "Test execution completed"

exit $TEST_EXIT_CODE
