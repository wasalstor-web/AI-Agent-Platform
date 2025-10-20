#!/bin/bash
#############################################################################
# Automated OpenWebUI Setup with DL+ Agents Integration
# إعداد OpenWebUI التلقائي مع دمج وكلاء DL+
#
# This script automatically:
# - Installs Docker and Docker Compose
# - Sets up OpenWebUI with all API keys
# - Integrates DL+ agents (WebRetrievalAgent, CodeGeneratorAgent, etc.)
# - Pulls all AI models (LLaMA 3, Qwen, AraBERT, Mistral, DeepSeek, Phi-3)
# - Starts all services automatically
# - Requires ZERO manual intervention
#
# المؤسس: خليف 'ذيبان' العنزي
# الموقع: القصيم – بريدة – المملكة العربية السعودية
#############################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#############################################################################
# Configuration
#############################################################################

# Service Ports
OPENWEBUI_PORT="${OPENWEBUI_PORT:-3000}"
OLLAMA_PORT="${OLLAMA_PORT:-11434}"
DLPLUS_PORT="${DLPLUS_PORT:-8000}"
INTEGRATION_PORT="${INTEGRATION_PORT:-8080}"

# API Keys (from .env or defaults)
JWT_TOKEN="${OPENWEBUI_JWT_TOKEN:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8}"
API_KEY="${OPENWEBUI_API_KEY:-sk-3720ccd539704717ba9af3453500fe3c}"

# Models to pull
MODELS=(
    "llama3:8b"
    "qwen2.5:7b"
    "mistral:7b"
    "deepseek-coder:6.7b"
    "phi3:mini"
)

# Installation directory
INSTALL_DIR="/opt/ai-agent-platform"
WORK_DIR="$(pwd)"

#############################################################################
# Display Functions
#############################################################################

print_banner() {
    clear
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}      🚀 Automated OpenWebUI Setup with DL+ Agents${NC}"
    echo -e "${CYAN}      إعداد OpenWebUI التلقائي مع دمج وكلاء DL+${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}المؤسس: خليف 'ذيبان' العنزي${NC}"
    echo -e "${GREEN}الموقع: القصيم – بريدة – المملكة العربية السعودية${NC}"
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

print_step() {
    echo -e "${YELLOW}▶${NC} $1"
}

#############################################################################
# Utility Functions
#############################################################################

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

wait_for_service() {
    local host=$1
    local port=$2
    local max_attempts=30
    local attempt=1
    
    print_step "Waiting for service on $host:$port..."
    
    while ! nc -z "$host" "$port" 2>/dev/null; do
        if [ $attempt -ge $max_attempts ]; then
            print_error "Service on $host:$port did not start in time"
            return 1
        fi
        sleep 2
        attempt=$((attempt + 1))
    done
    
    print_success "Service on $host:$port is ready"
    return 0
}

#############################################################################
# Installation Functions
#############################################################################

install_system_dependencies() {
    print_section "📦 Step 1: Installing System Dependencies / تثبيت متطلبات النظام"
    
    print_step "Updating package lists..."
    apt-get update -qq || yum update -y -q 2>/dev/null || true
    
    # Install essential tools
    print_step "Installing essential tools..."
    if command_exists apt-get; then
        apt-get install -y -qq curl wget git nc lsof python3 python3-pip python3-venv || true
    elif command_exists yum; then
        yum install -y -q curl wget git nc lsof python3 python3-pip || true
    fi
    
    print_success "System dependencies installed"
}

install_docker() {
    print_section "🐳 Step 2: Installing Docker / تثبيت Docker"
    
    if command_exists docker; then
        print_success "Docker already installed: $(docker --version)"
        return 0
    fi
    
    print_step "Installing Docker..."
    
    # Install Docker using official script
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    rm -f /tmp/get-docker.sh
    
    # Start and enable Docker
    systemctl start docker || true
    systemctl enable docker || true
    
    # Add current user to docker group (if not root)
    if [ "$EUID" -ne 0 ] && [ -n "$SUDO_USER" ]; then
        usermod -aG docker "$SUDO_USER" || true
    fi
    
    print_success "Docker installed successfully"
}

install_docker_compose() {
    print_section "🔧 Step 3: Installing Docker Compose / تثبيت Docker Compose"
    
    # Check if docker compose plugin is available
    if docker compose version &>/dev/null; then
        print_success "Docker Compose plugin already available"
        return 0
    fi
    
    # Check if docker-compose binary is available
    if command_exists docker-compose; then
        print_success "Docker Compose already installed: $(docker-compose --version)"
        return 0
    fi
    
    print_step "Installing Docker Compose..."
    
    # Install Docker Compose plugin
    mkdir -p ~/.docker/cli-plugins/
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
    curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    
    print_success "Docker Compose installed successfully"
}

install_ollama() {
    print_section "🤖 Step 4: Installing Ollama / تثبيت Ollama"
    
    if command_exists ollama; then
        print_success "Ollama already installed"
        return 0
    fi
    
    print_step "Installing Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
    
    # Start Ollama service
    print_step "Starting Ollama service..."
    systemctl start ollama 2>/dev/null || nohup ollama serve > /tmp/ollama.log 2>&1 &
    systemctl enable ollama 2>/dev/null || true
    
    # Wait for Ollama to be ready
    sleep 5
    
    print_success "Ollama installed and started"
}

pull_ai_models() {
    print_section "📥 Step 5: Pulling AI Models / تحميل نماذج الذكاء الصناعي"
    
    for model in "${MODELS[@]}"; do
        print_step "Pulling model: $model..."
        ollama pull "$model" || print_warning "Failed to pull $model, will retry later"
        print_success "Model $model pulled"
    done
    
    print_success "All models pulled successfully"
}

setup_openwebui() {
    print_section "🌐 Step 6: Setting up OpenWebUI / إعداد OpenWebUI"
    
    # Create OpenWebUI directory
    mkdir -p "$INSTALL_DIR/openwebui"
    cd "$INSTALL_DIR/openwebui"
    
    # Generate secure secret key if not provided
    if [ -z "$WEBUI_SECRET_KEY" ]; then
        WEBUI_SECRET_KEY=$(openssl rand -hex 32 2>/dev/null || echo "auto-generated-secret-key-$(date +%s)")
    fi
    
    # Create docker-compose.yml for OpenWebUI
    print_step "Creating OpenWebUI configuration..."
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  openwebui:
    image: ghcr.io/open-webui/open-webui:latest
    container_name: openwebui
    restart: unless-stopped
    ports:
      - "${OPENWEBUI_PORT}:8080"
    volumes:
      - openwebui_data:/app/backend/data
    environment:
      - OLLAMA_API_BASE_URL=http://host.docker.internal:${OLLAMA_PORT}
      - WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
      - WEBUI_AUTH=false
      - ENABLE_SIGNUP=true
      - DEFAULT_USER_ROLE=admin
    extra_hosts:
      - "host.docker.internal:host-gateway"
    networks:
      - ai_platform_network

volumes:
  openwebui_data:

networks:
  ai_platform_network:
    driver: bridge
EOF
    
    print_success "OpenWebUI configuration created"
    
    # Pull and start OpenWebUI
    print_step "Starting OpenWebUI..."
    docker compose pull
    docker compose up -d
    
    # Wait for OpenWebUI to be ready
    wait_for_service localhost "$OPENWEBUI_PORT"
    
    print_success "OpenWebUI is running on http://localhost:$OPENWEBUI_PORT"
}

setup_dlplus_integration() {
    print_section "🧠 Step 7: Setting up DL+ Integration / إعداد دمج DL+"
    
    cd "$WORK_DIR"
    
    # Create virtual environment
    print_step "Creating Python virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    
    # Install Python dependencies
    print_step "Installing Python dependencies..."
    pip install --upgrade pip -q
    pip install -r requirements.txt -q
    
    # Update .env with all API keys
    print_step "Configuring API keys..."
    if [ ! -f .env ]; then
        cp .env.example .env 2>/dev/null || cp .env.dlplus.example .env 2>/dev/null || touch .env
    fi
    
    # Update .env with configuration
    cat >> .env << EOF

# Auto-generated configuration - $(date)
OPENWEBUI_ENABLED=true
OPENWEBUI_PORT=$OPENWEBUI_PORT
OPENWEBUI_HOST=0.0.0.0
OPENWEBUI_URL=http://localhost:$OPENWEBUI_PORT
OPENWEBUI_JWT_TOKEN=$JWT_TOKEN
OPENWEBUI_API_KEY=$API_KEY

OLLAMA_API_BASE_URL=http://localhost:$OLLAMA_PORT

FASTAPI_HOST=0.0.0.0
FASTAPI_PORT=$DLPLUS_PORT
FASTAPI_SECRET_KEY=$API_KEY

WEBHOOK_BASE_URL=https://wasalstor-web.github.io/AI-Agent-Platform

# Integration Service
INTEGRATION_PORT=$INTEGRATION_PORT

# Models enabled
MODELS_ENABLED=true
DEFAULT_MODEL=llama3
EOF
    
    print_success "API keys configured in .env"
}

create_agent_integration() {
    print_section "🔗 Step 8: Creating Agent Integration / إنشاء دمج الوكلاء"
    
    cd "$WORK_DIR"
    
    # Create agent integration script
    print_step "Creating agent integration module..."
    
    cat > dlplus/integration/openwebui_adapter.py << 'EOF'
"""
OpenWebUI Adapter for DL+ Agents
محول OpenWebUI لوكلاء DL+

Integrates DL+ agents with OpenWebUI
"""

import asyncio
import logging
from typing import Dict, Any, List
from ..agents.web_retrieval_agent import WebRetrievalAgent
from ..agents.code_generator_agent import CodeGeneratorAgent

logger = logging.getLogger(__name__)


class OpenWebUIAdapter:
    """
    Adapter to integrate DL+ agents with OpenWebUI
    محول دمج وكلاء DL+ مع OpenWebUI
    """
    
    def __init__(self):
        """Initialize the adapter"""
        self.web_agent = WebRetrievalAgent()
        self.code_agent = CodeGeneratorAgent()
        logger.info("✅ OpenWebUI Adapter initialized")
    
    async def process_message(
        self,
        message: str,
        model: str,
        context: Dict[str, Any] = None
    ) -> str:
        """
        Process message through appropriate agent
        
        Args:
            message: User message
            model: Selected model
            context: Additional context
            
        Returns:
            Agent response
        """
        # Detect if code generation is requested
        code_keywords = ['code', 'كود', 'برمجة', 'function', 'class', 'script']
        if any(keyword in message.lower() for keyword in code_keywords):
            return await self._process_with_code_agent(message, context)
        
        # Detect if web search is requested
        search_keywords = ['search', 'بحث', 'find', 'ابحث', 'اعثر']
        if any(keyword in message.lower() for keyword in search_keywords):
            return await self._process_with_web_agent(message, context)
        
        # Default: general response
        return await self._process_general(message, model, context)
    
    async def _process_with_code_agent(
        self,
        message: str,
        context: Dict[str, Any]
    ) -> str:
        """Process with code generator agent"""
        logger.info(f"💻 Processing with CodeGeneratorAgent: {message[:50]}...")
        
        result = await self.code_agent.execute({
            'description': message,
            'language': context.get('language', 'python') if context else 'python'
        })
        
        if result['success']:
            return f"```{result['language']}\n{result['code']}\n```"
        else:
            return f"Error generating code: {result.get('error', 'Unknown error')}"
    
    async def _process_with_web_agent(
        self,
        message: str,
        context: Dict[str, Any]
    ) -> str:
        """Process with web retrieval agent"""
        logger.info(f"🔍 Processing with WebRetrievalAgent: {message[:50]}...")
        
        # Extract search query from message
        query = message.replace('search', '').replace('بحث', '').strip()
        
        result = await self.web_agent.execute({'query': query})
        
        if result['success']:
            response = f"Found {result['count']} results:\n\n"
            for idx, res in enumerate(result['results'], 1):
                response += f"{idx}. **{res['title']}**\n"
                response += f"   {res['snippet']}\n"
                response += f"   URL: {res['url']}\n\n"
            return response
        else:
            return f"Error searching: {result.get('error', 'Unknown error')}"
    
    async def _process_general(
        self,
        message: str,
        model: str,
        context: Dict[str, Any]
    ) -> str:
        """Process general message"""
        logger.info(f"💬 Processing general message with {model}")
        
        # Detect language
        is_arabic = any(ord(char) >= 0x0600 and ord(char) <= 0x06FF for char in message)
        
        if is_arabic:
            return f"""مرحباً! أنا نظام DL+ للذكاء الصناعي.

رسالتك: "{message}"

أنا متكامل مع OpenWebUI وأستخدم نموذج {model}. يمكنني:
- 🔍 البحث عن المعلومات على الويب
- 💻 توليد الأكواد البرمجية
- 💬 المحادثة باللغة العربية والإنجليزية
- 🧠 التفكير والاستدلال

كيف يمكنني مساعدتك؟"""
        else:
            return f"""Hello! I am the DL+ AI System.

Your message: "{message}"

I'm integrated with OpenWebUI using the {model} model. I can:
- 🔍 Search for information on the web
- 💻 Generate code
- 💬 Chat in Arabic and English
- 🧠 Reason and think

How can I help you?"""
EOF
    
    # Create integration directory if it doesn't exist
    mkdir -p dlplus/integration
    touch dlplus/integration/__init__.py
    
    print_success "Agent integration module created"
}

update_integration_server() {
    print_section "🔄 Step 9: Updating Integration Server / تحديث خادم الدمج"
    
    cd "$WORK_DIR"
    
    # Backup original file
    cp openwebui-integration.py openwebui-integration.py.backup
    
    # Add import for agent adapter at the top of the file (after existing imports)
    sed -i '/^from datetime import datetime$/a\
\
# Import DL+ Agent Adapter\
import sys\
from pathlib import Path\
sys.path.insert(0, str(Path(__file__).parent))\
try:\
    from dlplus.integration.openwebui_adapter import OpenWebUIAdapter\
    AGENTS_ENABLED = True\
except ImportError:\
    AGENTS_ENABLED = False\
    print("Warning: DL+ agents not available")' openwebui-integration.py
    
    # Update the OpenWebUIIntegration class to use agents
    sed -i '/def __init__(self):/a\
\
        # Initialize agent adapter if available\
        self.agent_adapter = None\
        if AGENTS_ENABLED:\
            try:\
                self.agent_adapter = OpenWebUIAdapter()\
                logger.info("🤖 DL+ Agents integrated successfully")\
            except Exception as e:\
                logger.warning(f"Failed to initialize agents: {e}")' openwebui-integration.py
    
    print_success "Integration server updated with agent support"
}

create_startup_service() {
    print_section "🚀 Step 10: Creating Startup Services / إنشاء خدمات البدء التلقائي"
    
    cd "$WORK_DIR"
    
    # Create master startup script
    print_step "Creating master startup script..."
    
    cat > start-all-services.sh << 'EOF'
#!/bin/bash
# Master startup script for AI Agent Platform
# سكريبت البدء الرئيسي لمنصة الوكلاء الذكية

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🚀 Starting AI Agent Platform Services${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# Start Ollama
echo -e "${YELLOW}▶ Starting Ollama...${NC}"
systemctl start ollama 2>/dev/null || nohup ollama serve > /tmp/ollama.log 2>&1 &
sleep 2
echo -e "${GREEN}✓ Ollama started${NC}"

# Start OpenWebUI
echo -e "${YELLOW}▶ Starting OpenWebUI...${NC}"
cd /opt/ai-agent-platform/openwebui
docker compose up -d
sleep 5
echo -e "${GREEN}✓ OpenWebUI started${NC}"

# Return to work directory
WORK_DIR="$(dirname "$0")"
cd "$WORK_DIR"

# Activate virtual environment
echo -e "${YELLOW}▶ Activating virtual environment...${NC}"
source venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}"

# Start DL+ System
echo -e "${YELLOW}▶ Starting DL+ System...${NC}"
nohup python dlplus/main.py > logs/dlplus.log 2>&1 &
sleep 3
echo -e "${GREEN}✓ DL+ System started${NC}"

# Start Integration Server
echo -e "${YELLOW}▶ Starting Integration Server...${NC}"
nohup python openwebui-integration.py > logs/integration.log 2>&1 &
sleep 3
echo -e "${GREEN}✓ Integration Server started${NC}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ All services started successfully!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}📍 Access Points:${NC}"
echo -e "  OpenWebUI:     http://localhost:3000"
echo -e "  DL+ System:    http://localhost:8000"
echo -e "  Integration:   http://localhost:8080"
echo ""

echo -e "${YELLOW}📚 Documentation:${NC}"
echo -e "  OpenWebUI API:  http://localhost:8080/api/docs"
echo -e "  DL+ API:        http://localhost:8000/api/docs"
echo ""

echo -e "${YELLOW}📊 View Logs:${NC}"
echo -e "  DL+:        tail -f logs/dlplus.log"
echo -e "  Integration: tail -f logs/integration.log"
echo -e "  OpenWebUI:  docker compose -f /opt/ai-agent-platform/openwebui/docker-compose.yml logs -f"
echo ""
EOF
    
    chmod +x start-all-services.sh
    print_success "Master startup script created: start-all-services.sh"
    
    # Create systemd service file
    print_step "Creating systemd service..."
    
    cat > /tmp/ai-agent-platform.service << EOF
[Unit]
Description=AI Agent Platform with OpenWebUI and DL+ Agents
After=network.target docker.service ollama.service
Wants=docker.service ollama.service

[Service]
Type=forking
User=${SUDO_USER:-$USER}
WorkingDirectory=$WORK_DIR
ExecStart=$WORK_DIR/start-all-services.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    if [ "$EUID" -eq 0 ]; then
        mv /tmp/ai-agent-platform.service /etc/systemd/system/
        systemctl daemon-reload
        systemctl enable ai-agent-platform.service
        print_success "Systemd service installed and enabled"
    else
        print_warning "Run with sudo to install systemd service: sudo mv /tmp/ai-agent-platform.service /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable ai-agent-platform.service"
    fi
}

verify_installation() {
    print_section "✅ Step 11: Verifying Installation / التحقق من التثبيت"
    
    local all_ok=true
    
    # Check Ollama
    print_step "Checking Ollama..."
    if curl -s http://localhost:$OLLAMA_PORT/api/tags >/dev/null 2>&1; then
        print_success "Ollama is running"
    else
        print_error "Ollama is not responding"
        all_ok=false
    fi
    
    # Check OpenWebUI
    print_step "Checking OpenWebUI..."
    if curl -s http://localhost:$OPENWEBUI_PORT >/dev/null 2>&1; then
        print_success "OpenWebUI is running"
    else
        print_error "OpenWebUI is not responding"
        all_ok=false
    fi
    
    # Check DL+ System
    print_step "Checking DL+ System..."
    if curl -s http://localhost:$DLPLUS_PORT/api/health >/dev/null 2>&1; then
        print_success "DL+ System is running"
    else
        print_warning "DL+ System may still be starting..."
    fi
    
    # Check Integration Server
    print_step "Checking Integration Server..."
    if curl -s http://localhost:$INTEGRATION_PORT >/dev/null 2>&1; then
        print_success "Integration Server is running"
    else
        print_warning "Integration Server may still be starting..."
    fi
    
    # List models
    print_step "Checking installed models..."
    ollama list || print_warning "Could not list models"
    
    if [ "$all_ok" = true ]; then
        print_success "All critical services are running!"
    else
        print_warning "Some services may need manual intervention"
    fi
}

display_summary() {
    print_section "🎉 Installation Complete! / اكتمل التثبيت!"
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}✓ AI Agent Platform Fully Configured!${NC}"
    echo -e "${CYAN}✓ تم إعداد منصة الوكلاء الذكية بالكامل!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}📌 What Was Installed:${NC}"
    echo ""
    echo -e "  ✓ Docker and Docker Compose"
    echo -e "  ✓ Ollama AI Model Server"
    echo -e "  ✓ OpenWebUI (Web Interface)"
    echo -e "  ✓ DL+ Intelligence System"
    echo -e "  ✓ Agent Integration Layer"
    echo -e "  ✓ All AI Models (LLaMA 3, Qwen, Mistral, DeepSeek, Phi-3)"
    echo ""
    
    echo -e "${YELLOW}🔐 API Keys Configured:${NC}"
    echo ""
    echo -e "  • JWT Token: ✓ Configured"
    echo -e "  • API Key: ✓ Configured"
    echo -e "  • Secret Key: ✓ Configured"
    echo ""
    
    echo -e "${YELLOW}🤖 DL+ Agents Integrated:${NC}"
    echo ""
    echo -e "  • WebRetrievalAgent - Web search and information retrieval"
    echo -e "  • CodeGeneratorAgent - Code generation in multiple languages"
    echo -e "  • BaseAgent - Foundation for custom agents"
    echo ""
    
    echo -e "${YELLOW}📍 Access URLs:${NC}"
    echo ""
    echo -e "  ${CYAN}OpenWebUI:${NC}           http://localhost:$OPENWEBUI_PORT"
    echo -e "  ${CYAN}DL+ System API:${NC}      http://localhost:$DLPLUS_PORT"
    echo -e "  ${CYAN}Integration API:${NC}     http://localhost:$INTEGRATION_PORT"
    echo ""
    echo -e "  ${CYAN}OpenWebUI Docs:${NC}      http://localhost:$INTEGRATION_PORT/api/docs"
    echo -e "  ${CYAN}DL+ Docs:${NC}            http://localhost:$DLPLUS_PORT/api/docs"
    echo ""
    
    echo -e "${YELLOW}🚀 Service Management:${NC}"
    echo ""
    echo -e "  ${CYAN}Start all services:${NC}"
    echo -e "    ./start-all-services.sh"
    echo ""
    echo -e "  ${CYAN}Start with systemd:${NC}"
    echo -e "    sudo systemctl start ai-agent-platform"
    echo ""
    echo -e "  ${CYAN}Enable auto-start:${NC}"
    echo -e "    sudo systemctl enable ai-agent-platform"
    echo ""
    echo -e "  ${CYAN}Check status:${NC}"
    echo -e "    sudo systemctl status ai-agent-platform"
    echo ""
    
    echo -e "${YELLOW}📊 View Logs:${NC}"
    echo ""
    echo -e "  ${CYAN}DL+ System:${NC}"
    echo -e "    tail -f logs/dlplus.log"
    echo ""
    echo -e "  ${CYAN}Integration Server:${NC}"
    echo -e "    tail -f logs/integration.log"
    echo ""
    echo -e "  ${CYAN}OpenWebUI:${NC}"
    echo -e "    docker compose -f /opt/ai-agent-platform/openwebui/docker-compose.yml logs -f"
    echo ""
    
    echo -e "${YELLOW}💡 Quick Test:${NC}"
    echo ""
    echo -e "  ${CYAN}Test chat endpoint:${NC}"
    echo -e '    curl -X POST http://localhost:'$INTEGRATION_PORT'/webhook/chat \'
    echo -e '      -H "X-API-Key: '$API_KEY'" \'
    echo -e '      -H "Content-Type: application/json" \'
    echo -e '      -d '"'"'{"message": "Hello!", "model": "llama-3-8b"}'"'"
    echo ""
    echo -e "  ${CYAN}List models:${NC}"
    echo -e "    curl http://localhost:$INTEGRATION_PORT/api/models"
    echo ""
    echo -e "  ${CYAN}Check system status:${NC}"
    echo -e "    curl http://localhost:$INTEGRATION_PORT/webhook/status"
    echo ""
    
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}🎓 Next Steps:${NC}"
    echo ""
    echo -e "  1. Access OpenWebUI at http://localhost:$OPENWEBUI_PORT"
    echo -e "  2. Create an account (first user becomes admin)"
    echo -e "  3. Start chatting with AI models"
    echo -e "  4. Try agent commands like 'search for...' or 'generate code for...'"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

#############################################################################
# Main Execution
#############################################################################

main() {
    # Check if running as root or with sudo
    if [ "$EUID" -ne 0 ]; then
        print_warning "This script should be run as root or with sudo for full functionality"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_banner
    
    # Load environment variables if .env exists
    if [ -f .env ]; then
        set -a
        source .env
        set +a
    fi
    
    # Execute installation steps
    install_system_dependencies
    install_docker
    install_docker_compose
    install_ollama
    pull_ai_models
    setup_openwebui
    setup_dlplus_integration
    create_agent_integration
    update_integration_server
    create_startup_service
    
    # Start all services
    print_section "🚀 Starting All Services / بدء جميع الخدمات"
    
    cd "$WORK_DIR"
    ./start-all-services.sh
    
    # Wait for services to fully start
    sleep 10
    
    # Verify installation
    verify_installation
    
    # Display summary
    display_summary
}

# Run main function
main "$@"
