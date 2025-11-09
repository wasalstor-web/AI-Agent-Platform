#!/bin/bash

#############################################################################
# API Server Connection Script
# سكريبت الاتصال بخادم API
#
# Description: Connects to API server and provides access to interfaces and models
#              يوصل بخادم API ويوفر الوصول للواجهات والنماذج فقط
#
# Usage: bash connect-api-server.sh [server_url]
#############################################################################

# Note: Not using set -e to allow explicit error handling for commands that may fail gracefully

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Default API server URL
API_SERVER="${1:-http://localhost:5000}"

# Validate API server URL for basic security
validate_url() {
    local url="$1"
    # Allow localhost, 127.0.0.1, or any IP for flexibility in deployment scenarios
    # In production, consider restricting to specific trusted domains
    if [[ ! "$url" =~ ^https?:// ]]; then
        print_error "Invalid API server URL. Must start with http:// or https://"
        exit 1
    fi
}

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Validate the API server URL
validate_url "$API_SERVER"

print_header "🌐 الاتصال بخادم API | Connecting to API Server"

echo -e "${CYAN}API Server:${NC} $API_SERVER"
echo ""

# Test API connection
print_info "Testing connection to API server..."
if curl -s -f "${API_SERVER}/api/health" > /dev/null 2>&1; then
    print_success "Connected to API server successfully!"
else
    print_error "Cannot connect to API server"
    print_info "Please ensure:"
    echo "  1. API server is running"
    echo "  2. URL is correct: $API_SERVER"
    echo "  3. Firewall allows connections"
    echo ""
    print_info "To start API server locally:"
    echo "  cd api && python3 server.py"
    exit 1
fi

# Get API status
print_info "Fetching API status..."
STATUS_RESPONSE=$(curl -s "${API_SERVER}/api/status")
echo "$STATUS_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$STATUS_RESPONSE"
echo ""

# Get available models
print_header "📋 النماذج المتوفرة | Available Models"
MODELS_RESPONSE=$(curl -s "${API_SERVER}/api/models")
echo "$MODELS_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$MODELS_RESPONSE"
echo ""

# Interactive menu
print_header "🎯 قائمة الواجهات | Interface Menu"

echo -e "${CYAN}Select an option | اختر خياراً:${NC}"
echo ""
echo "  1) ${GREEN}الوصول للواجهات${NC}    | Access Web Interfaces"
echo "     فتح الواجهات التفاعلية"
echo ""
echo "  2) ${BLUE}عرض النماذج${NC}         | View Models"
echo "     عرض جميع النماذج المتاحة"
echo ""
echo "  3) ${YELLOW}اختبار API${NC}         | Test API"
echo "     إرسال طلب تجريبي"
echo ""
echo "  4) ${CYAN}تشغيل خادم API${NC}     | Start API Server"
echo "     تشغيل خادم API محلياً"
echo ""
echo "  5) ${RED}خروج${NC}                | Exit"
echo ""

read -p "$(echo -e ${CYAN}Enter choice [1-5]:${NC} )" choice

case $choice in
    1)
        print_info "Opening web interfaces..."
        echo ""
        print_success "Available interfaces:"
        echo ""
        echo "  🌐 Main Interface:"
        echo "     file://$(pwd)/index.html"
        echo ""
        echo "  📊 OpenWebUI Demo:"
        echo "     file://$(pwd)/openwebui-demo.html"
        echo ""
        echo "  🎛️  Dashboard Template:"
        echo "     file://$(pwd)/openwebui-dashboard-template.html"
        echo ""
        
        # Try to open in browser
        if command -v xdg-open &> /dev/null; then
            xdg-open "index.html" 2>/dev/null &
            print_success "Opening main interface in browser..."
        elif command -v open &> /dev/null; then
            open "index.html" 2>/dev/null &
            print_success "Opening main interface in browser..."
        else
            print_info "Please open the HTML files manually in your browser"
        fi
        ;;
        
    2)
        print_info "Fetching detailed models information..."
        echo ""
        
        MODELS=$(curl -s "${API_SERVER}/api/models" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    models = data.get('models', [])
    
    print('╔═══════════════════════════════════════════════════════════════╗')
    print('║                    Available AI Models                        ║')
    print('╚═══════════════════════════════════════════════════════════════╝')
    print()
    
    for i, model in enumerate(models, 1):
        print(f'{i}. {model[\"name\"]}')
        print(f'   ID: {model[\"id\"]}')
        print(f'   Provider: {model[\"provider\"]}')
        print(f'   Type: {model[\"type\"]}')
        print()
except Exception as e:
    print(f'Error parsing models: {e}')
" 2>/dev/null)
        
        echo "$MODELS"
        ;;
        
    3)
        print_info "Testing API with sample request..."
        echo ""
        
        # Test in Arabic
        print_info "Testing Arabic request..."
        curl -s -X POST "${API_SERVER}/api/process" \
            -H "Content-Type: application/json" \
            -d '{
                "command": "مرحباً",
                "context": {
                    "model": "qwen-arabic",
                    "language": "ar"
                }
            }' | python3 -m json.tool 2>/dev/null
        
        echo ""
        
        # Test in English
        print_info "Testing English request..."
        curl -s -X POST "${API_SERVER}/api/process" \
            -H "Content-Type: application/json" \
            -d '{
                "command": "Hello",
                "context": {
                    "model": "gpt-3.5-turbo",
                    "language": "en"
                }
            }' | python3 -m json.tool 2>/dev/null
        
        echo ""
        print_success "API test completed!"
        ;;
        
    4)
        print_info "Starting API server..."
        echo ""
        
        if [ -f "api/server.py" ]; then
            print_success "Found API server file"
            print_info "Starting server at http://0.0.0.0:5000"
            echo ""
            print_info "Press Ctrl+C to stop"
            echo ""
            cd api && python3 server.py
        else
            print_error "API server file not found!"
            print_info "Please ensure you are in the project root directory"
        fi
        ;;
        
    5)
        print_info "Exiting..."
        exit 0
        ;;
        
    *)
        print_error "Invalid choice!"
        ;;
esac

echo ""
print_success "Done!"
