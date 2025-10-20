#!/bin/bash

# Quick Start Script for AI Agent Platform
# سكريبت البدء السريع لمنصة وكيل الذكاء الاصطناعي

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Header
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}    🚀 AI Agent Platform - Quick Start${NC}"
echo -e "${CYAN}    منصة وكيل الذكاء الاصطناعي - البدء السريع${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to print info
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check Python installation
print_info "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_success "Python found: $PYTHON_VERSION"
else
    print_error "Python 3 is not installed"
    exit 1
fi

# Check if requirements.txt exists
if [ -f "requirements.txt" ]; then
    print_info "Installing Python dependencies..."
    pip3 install -q flask flask-cors 2>/dev/null || {
        print_warning "Some packages may already be installed"
    }
    print_success "Dependencies ready"
else
    print_warning "requirements.txt not found, installing basic dependencies..."
    pip3 install -q flask flask-cors
fi

# Menu
echo ""
echo -e "${CYAN}Select an option / اختر خياراً:${NC}"
echo ""
echo "1) Start Flask API Server (Port 5000)"
echo "   تشغيل خادم Flask API (المنفذ 5000)"
echo ""
echo "2) Start DL+ System (Port 8000)"
echo "   تشغيل نظام DL+ (المنفذ 8000)"
echo ""
echo "3) Start Web Server (Port 8080)"
echo "   تشغيل خادم الويب (المنفذ 8080)"
echo ""
echo "4) Start All Services"
echo "   تشغيل جميع الخدمات"
echo ""
echo "5) View Chat Interface"
echo "   عرض واجهة الدردشة"
echo ""
echo -n "Enter your choice / أدخل اختيارك [1-5]: "
read choice

case $choice in
    1)
        print_info "Starting Flask API Server..."
        echo ""
        print_success "API Server starting at http://localhost:5000"
        print_info "Endpoints:"
        echo "  - GET  http://localhost:5000/api/health"
        echo "  - GET  http://localhost:5000/api/status"
        echo "  - POST http://localhost:5000/api/process"
        echo "  - GET  http://localhost:5000/api/models"
        echo ""
        print_info "Press Ctrl+C to stop"
        echo ""
        cd api && python3 server.py
        ;;
    2)
        print_info "Starting DL+ System..."
        if [ -f "dlplus/main.py" ]; then
            echo ""
            print_success "DL+ System starting at http://localhost:8000"
            print_info "Endpoints:"
            echo "  - GET  http://localhost:8000/api/health"
            echo "  - GET  http://localhost:8000/api/status"
            echo "  - POST http://localhost:8000/api/process"
            echo "  - GET  http://localhost:8000/api/docs (Interactive API docs)"
            echo ""
            print_info "Press Ctrl+C to stop"
            echo ""
            cd dlplus && python3 main.py
        else
            print_error "DL+ system not found"
            exit 1
        fi
        ;;
    3)
        print_info "Starting Web Server..."
        echo ""
        print_success "Web interface available at:"
        echo "  http://localhost:8080/index.html"
        echo ""
        print_info "Press Ctrl+C to stop"
        echo ""
        python3 -m http.server 8080
        ;;
    4)
        print_info "Starting all services..."
        echo ""
        
        # Start Flask API in background
        print_info "Starting Flask API Server (Port 5000)..."
        cd api && python3 server.py &> /tmp/flask-api.log &
        FLASK_PID=$!
        sleep 2
        
        if ps -p $FLASK_PID > /dev/null; then
            print_success "Flask API running (PID: $FLASK_PID)"
        else
            print_error "Failed to start Flask API"
        fi
        
        # Start web server in background
        print_info "Starting Web Server (Port 8080)..."
        cd .. && python3 -m http.server 8080 &> /tmp/web-server.log &
        WEB_PID=$!
        sleep 1
        
        if ps -p $WEB_PID > /dev/null; then
            print_success "Web Server running (PID: $WEB_PID)"
        else
            print_error "Failed to start Web Server"
        fi
        
        echo ""
        print_success "All services started!"
        echo ""
        echo -e "${CYAN}Services:${NC}"
        echo "  - Flask API:      http://localhost:5000"
        echo "  - Web Interface:  http://localhost:8080/index.html"
        echo ""
        echo -e "${CYAN}Logs:${NC}"
        echo "  - Flask API: /tmp/flask-api.log"
        echo "  - Web Server: /tmp/web-server.log"
        echo ""
        print_info "Press Enter to stop all services..."
        read
        
        print_info "Stopping services..."
        kill $FLASK_PID $WEB_PID 2>/dev/null || true
        print_success "All services stopped"
        ;;
    5)
        print_info "Opening chat interface..."
        
        # Start web server if not running
        if ! lsof -i:8080 > /dev/null 2>&1; then
            print_info "Starting web server..."
            python3 -m http.server 8080 &> /dev/null &
            WEB_PID=$!
            sleep 2
        fi
        
        # Open browser
        URL="http://localhost:8080/index.html"
        print_success "Chat interface available at: $URL"
        
        if command -v xdg-open &> /dev/null; then
            xdg-open "$URL" 2>/dev/null
        elif command -v open &> /dev/null; then
            open "$URL" 2>/dev/null
        else
            print_warning "Please open $URL in your browser"
        fi
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

echo ""
print_success "Done!"
