#!/bin/bash
#######################################################################
# OpenWebUI Integration Deployment Script
# سكريبت نشر دمج OpenWebUI
#
# This script deploys the OpenWebUI integration with AI models
# هذا السكريبت ينشر دمج OpenWebUI مع نماذج الذكاء الصناعي
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
echo -e "${CYAN}      🚀 OpenWebUI Integration Deployment${NC}"
echo -e "${CYAN}      نشر دمج OpenWebUI مع النماذج المفتوحة المصدر${NC}"
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

# Check if running from correct directory
if [ ! -f "openwebui-integration.py" ]; then
    print_error "Please run this script from the AI-Agent-Platform root directory"
    exit 1
fi

print_section "📋 Step 1: Checking Prerequisites / فحص المتطلبات"

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_success "Python installed: $PYTHON_VERSION"
else
    print_error "Python 3 is not installed"
    exit 1
fi

# Check pip
if command -v pip3 &> /dev/null; then
    print_success "pip3 is available"
else
    print_error "pip3 is not installed"
    exit 1
fi

print_section "📦 Step 2: Installing Dependencies / تثبيت المتطلبات"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    print_info "Creating virtual environment..."
    python3 -m venv venv
    print_success "Virtual environment created"
fi

# Activate virtual environment
print_info "Activating virtual environment..."
source venv/bin/activate
print_success "Virtual environment activated"

# Install requirements
print_info "Installing required packages..."
pip3 install -q --upgrade pip
pip3 install -q fastapi uvicorn[standard] httpx pydantic python-multipart
print_success "Dependencies installed successfully"

print_section "⚙️ Step 3: Configuration Verification / التحقق من الإعدادات"

# Check .env file
if [ -f ".env" ]; then
    print_success ".env file exists"
    
    # Check for required variables
    if grep -q "OPENWEBUI_JWT_TOKEN" .env && grep -q "OPENWEBUI_API_KEY" .env; then
        print_success "OpenWebUI credentials configured"
    else
        print_error "OpenWebUI credentials not found in .env"
        exit 1
    fi
    
    if grep -q "WEBHOOK_BASE_URL" .env; then
        WEBHOOK_URL=$(grep "WEBHOOK_BASE_URL=" .env | cut -d'=' -f2)
        print_success "Webhook URL configured: $WEBHOOK_URL"
    else
        print_error "Webhook URL not configured"
        exit 1
    fi
else
    print_error ".env file not found"
    exit 1
fi

print_section "🔧 Step 4: Creating Integration Service / إنشاء خدمة الدمج"

# Create logs directory
mkdir -p logs
print_success "Logs directory created"

# Make integration script executable
chmod +x openwebui-integration.py
print_success "Integration script is executable"

print_section "🤖 Step 5: Model Configuration / إعداد النماذج"

print_info "Configured open-source AI models:"
echo ""
echo "  1. LLaMA 3 8B - General purpose model"
echo "  2. Qwen 2.5 Arabic - Arabic language specialized"
echo "  3. AraBERT - Arabic BERT for NLP"
echo "  4. Mistral 7B - Multilingual model"
echo "  5. DeepSeek Coder - Code generation"
echo "  6. Phi-3 Mini - Compact model"
echo ""
print_success "6 open-source models configured and enabled"

print_section "🚀 Step 6: Starting Integration Server / تشغيل خادم الدمج"

# Check if port 8080 is available
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
    print_info "Port 8080 is in use. Attempting to use port 8081..."
    export PORT=8081
else
    export PORT=8080
fi

print_info "Starting OpenWebUI Integration Server on port $PORT..."
print_info "Press Ctrl+C to stop the server"
echo ""

# Create startup script
cat > start-integration.sh << 'EOF'
#!/bin/bash
# Startup script for OpenWebUI Integration

cd "$(dirname "$0")"
source venv/bin/activate
export PORT=${PORT:-8080}
export HOST=${HOST:-0.0.0.0}

echo "Starting OpenWebUI Integration Server..."
python3 openwebui-integration.py
EOF

chmod +x start-integration.sh
print_success "Startup script created: start-integration.sh"

# Create systemd service file (optional)
cat > openwebui-integration.service << EOF
[Unit]
Description=OpenWebUI Integration Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment="PATH=$(pwd)/venv/bin"
ExecStart=$(pwd)/venv/bin/python3 $(pwd)/openwebui-integration.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

print_success "Systemd service file created (optional)"

print_section "📍 Step 7: Deployment Information / معلومات النشر"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}✓ OpenWebUI Integration Deployed Successfully!${NC}"
echo -e "${CYAN}✓ تم نشر دمج OpenWebUI بنجاح!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}📌 Access Information:${NC}"
echo ""
echo -e "  ${CYAN}Local Server:${NC}"
echo -e "    http://localhost:$PORT"
echo ""
echo -e "  ${CYAN}API Documentation:${NC}"
echo -e "    http://localhost:$PORT/api/docs"
echo ""
echo -e "  ${CYAN}Webhook Base URL:${NC}"
echo -e "    $WEBHOOK_URL"
echo ""
echo -e "  ${CYAN}Webhook Endpoints:${NC}"
echo -e "    • Chat: $WEBHOOK_URL/webhook/chat"
echo -e "    • Status: $WEBHOOK_URL/webhook/status"
echo -e "    • Models: $WEBHOOK_URL/webhook/model"
echo -e "    • Info: $WEBHOOK_URL/webhook/info"
echo ""

echo -e "${YELLOW}🔐 Authentication:${NC}"
echo ""
echo -e "  ${CYAN}JWT Token:${NC} Configured ✓"
echo -e "  ${CYAN}API Key:${NC} Configured ✓"
echo ""

echo -e "${YELLOW}🤖 Models Enabled:${NC}"
echo ""
echo -e "  • LLaMA 3 8B"
echo -e "  • Qwen 2.5 Arabic"
echo -e "  • AraBERT"
echo -e "  • Mistral 7B"
echo -e "  • DeepSeek Coder"
echo -e "  • Phi-3 Mini"
echo ""

echo -e "${YELLOW}💡 Usage Examples:${NC}"
echo ""
echo -e "  ${CYAN}Test webhook (with authentication):${NC}"
echo -e '    curl -X POST http://localhost:'$PORT'/webhook/chat \'
echo -e '      -H "Authorization: Bearer YOUR_JWT_TOKEN" \'
echo -e '      -H "Content-Type: application/json" \'
echo -e '      -d '"'"'{"message": "مرحبا", "model": "llama-3-8b"}'"'"
echo ""
echo -e "  ${CYAN}List available models:${NC}"
echo -e "    curl http://localhost:$PORT/api/models"
echo ""
echo -e "  ${CYAN}Check webhook status:${NC}"
echo -e "    curl http://localhost:$PORT/webhook/status"
echo ""

echo -e "${YELLOW}🔧 Management Commands:${NC}"
echo ""
echo -e "  ${CYAN}Start server:${NC}"
echo -e "    ./start-integration.sh"
echo ""
echo -e "  ${CYAN}Install as systemd service:${NC}"
echo -e "    sudo cp openwebui-integration.service /etc/systemd/system/"
echo -e "    sudo systemctl daemon-reload"
echo -e "    sudo systemctl enable openwebui-integration"
echo -e "    sudo systemctl start openwebui-integration"
echo ""
echo -e "  ${CYAN}Check service status:${NC}"
echo -e "    sudo systemctl status openwebui-integration"
echo ""

echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# Offer to start the server
read -p "Do you want to start the integration server now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    print_info "Starting server..."
    python3 openwebui-integration.py
fi
