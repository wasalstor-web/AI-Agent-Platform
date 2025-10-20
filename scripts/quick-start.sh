#!/bin/bash

################################################################################
# Quick Start Script - سكريبت البدء السريع
# Supreme Agent - One Command Installation
#
# المؤلف / Author: wasalstor-web
# التاريخ / Date: 2025-10-20
################################################################################

set -e

# الألوان / Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███████╗██╗   ██╗██████╗ ██████╗ ███████╗███╗   ███╗  ║
║   ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔════╝████╗ ████║  ║
║   ███████╗██║   ██║██████╔╝██████╔╝█████╗  ██╔████╔██║  ║
║   ╚════██║██║   ██║██╔═══╝ ██╔══██╗██╔══╝  ██║╚██╔╝██║  ║
║   ███████║╚██████╔╝██║     ██║  ██║███████╗██║ ╚═╝ ██║  ║
║   ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ║
║                                                           ║
║              AGENT - الوكيل الأعلى المتكامل              ║
║                   Quick Start / بدء سريع                 ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

echo -e "${YELLOW}مرحباً! سيتم تثبيت Supreme Agent بالكامل.${NC}"
echo -e "${YELLOW}Welcome! Supreme Agent will be fully installed.${NC}\n"

# الانتقال إلى مجلد المشروع / Navigate to project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

echo -e "${GREEN}مجلد المشروع / Project directory: $PROJECT_DIR${NC}\n"

# الخطوة 1: تثبيت Supreme Agent
echo -e "${BLUE}[1/4] تثبيت Supreme Agent / Installing Supreme Agent...${NC}"
if [ -f "scripts/install-supreme-agent.sh" ]; then
    bash scripts/install-supreme-agent.sh
    echo -e "${GREEN}✓ تم التثبيت / Installed${NC}\n"
else
    echo -e "${YELLOW}⚠ سكريبت التثبيت غير موجود / Installation script not found${NC}\n"
fi

# الخطوة 2: تشغيل API Server
echo -e "${BLUE}[2/4] تشغيل API Server / Starting API Server...${NC}"
if [ -f "api/server.py" ]; then
    # تشغيل في الخلفية / Run in background
    nohup python3 api/server.py > /tmp/supreme-api.log 2>&1 &
    API_PID=$!
    echo $API_PID > /tmp/supreme-api.pid
    sleep 3
    
    if ps -p $API_PID > /dev/null; then
        echo -e "${GREEN}✓ API Server يعمل / API Server running (PID: $API_PID)${NC}"
        echo -e "${GREEN}  Log: /tmp/supreme-api.log${NC}\n"
    else
        echo -e "${YELLOW}⚠ فشل تشغيل API Server / Failed to start API Server${NC}\n"
    fi
else
    echo -e "${YELLOW}⚠ API Server غير موجود / API Server not found${NC}\n"
fi

# الخطوة 3: تشغيل Web Interface
echo -e "${BLUE}[3/4] تشغيل واجهة الويب / Starting Web Interface...${NC}"
if [ -d "web" ]; then
    cd web
    # تشغيل خادم HTTP بسيط / Start simple HTTP server
    nohup python3 -m http.server 8080 > /tmp/supreme-web.log 2>&1 &
    WEB_PID=$!
    echo $WEB_PID > /tmp/supreme-web.pid
    cd ..
    sleep 2
    
    if ps -p $WEB_PID > /dev/null; then
        echo -e "${GREEN}✓ واجهة الويب تعمل / Web Interface running (PID: $WEB_PID)${NC}"
        echo -e "${GREEN}  Log: /tmp/supreme-web.log${NC}\n"
    else
        echo -e "${YELLOW}⚠ فشل تشغيل واجهة الويب / Failed to start Web Interface${NC}\n"
    fi
else
    echo -e "${YELLOW}⚠ مجلد web غير موجود / web directory not found${NC}\n"
fi

# الخطوة 4: التكامل مع OpenWebUI (اختياري)
echo -e "${BLUE}[4/4] التكامل مع OpenWebUI (اختياري) / OpenWebUI Integration (optional)${NC}"
if [ -f "scripts/integrate-openwebui.sh" ]; then
    read -p "هل تريد التكامل مع OpenWebUI؟ / Integrate with OpenWebUI? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash scripts/integrate-openwebui.sh || true
    else
        echo -e "${YELLOW}تم تخطي التكامل / Integration skipped${NC}"
    fi
else
    echo -e "${YELLOW}⚠ سكريبت التكامل غير موجود / Integration script not found${NC}"
fi

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}           التثبيت مكتمل! / Installation Complete!         ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

cat << EOF
${YELLOW}روابط الوصول / Access URLs:${NC}

  ${BLUE}1. واجهة الويب / Web Interface:${NC}
     http://localhost:8080
     
  ${BLUE}2. API Server:${NC}
     http://localhost:5000
     http://localhost:5000/api/docs
     
  ${BLUE}3. OpenWebUI (إذا تم التثبيت):${NC}
     http://localhost:3000

${YELLOW}الأوامر المتاحة / Available Commands:${NC}

  ${BLUE}supreme-agent chat${NC} "رسالتك"
  ${BLUE}supreme-agent execute${NC} "أمرك"
  ${BLUE}supreme-agent analyze-file${NC} path/to/file
  ${BLUE}supreme-agent generate-code${NC} "وصف" --lang python
  ${BLUE}supreme-agent health${NC}
  ${BLUE}supreme-agent models${NC}

${YELLOW}إيقاف الخوادم / Stop Servers:${NC}

  ${BLUE}# إيقاف API Server${NC}
  kill \$(cat /tmp/supreme-api.pid 2>/dev/null) 2>/dev/null || true
  
  ${BLUE}# إيقاف واجهة الويب${NC}
  kill \$(cat /tmp/supreme-web.pid 2>/dev/null) 2>/dev/null || true

${YELLOW}السجلات / Logs:${NC}

  ${BLUE}# API Server logs${NC}
  tail -f /tmp/supreme-api.log
  
  ${BLUE}# Web Interface logs${NC}
  tail -f /tmp/supreme-web.log
  
  ${BLUE}# Agent logs${NC}
  tail -f supreme_agent.log

${YELLOW}مزيد من المعلومات / More Information:${NC}

  • README.md - دليل شامل / Complete guide
  • docs/API.md - توثيق API / API documentation
  • docs/MODELS.md - شرح النماذج / Models explanation

${GREEN}استمتع باستخدام Supreme Agent! 🚀${NC}
${GREEN}Enjoy using Supreme Agent! 🚀${NC}
EOF
