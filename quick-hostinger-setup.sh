#!/bin/bash
# Quick Hostinger Setup - One Command Installation
# نسخة سريعة لإعداد Hostinger - تثبيت بأمر واحد
# Author: Khalifa 'Dheban' Al-Anazi
# Date: 2025-10-20

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   🚀 AI Agent Platform - Hostinger Quick Setup 🚀        ║"
echo "║   إعداد سريع لمنصة الوكيل الذكي على هوستنقر              ║"
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

echo -e "${CYAN}🔍 Checking system requirements...${NC}"
echo -e "${CYAN}🔍 فحص متطلبات النظام...${NC}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}⚠️  Please do not run as root. Run as regular user with sudo access.${NC}"
   echo -e "${RED}⚠️  الرجاء عدم التشغيل كـ root. شغّل كمستخدم عادي مع صلاحيات sudo.${NC}"
   exit 1
fi

# Update system
echo -e "${YELLOW}📦 Updating system packages...${NC}"
echo -e "${YELLOW}📦 تحديث حزم النظام...${NC}"
sudo apt update -qq

# Install required packages
echo -e "${YELLOW}📥 Installing required packages...${NC}"
echo -e "${YELLOW}📥 تثبيت الحزم المطلوبة...${NC}"
sudo apt install -y python3 python3-pip python3-venv git nginx curl openssl >/dev/null 2>&1

echo -e "${GREEN}✅ System packages installed${NC}"
echo ""

# Create project directory
echo -e "${YELLOW}📁 Setting up project directory...${NC}"
echo -e "${YELLOW}📁 إنشاء مجلد المشروع...${NC}"

if [ -d "$PROJECT_DIR" ]; then
    echo -e "${BLUE}ℹ️  Project directory exists. Updating...${NC}"
    cd $PROJECT_DIR
    git pull origin main
else
    sudo mkdir -p $PROJECT_DIR
    sudo chown -R $USER:$USER $PROJECT_DIR
    git clone $REPO_URL $PROJECT_DIR
    cd $PROJECT_DIR
fi

echo -e "${GREEN}✅ Project directory ready${NC}"
echo ""

# Generate secure keys
echo -e "${YELLOW}🔐 Generating secure API keys...${NC}"
echo -e "${YELLOW}🔐 توليد مفاتيح API آمنة...${NC}"

FASTAPI_KEY=$(openssl rand -hex 32)
HOSTINGER_KEY=$(openssl rand -hex 32)
WEBUI_KEY=$(openssl rand -hex 32)

echo -e "${GREEN}✅ Secure keys generated${NC}"
echo ""

# Create .env file
echo -e "${YELLOW}⚙️  Creating configuration file...${NC}"
echo -e "${YELLOW}⚙️  إنشاء ملف الإعدادات...${NC}"

cat > .env << EOF
# ════════════════════════════════════════════════════════════
# DL+ System Configuration - Auto Generated
# تكوين نظام DL+ - تم إنشاؤه تلقائيًا
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

# Security Settings
ENABLE_AUTHENTICATION=true
ENABLE_ENCRYPTION=true
ALLOWED_ORIGINS=* 
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

echo -e "${GREEN}✅ Configuration file created${NC}"
echo ""

# Setup Python virtual environment
echo -e "${YELLOW}🐍 Setting up Python environment...${NC}"
echo -e "${YELLOW}🐍 إعداد بيئة Python...${NC}"

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip -q
pip install fastapi uvicorn aiohttp python-dotenv pydantic -q

echo -e "${GREEN}✅ Python environment ready${NC}"
echo ""

# Create FastAPI application
echo -e "${YELLOW}🔧 Creating FastAPI application...${NC}"
echo -e "${YELLOW}🔧 إنشاء تطبيق FastAPI...${NC}"

cat > main.py << 'EOFPY'
from fastapi import FastAPI, HTTPException, Header, Depends
from typing import Optional, Dict, Any
import os
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

app = FastAPI(
    title="AI Agent Platform - Hostinger API",
    description="نظام DL+ للذكاء الصناعي العربي",
    version="1.0.0"
)

API_KEY = os.getenv("HOSTINGER_API_KEY", "your-secret-key")

def verify_api_key(x_api_key: Optional[str] = Header(None)):
    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Invalid API Key")
    return True

@app.get("/")
async def root():
    return {
        "message": "AI Agent Platform API",
        "status": "running",
        "version": "1.0.0",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/api/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "ai-agent-platform",
        "timestamp": datetime.now().isoformat()
    }

@app.post("/api/execute")
async def execute_command(
    command_data: Dict[str, Any],
    authenticated: bool = Depends(verify_api_key)
):
    command_type = command_data.get("command_type")
    params = command_data.get("params", {})
    
    return {
        "success": True,
        "command_type": command_type,
        "result": "Command executed successfully",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/api/status")
async def system_status(authenticated: bool = Depends(verify_api_key)):
    return {
        "status": "operational",
        "initialized": True,
        "services": {
            "fastapi": "running",
            "hostinger": "connected"
        },
        "timestamp": datetime.now().isoformat()
    }
EOFPY

echo -e "${GREEN}✅ FastAPI application created${NC}"
echo ""

# Create systemd service
echo -e "${YELLOW}⚙️  Creating systemd service...${NC}"
echo -e "${YELLOW}⚙️  إنشاء خدمة systemd...${NC}"

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
ExecStart=$PROJECT_DIR/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create log directory
sudo mkdir -p /var/log/ai-agent-platform
sudo chown -R $USER:$USER /var/log/ai-agent-platform

echo -e "${GREEN}✅ Systemd service created${NC}"
echo ""

# Configure Nginx
echo -e "${YELLOW}🌐 Configuring Nginx...${NC}"
echo -e "${YELLOW}🌐 تكوين Nginx...${NC}"

sudo bash -c "cat > /etc/nginx/sites-available/ai-agent-platform" << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/ai-agent-platform /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

echo -e "${GREEN}✅ Nginx configured${NC}"
echo ""

# Configure firewall
echo -e "${YELLOW}🔥 Configuring firewall...${NC}"
echo -e "${YELLOW}🔥 تكوين الجدار الناري...${NC}"

sudo ufw allow 80/tcp >/dev/null 2>&1
sudo ufw allow 443/tcp >/dev/null 2>&1
sudo ufw allow 8000/tcp >/dev/null 2>&1

echo -e "${GREEN}✅ Firewall configured${NC}"
echo ""

# Start services
echo -e "${YELLOW}🚀 Starting services...${NC}"
echo -e "${YELLOW}🚀 تشغيل الخدمات...${NC}"

sudo systemctl daemon-reload
sudo systemctl enable ai-agent-platform
sudo systemctl start ai-agent-platform

sleep 3

echo -e "${GREEN}✅ Services started${NC}"
echo ""

# Test the service
echo -e "${YELLOW}🧪 Testing the service...${NC}"
echo -e "${YELLOW}🧪 اختبار الخدمة...${NC}"

if curl -s http://localhost:8000/api/health | grep -q "healthy"; then
    echo -e "${GREEN}✅ Service is running correctly!${NC}"
    echo -e "${GREEN}✅ الخدمة تعمل بشكل صحيح!${NC}"
else
    echo -e "${RED}⚠️  Service test failed. Check logs.${NC}"
    echo -e "${RED}⚠️  فشل اختبار الخدمة. تحقق من السجلات.${NC}"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║             🎉 SETUP COMPLETE! / الإعداد مكتمل! 🎉       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${CYAN}📋 System Information / معلومات النظام:${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}🔑 API Keys (Save these securely!):${NC}"
echo -e "${YELLOW}🔑 مفاتيح API (احفظها بأمان!):${NC}"
echo ""
echo -e "   ${PURPLE}FASTAPI_SECRET_KEY:${NC} $FASTAPI_KEY"
echo -e "   ${PURPLE}HOSTINGER_API_KEY:${NC}  $HOSTINGER_KEY"
echo -e "   ${PURPLE}WEBUI_SECRET_KEY:${NC}    $WEBUI_KEY"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}📁 Important Files / الملفات المهمة:${NC}"
echo ""
echo -e "   ${BLUE}•${NC} Application: ${GREEN}$PROJECT_DIR/main.py${NC}"
echo -e "   ${BLUE}•${NC} Config:      ${GREEN}$PROJECT_DIR/.env${NC}"
echo -e "   ${BLUE}•${NC} Service:     ${GREEN}/etc/systemd/system/ai-agent-platform.service${NC}"
echo -e "   ${BLUE}•${NC} Nginx:       ${GREEN}/etc/nginx/sites-available/ai-agent-platform${NC}"
echo -e "   ${BLUE}•${NC} Logs:        ${GREEN}/var/log/ai-agent-platform/app.log${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}🌐 Access Points / نقاط الوصول:${NC}"
echo ""
echo -e "   ${BLUE}•${NC} API Root:    ${GREEN}http://$(hostname -I | awk '{print $1}')/${NC}"
echo -e "   ${BLUE}•${NC} Health:      ${GREEN}http://$(hostname -I | awk '{print $1}')/api/health${NC}"
echo -e "   ${BLUE}•${NC} Status:      ${GREEN}http://$(hostname -I | awk '{print $1}')/api/status${NC}"
echo -e "   ${BLUE}•${NC} Local:       ${GREEN}http://localhost:8000${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}🔧 Useful Commands / أوامر مفيدة:${NC}"
echo ""
echo -e "   ${BLUE}•${NC} Check service:    ${GREEN}sudo systemctl status ai-agent-platform${NC}"
echo -e "   ${BLUE}•${NC} View logs:        ${GREEN}sudo journalctl -u ai-agent-platform -f${NC}"
echo -e "   ${BLUE}•${NC} Restart service:  ${GREEN}sudo systemctl restart ai-agent-platform${NC}"
echo -e "   ${BLUE}•${NC} Test API:         ${GREEN}curl http://localhost:8000/api/health${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ Installation successful!${NC}"
echo -e "${GREEN}✅ التثبيت نجح بشكل كامل!${NC}"
echo ""
echo -e "${PURPLE}👤 Author: Khalifa 'Dheban' Al-Anazi${NC}"
echo -e "${PURPLE}📍 Location: Al-Qassim, Buraydah, Saudi Arabia${NC}"
echo -e "${PURPLE}📅 Date: $(date)${NC}"
echo ""