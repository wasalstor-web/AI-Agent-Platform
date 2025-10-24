#!/bin/bash

###############################################################################
# AI Agent Platform - Local Startup Script
# سكريبت بدء تشغيل منصة وكيل الذكاء الاصطناعي محلياً
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print banner
print_banner() {
    echo ""
    print_message "$BLUE" "╔════════════════════════════════════════════════════════════════════╗"
    print_message "$BLUE" "║         AI Agent Platform - Local Development Server              ║"
    print_message "$BLUE" "║         منصة وكيل الذكاء الاصطناعي - خادم التطوير المحلي          ║"
    print_message "$BLUE" "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Check if Python is installed
check_python() {
    if ! command -v python3 &> /dev/null; then
        print_message "$RED" "❌ Python 3 is not installed. Please install Python 3.9 or higher."
        print_message "$RED" "❌ Python 3 غير مثبت. يرجى تثبيت Python 3.9 أو أعلى."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d ' ' -f 2)
    print_message "$GREEN" "✓ Python $PYTHON_VERSION found"
}

# Install dependencies
install_dependencies() {
    print_message "$YELLOW" "📦 Installing dependencies..."
    print_message "$YELLOW" "📦 جاري تثبيت المتطلبات..."
    
    if [ ! -d "venv" ]; then
        print_message "$YELLOW" "Creating virtual environment..."
        python3 -m venv venv
    fi
    
    source venv/bin/activate
    pip install --upgrade pip > /dev/null 2>&1
    pip install -r requirements.txt > /dev/null 2>&1
    
    print_message "$GREEN" "✓ Dependencies installed successfully"
    print_message "$GREEN" "✓ تم تثبيت المتطلبات بنجاح"
}

# Start the Flask API server
start_flask_server() {
    print_message "$YELLOW" "🚀 Starting Flask API server..."
    print_message "$YELLOW" "🚀 جاري تشغيل خادم Flask API..."
    
    cd api
    python3 server.py &
    FLASK_PID=$!
    cd ..
    
    print_message "$GREEN" "✓ Flask API server started (PID: $FLASK_PID)"
    print_message "$GREEN" "✓ تم تشغيل خادم Flask API"
}

# Start simple HTTP server for frontend
start_http_server() {
    print_message "$YELLOW" "🌐 Starting web interface server..."
    print_message "$YELLOW" "🌐 جاري تشغيل خادم واجهة الويب..."
    
    python3 -m http.server 8080 &
    HTTP_PID=$!
    
    print_message "$GREEN" "✓ Web interface server started (PID: $HTTP_PID)"
    print_message "$GREEN" "✓ تم تشغيل خادم واجهة الويب"
}

# Display access information
display_info() {
    echo ""
    print_message "$BLUE" "╔════════════════════════════════════════════════════════════════════╗"
    print_message "$BLUE" "║                    Server Information                              ║"
    print_message "$BLUE" "║                    معلومات الخادم                                 ║"
    print_message "$BLUE" "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
    
    print_message "$GREEN" "📍 Web Interface / واجهة الويب:"
    print_message "$YELLOW" "   Home Page:    http://localhost:8080"
    print_message "$YELLOW" "   الصفحة الرئيسية:    http://localhost:8080/index.html"
    print_message "$YELLOW" "   Actions Page: http://localhost:8080/actions.html"
    print_message "$YELLOW" "   صفحة الإجراءات:    http://localhost:8080/actions.html"
    echo ""
    
    print_message "$GREEN" "📍 API Endpoints / نقاط نهاية API:"
    print_message "$YELLOW" "   Health Check: http://localhost:5000/api/health"
    print_message "$YELLOW" "   فحص الصحة:    http://localhost:5000/api/health"
    print_message "$YELLOW" "   Status:       http://localhost:5000/api/status"
    print_message "$YELLOW" "   الحالة:       http://localhost:5000/api/status"
    print_message "$YELLOW" "   Process:      http://localhost:5000/api/process"
    print_message "$YELLOW" "   المعالجة:     http://localhost:5000/api/process"
    echo ""
    
    print_message "$BLUE" "╔════════════════════════════════════════════════════════════════════╗"
    print_message "$BLUE" "║                    Access Instructions                             ║"
    print_message "$BLUE" "║                    تعليمات الوصول                                 ║"
    print_message "$BLUE" "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_message "$GREEN" "1. Open your browser / افتح المتصفح"
    print_message "$GREEN" "2. Navigate to / انتقل إلى: http://localhost:8080"
    print_message "$GREEN" "3. Click 'Actions Page' button / اضغط على زر 'صفحة الإجراءات'"
    print_message "$GREEN" "4. Interact with the AI agent / تفاعل مع وكيل الذكاء الاصطناعي"
    echo ""
    print_message "$YELLOW" "⚠️  Press Ctrl+C to stop all servers / اضغط Ctrl+C لإيقاف جميع الخوادم"
    echo ""
}

# Save PIDs to file
save_pids() {
    echo "$FLASK_PID" > .server_pids
    echo "$HTTP_PID" >> .server_pids
}

# Cleanup function
cleanup() {
    echo ""
    print_message "$YELLOW" "🛑 Stopping servers..."
    print_message "$YELLOW" "🛑 جاري إيقاف الخوادم..."
    
    if [ -f ".server_pids" ]; then
        while read pid; do
            kill $pid 2>/dev/null || true
        done < .server_pids
        rm .server_pids
    fi
    
    # Kill any remaining processes
    pkill -f "python3 -m http.server 8080" 2>/dev/null || true
    pkill -f "python3 server.py" 2>/dev/null || true
    
    print_message "$GREEN" "✓ All servers stopped"
    print_message "$GREEN" "✓ تم إيقاف جميع الخوادم"
    exit 0
}

# Main execution
main() {
    # Print banner
    print_banner
    
    # Check prerequisites
    check_python
    
    # Install dependencies
    install_dependencies
    
    # Start servers
    start_flask_server
    sleep 2
    start_http_server
    sleep 2
    
    # Save PIDs
    save_pids
    
    # Display information
    display_info
    
    # Set up cleanup on exit
    trap cleanup EXIT INT TERM
    
    # Keep script running
    while true; do
        sleep 1
    done
}

# Run main function
main
