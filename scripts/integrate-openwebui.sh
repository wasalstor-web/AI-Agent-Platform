#!/bin/bash

################################################################################
# OpenWebUI Integration Script
# سكريبت التكامل مع OpenWebUI
#
# هذا السكريبت يقوم بربط Supreme Agent مع OpenWebUI
# This script integrates Supreme Agent with OpenWebUI
#
# المؤلف / Author: wasalstor-web
# التاريخ / Date: 2025-10-20
################################################################################

set -e

# الألوان / Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# دالة للطباعة / Print function
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_header "Supreme Agent & OpenWebUI Integration / التكامل مع OpenWebUI"

# التحقق من Ollama / Check Ollama
print_info "التحقق من Ollama / Checking Ollama..."
if ! command -v ollama &> /dev/null; then
    print_error "Ollama غير مثبت / Ollama not installed"
    print_info "قم بتشغيل ./scripts/install-supreme-agent.sh أولاً"
    print_info "Run ./scripts/install-supreme-agent.sh first"
    exit 1
fi
print_success "Ollama مثبت / Ollama installed"

# التحقق من OpenWebUI / Check OpenWebUI
print_info "التحقق من OpenWebUI / Checking OpenWebUI..."
if command -v docker &> /dev/null && docker ps | grep -q openwebui; then
    print_success "OpenWebUI يعمل / OpenWebUI is running"
else
    print_error "OpenWebUI غير مثبت أو لا يعمل / OpenWebUI not installed or not running"
    print_info "قم بتشغيل ./setup-openwebui.sh أولاً"
    print_info "Run ./setup-openwebui.sh first"
    exit 1
fi

# مزامنة النماذج / Sync models
print_info "مزامنة النماذج / Syncing models..."
ollama list

# التحقق من النموذج المخصص / Check custom model
if ollama list | grep -q "supreme-executor"; then
    print_success "النموذج المخصص متاح / Custom model available"
else
    print_info "إنشاء النموذج المخصص / Creating custom model..."
    cd "$(dirname "$0")/.."
    if [ -f "models/Modelfile" ]; then
        ollama create supreme-executor -f models/Modelfile
        print_success "تم إنشاء النموذج المخصص / Custom model created"
    else
        print_error "ملف Modelfile غير موجود / Modelfile not found"
        exit 1
    fi
fi

# إنشاء ملف تكوين مشترك / Create shared configuration
print_info "إنشاء ملف التكوين / Creating configuration file..."

cat > /tmp/supreme-openwebui-config.json << 'EOF'
{
  "integration": {
    "type": "full",
    "ollama_host": "http://localhost:11434",
    "openwebui_port": 3000,
    "supreme_api_port": 5000,
    "models": {
      "supreme-executor": "النموذج الأعلى المتكامل / Supreme Integrated Model",
      "llama3": "نموذج أساسي / Base Model",
      "aya": "نموذج عربي / Arabic Model",
      "mistral": "نموذج سريع / Fast Model",
      "deepseek-coder": "نموذج برمجة / Coding Model",
      "qwen2": "نموذج متقدم / Advanced Model"
    },
    "features": {
      "chat": true,
      "execute": true,
      "analyze": true,
      "generate_code": true
    }
  }
}
EOF

print_success "تم إنشاء ملف التكوين / Configuration file created"

# اختبار التكامل / Test integration
print_info "اختبار التكامل / Testing integration..."

# اختبار Ollama API / Test Ollama API
if curl -s http://localhost:11434/api/tags > /dev/null; then
    print_success "Ollama API يعمل / Ollama API working"
else
    print_error "Ollama API لا يستجيب / Ollama API not responding"
fi

# اختبار OpenWebUI / Test OpenWebUI
if curl -s http://localhost:3000 > /dev/null; then
    print_success "OpenWebUI يعمل / OpenWebUI working"
else
    print_error "OpenWebUI لا يستجيب / OpenWebUI not responding"
fi

# عرض معلومات الوصول / Show access information
print_header "معلومات الوصول / Access Information"

cat << EOF
${GREEN}التكامل مكتمل! / Integration Complete!${NC}

${YELLOW}روابط الوصول / Access URLs:${NC}

  ${BLUE}OpenWebUI:${NC}
    http://localhost:3000
    
  ${BLUE}Supreme Agent API:${NC}
    http://localhost:5000
    http://localhost:5000/api/docs
    
  ${BLUE}Supreme Agent Web UI:${NC}
    file://$(pwd)/web/index.html
    أو / or: python3 -m http.server 8080 (في مجلد web)

${YELLOW}النماذج المتاحة / Available Models:${NC}
  • supreme-executor - الوكيل الأعلى / Supreme Agent
  • llama3 - نموذج أساسي / Base model
  • aya - نموذج عربي / Arabic model
  • mistral - نموذج سريع / Fast model
  • deepseek-coder - نموذج برمجة / Coding model
  • qwen2 - نموذج متقدم / Advanced model

${YELLOW}الاستخدام / Usage:${NC}

  1. ${BLUE}في OpenWebUI:${NC}
     - افتح http://localhost:3000
     - اختر النموذج supreme-executor
     - ابدأ المحادثة

  2. ${BLUE}في واجهة Supreme Agent:${NC}
     - افتح web/index.html
     - استخدم جميع الميزات المتقدمة

  3. ${BLUE}عبر API:${NC}
     curl -X POST http://localhost:5000/api/chat \\
       -H "Content-Type: application/json" \\
       -d '{"message": "مرحباً"}'

${YELLOW}إعدادات إضافية / Additional Settings:${NC}
  - ملف التكوين: /tmp/supreme-openwebui-config.json
  - السجلات: ./supreme_agent.log
  - السجل: يتم حفظه في المتصفح localStorage

${GREEN}استمتع باستخدام Supreme Agent! / Enjoy using Supreme Agent!${NC}
EOF
