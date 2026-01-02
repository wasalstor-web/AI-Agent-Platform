#!/bin/bash
# 🚀 Complete VPS Installation Script for AI Agent Platform
# سكربت التثبيت الكامل على VPS لمنصة الوكيل الذكي
# Author: Khalifa 'Dheban' Al-Anazi
# Date: 2025-01-XX

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   🚀 AI Agent Platform - Complete VPS Installation 🚀    ║"
echo "║   تثبيت كامل لمنصة الوكيل الذكي على VPS                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_DIR="/var/www/ai-agent-platform"
REPO_URL="https://github.com/wasalstor-web/AI-Agent-Platform.git"
DOMAIN="${1:-localhost}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}⚠️  Please do not run as root. Run as regular user with sudo access.${NC}"
   exit 1
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📋 Step 1/10: Updating system packages...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
sudo apt update -qq
sudo apt upgrade -y -qq

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📦 Step 2/10: Installing basic system packages...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
sudo apt install -y \
    python3 python3-pip python3-venv python3-dev \
    build-essential libssl-dev libffi-dev \
    git curl wget openssl \
    nginx \
    mysql-server redis-server \
    ufw certbot python3-certbot-nginx \
    >/dev/null 2>&1

echo -e "${GREEN}✅ Basic packages installed${NC}"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🐳 Step 3/10: Installing Docker and Docker Compose...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh >/dev/null 2>&1
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✅ Docker installed${NC}"
else
    echo -e "${BLUE}ℹ️  Docker already installed${NC}"
fi

if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✅ Docker Compose installed${NC}"
else
    echo -e "${BLUE}ℹ️  Docker Compose already installed${NC}"
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🦙 Step 4/10: Installing Ollama (optional)...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -p "Install Ollama? (y/n): " install_ollama
if [ "$install_ollama" = "y" ]; then
    if ! command -v ollama &> /dev/null; then
        curl -fsSL https://ollama.com/install.sh | sh >/dev/null 2>&1
        echo -e "${GREEN}✅ Ollama installed${NC}"
    else
        echo -e "${BLUE}ℹ️  Ollama already installed${NC}"
    fi
else
    echo -e "${BLUE}ℹ️  Skipping Ollama installation${NC}"
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📁 Step 5/10: Setting up project directory...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ -d "$PROJECT_DIR" ]; then
    echo -e "${BLUE}ℹ️  Project directory exists. Updating...${NC}"
    cd $PROJECT_DIR
    git pull origin main >/dev/null 2>&1
else
    sudo mkdir -p $PROJECT_DIR
    sudo chown -R $USER:$USER $PROJECT_DIR
    git clone $REPO_URL $PROJECT_DIR >/dev/null 2>&1
    cd $PROJECT_DIR
fi

echo -e "${GREEN}✅ Project directory ready${NC}"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🐍 Step 6/10: Setting up Python environment...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate
pip install --upgrade pip -q >/dev/null 2>&1
pip install -r requirements.txt -q >/dev/null 2>&1

echo -e "${GREEN}✅ Python environment ready${NC}"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔐 Step 7/10: Generating secure keys and .env file...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

FASTAPI_KEY=$(openssl rand -hex 32)
HOSTINGER_KEY=$(openssl rand -hex 32)
WEBUI_KEY=$(openssl rand -hex 32)
KHALID_TOKEN=$(openssl rand -hex 32)
AGENT_TOKEN=$(openssl rand -hex 32)

cat > .env << EOF
# ════════════════════════════════════════════════════════════
# DL+ System Configuration - Auto Generated
# Date: $(date)
# ════════════════════════════════════════════════════════════

# System Information
SYSTEM_NAME="DL+ Unified Arabic Intelligence System"
SYSTEM_VERSION="1.0.0"

# Hostinger Configuration
HOSTINGER_ENABLED=true
HOSTINGER_HOST=localhost
HOSTINGER_PORT=8000
HOSTINGER_API_KEY=${HOSTINGER_KEY}
HOSTINGER_SERVER_URL=http://localhost:8000

# FastAPI Configuration
FASTAPI_HOST=0.0.0.0
FASTAPI_PORT=8000
FASTAPI_SECRET_KEY=${FASTAPI_KEY}

# OpenWebUI Configuration
OPENWEBUI_ENABLED=true
OPENWEBUI_PORT=3000
OPENWEBUI_HOST=0.0.0.0
OPENWEBUI_VERSION=latest
WEBUI_SECRET_KEY=${WEBUI_KEY}
OLLAMA_API_BASE_URL=http://localhost:11434

# Security Tokens (Moved from code to .env for security)
KHALID_TOKEN=${KHALID_TOKEN}
AGENT_TOKEN=${AGENT_TOKEN}

# Security Settings
ENABLE_AUTHENTICATION=true
ENABLE_ENCRYPTION=true
ALLOWED_ORIGINS=https://${DOMAIN},https://onlainee.space
ALLOWED_COMMANDS=file_create,file_read,file_update,file_delete,service_restart,openwebui_manage,log_view,status_check,backup_create
ALLOWED_PATHS=/var/www,/home,/tmp

# Logging Configuration
LOG_LEVEL=INFO
LOG_FILE=/var/log/ai-agent-platform/app.log
ENABLE_FILE_LOGGING=true

# Performance Settings
ASYNC_MODE=true
MAX_WORKERS=4
REQUEST_TIMEOUT=60
EOF

echo -e "${GREEN}✅ Secure keys generated and .env file created${NC}"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🌐 Step 8/10: Configuring Nginx...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sudo bash -c "cat > /etc/nginx/sites-available/ai-agent-platform" << EOF
server {
    listen 80;
    server_name ${DOMAIN};

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/ai-agent-platform /etc/nginx/sites-enabled/
sudo nginx -t >/dev/null 2>&1
sudo systemctl restart nginx

echo -e "${GREEN}✅ Nginx configured${NC}"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔥 Step 9/10: Configuring firewall...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sudo ufw allow 22/tcp >/dev/null 2>&1
sudo ufw allow 80/tcp >/dev/null 2>&1
sudo ufw allow 443/tcp >/dev/null 2>&1
sudo ufw allow 8000/tcp >/dev/null 2>&1
sudo ufw --force enable >/dev/null 2>&1

echo -e "${GREEN}✅ Firewall configured${NC}"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}⚙️  Step 10/10: Creating systemd service...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sudo mkdir -p /var/log/ai-agent-platform
sudo chown -R $USER:$USER /var/log/ai-agent-platform

sudo bash -c "cat > /etc/systemd/system/ai-agent-platform.service" << EOF
[Unit]
Description=AI Agent Platform FastAPI Service
After=network.target

[Service]
Type=simple
User=$USER
Group=www-data
WorkingDirectory=$PROJECT_DIR
Environment="PATH=$PROJECT_DIR/venv/bin"
ExecStart=$PROJECT_DIR/venv/bin/uvicorn dlplus.main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ai-agent-platform
sudo systemctl start ai-agent-platform

sleep 3

echo -e "${GREEN}✅ Systemd service created and started${NC}"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║             🎉 INSTALLATION COMPLETE! 🎉                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔑 Security Keys (Save these securely!):${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "   ${PURPLE}FASTAPI_SECRET_KEY:${NC} $FASTAPI_KEY"
echo -e "   ${PURPLE}HOSTINGER_API_KEY:${NC}  $HOSTINGER_KEY"
echo -e "   ${PURPLE}WEBUI_SECRET_KEY:${NC}    $WEBUI_KEY"
echo -e "   ${PURPLE}KHALID_TOKEN:${NC}        $KHALID_TOKEN"
echo -e "   ${PURPLE}AGENT_TOKEN:${NC}         $AGENT_TOKEN"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Test service
if curl -s http://localhost:8000/api/health | grep -q "healthy"; then
    echo -e "${GREEN}✅ Service is running correctly!${NC}"
else
    echo -e "${YELLOW}⚠️  Service may need a moment to start. Check logs:${NC}"
    echo -e "   ${BLUE}sudo journalctl -u ai-agent-platform -f${NC}"
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "   1. ${BLUE}Setup SSL Certificate:${NC}"
echo -e "      ${GREEN}sudo certbot --nginx -d ${DOMAIN}${NC}"
echo ""
echo -e "   2. ${BLUE}Update PHP files with new tokens:${NC}"
echo -e "      ${GREEN}Edit onlainee.space/command-center.php${NC}"
echo -e "      ${GREEN}Edit onlainee.space/api/agent-webhook.php${NC}"
echo ""
echo -e "   3. ${BLUE}Check service status:${NC}"
echo -e "      ${GREEN}sudo systemctl status ai-agent-platform${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ Installation successful!${NC}"
echo -e "${PURPLE}👤 Author: Khalifa 'Dheban' Al-Anazi${NC}"
echo -e "${PURPLE}📍 Location: Al-Qassim, Buraydah, Saudi Arabia${NC}"
echo ""

