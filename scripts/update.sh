#!/bin/bash

################################################################################
# Update Script - سكريبت التحديث
# Supreme Agent - System Update Utility
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

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║      Supreme Agent - System Update / التحديث      ║
╚═══════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# دالة للطباعة / Print function
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_step() {
    echo -e "${BLUE}➜ $1${NC}"
}

# الانتقال إلى مجلد المشروع / Navigate to project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

print_info "مجلد المشروع / Project directory: $PROJECT_DIR"
echo

# 1. تحديث المشروع من Git / Update project from Git
print_step "[1/5] تحديث المشروع من Git / Updating project from Git..."
if [ -d ".git" ]; then
    git fetch origin
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    print_info "الفرع الحالي / Current branch: $CURRENT_BRANCH"
    
    read -p "هل تريد سحب التحديثات؟ / Pull updates? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git pull origin "$CURRENT_BRANCH"
        print_success "تم تحديث المشروع / Project updated"
    else
        print_info "تم تخطي التحديث / Update skipped"
    fi
else
    print_info "ليس مشروع git / Not a git repository"
fi
echo

# 2. تحديث نماذج Ollama / Update Ollama models
print_step "[2/5] تحديث نماذج Ollama / Updating Ollama models..."
if command -v ollama &> /dev/null; then
    # قائمة النماذج المثبتة / List installed models
    print_info "النماذج المثبتة / Installed models:"
    ollama list
    
    read -p "هل تريد تحديث النماذج؟ / Update models? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Get list of installed models, skipping header
        models=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')
        
        if [ -z "$models" ]; then
            print_info "لا توجد نماذج مثبتة / No models installed"
        else
            # Update each model with error handling
            while IFS= read -r model; do
                if [ -n "$model" ]; then
                    print_info "تحديث / Updating: $model"
                    if ! ollama pull "$model" 2>&1; then
                        print_error "فشل تحديث / Failed to update: $model"
                    fi
                fi
            done <<< "$models"
            print_success "تم تحديث النماذج / Models updated"
        fi
    else
        print_info "تم تخطي تحديث النماذج / Model update skipped"
    fi
else
    print_error "Ollama غير مثبت / Ollama not installed"
fi
echo

# 3. تحديث مكتبات Python / Update Python dependencies
print_step "[3/5] تحديث مكتبات Python / Updating Python dependencies..."
if command -v pip3 &> /dev/null; then
    print_info "تحديث pip / Updating pip..."
    pip3 install --upgrade pip
    
    print_info "تحديث المكتبات / Updating libraries..."
    pip3 install --upgrade requests flask flask-cors
    
    print_success "تم تحديث المكتبات / Libraries updated"
else
    print_error "pip3 غير مثبت / pip3 not installed"
fi
echo

# 4. إعادة إنشاء النموذج المخصص / Recreate custom model
print_step "[4/5] إعادة إنشاء النموذج المخصص / Recreating custom model..."
if [ -f "models/Modelfile" ]; then
    read -p "هل تريد إعادة إنشاء supreme-executor؟ / Recreate supreme-executor? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # حذف النموذج القديم / Remove old model
        ollama rm supreme-executor 2>/dev/null || true
        
        # إنشاء النموذج الجديد / Create new model
        ollama create supreme-executor -f models/Modelfile
        print_success "تم إعادة إنشاء النموذج / Model recreated"
    else
        print_info "تم تخطي إعادة الإنشاء / Recreation skipped"
    fi
else
    print_error "ملف Modelfile غير موجود / Modelfile not found"
fi
echo

# 5. إعادة تشغيل الخدمات / Restart services
print_step "[5/5] إعادة تشغيل الخدمات / Restarting services..."

# إيقاف الخدمات الحالية / Stop current services
print_info "إيقاف الخدمات / Stopping services..."
if [ -f "/tmp/supreme-api.pid" ]; then
    kill $(cat /tmp/supreme-api.pid 2>/dev/null) 2>/dev/null || true
    rm -f /tmp/supreme-api.pid
fi

if [ -f "/tmp/supreme-web.pid" ]; then
    kill $(cat /tmp/supreme-web.pid 2>/dev/null) 2>/dev/null || true
    rm -f /tmp/supreme-web.pid
fi

read -p "هل تريد إعادة تشغيل الخدمات؟ / Restart services? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # تشغيل API Server / Start API Server
    print_info "تشغيل API Server..."
    nohup python3 api/server.py > /tmp/supreme-api.log 2>&1 &
    echo $! > /tmp/supreme-api.pid
    
    # تشغيل Web Interface / Start Web Interface
    print_info "تشغيل Web Interface..."
    cd web
    nohup python3 -m http.server 8080 > /tmp/supreme-web.log 2>&1 &
    echo $! > /tmp/supreme-web.pid
    cd ..
    
    sleep 3
    print_success "تم إعادة تشغيل الخدمات / Services restarted"
else
    print_info "تم تخطي إعادة التشغيل / Restart skipped"
fi

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}        التحديث مكتمل! / Update Complete!         ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

cat << EOF
${YELLOW}معلومات الخدمات / Service Information:${NC}

  ${BLUE}API Server:${NC}
    http://localhost:5000
    Log: /tmp/supreme-api.log
    PID: $(cat /tmp/supreme-api.pid 2>/dev/null || echo "Not running")
    
  ${BLUE}Web Interface:${NC}
    http://localhost:8080
    Log: /tmp/supreme-web.log
    PID: $(cat /tmp/supreme-web.pid 2>/dev/null || echo "Not running")

${YELLOW}اختبار النظام / Test System:${NC}

  ${BLUE}supreme-agent health${NC}
  ${BLUE}supreme-agent models${NC}
  ${BLUE}curl http://localhost:5000/api/health${NC}

${GREEN}جميع التحديثات مكتملة! 🚀${NC}
${GREEN}All updates complete! 🚀${NC}
EOF
