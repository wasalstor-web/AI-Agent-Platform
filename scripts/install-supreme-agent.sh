#!/bin/bash

################################################################################
# Supreme Agent Installation Script
# سكريبت تثبيت الوكيل الأعلى
#
# هذا السكريبت يقوم بتثبيت وإعداد Supreme Agent بالكامل
# This script installs and configures Supreme Agent completely
#
# المؤلف / Author: wasalstor-web
# التاريخ / Date: 2025-10-20
################################################################################

set -e  # Exit on error

# الألوان / Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# الرموز / Symbols
SUCCESS="✓"
ERROR="✗"
INFO="ℹ"
ARROW="➜"

# دالة للطباعة الملونة / Colored print function
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}${SUCCESS} $1${NC}"
}

print_error() {
    echo -e "${RED}${ERROR} $1${NC}"
}

print_info() {
    echo -e "${YELLOW}${INFO} $1${NC}"
}

print_step() {
    echo -e "${BLUE}${ARROW} $1${NC}"
}

# التحقق من الصلاحيات / Check permissions
check_sudo() {
    if [ "$EUID" -ne 0 ]; then 
        print_info "بعض العمليات قد تحتاج صلاحيات sudo / Some operations may need sudo"
        print_info "سيتم طلب كلمة المرور عند الحاجة / Password will be requested when needed"
    fi
}

# تثبيت Ollama / Install Ollama
install_ollama() {
    print_step "تثبيت Ollama / Installing Ollama..."
    
    if command -v ollama &> /dev/null; then
        print_success "Ollama مثبت مسبقاً / Ollama already installed"
        ollama --version
    else
        print_info "تحميل وتثبيت Ollama / Downloading and installing Ollama..."
        curl -fsSL https://ollama.ai/install.sh | sh
        
        if command -v ollama &> /dev/null; then
            print_success "تم تثبيت Ollama بنجاح / Ollama installed successfully"
        else
            print_error "فشل تثبيت Ollama / Ollama installation failed"
            exit 1
        fi
    fi
    
    # تشغيل Ollama / Start Ollama
    print_step "تشغيل خدمة Ollama / Starting Ollama service..."
    if systemctl is-active --quiet ollama 2>/dev/null; then
        print_success "Ollama قيد التشغيل / Ollama is running"
    else
        # محاولة تشغيل Ollama في الخلفية / Try to start Ollama in background
        nohup ollama serve > /tmp/ollama.log 2>&1 &
        sleep 3
        print_success "تم تشغيل Ollama / Ollama started"
    fi
}

# تحميل النماذج / Download models
download_models() {
    print_step "تحميل النماذج الأساسية / Downloading base models..."
    
    local models=("llama3" "aya" "mistral" "deepseek-coder" "qwen2")
    
    for model in "${models[@]}"; do
        print_info "تحميل $model / Downloading $model..."
        if ollama pull "$model" 2>/dev/null; then
            print_success "تم تحميل $model / Downloaded $model"
        else
            print_error "فشل تحميل $model / Failed to download $model"
        fi
    done
}

# إنشاء النموذج المخصص / Create custom model
create_supreme_model() {
    print_step "إنشاء النموذج المخصص Supreme Executor / Creating Supreme Executor model..."
    
    local modelfile_path="$(dirname "$0")/../models/Modelfile"
    
    if [ -f "$modelfile_path" ]; then
        if ollama create supreme-executor -f "$modelfile_path"; then
            print_success "تم إنشاء supreme-executor بنجاح / Created supreme-executor successfully"
        else
            print_error "فشل إنشاء النموذج المخصص / Failed to create custom model"
        fi
    else
        print_error "ملف Modelfile غير موجود / Modelfile not found"
        print_info "المسار المتوقع / Expected path: $modelfile_path"
    fi
}

# تثبيت Python dependencies
install_python_deps() {
    print_step "تثبيت مكتبات Python / Installing Python dependencies..."
    
    # التحقق من Python / Check Python
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 غير مثبت / Python 3 not installed"
        print_info "تثبيت Python 3 / Installing Python 3..."
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip
    fi
    
    print_success "Python 3 متوفر / Python 3 available"
    python3 --version
    
    # تثبيت المكتبات / Install libraries
    print_info "تثبيت المكتبات المطلوبة / Installing required libraries..."
    pip3 install --user requests flask flask-cors
    
    print_success "تم تثبيت مكتبات Python / Python libraries installed"
}

# إنشاء أمر supreme-agent / Create supreme-agent command
create_command() {
    print_step "إنشاء الأمر supreme-agent / Creating supreme-agent command..."
    
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local agent_script="$script_dir/supreme_agent.py"
    
    # إنشاء symlink في /usr/local/bin
    # Create symlink in /usr/local/bin
    if [ -f "$agent_script" ]; then
        sudo ln -sf "$agent_script" /usr/local/bin/supreme-agent
        sudo chmod +x /usr/local/bin/supreme-agent
        print_success "تم إنشاء الأمر supreme-agent / Created supreme-agent command"
        print_info "يمكنك الآن استخدام: supreme-agent / You can now use: supreme-agent"
    else
        print_error "ملف supreme_agent.py غير موجود / supreme_agent.py not found"
    fi
}

# اختبار النظام / Test system
test_system() {
    print_step "اختبار النظام / Testing system..."
    
    # اختبار Ollama / Test Ollama
    print_info "اختبار Ollama API / Testing Ollama API..."
    if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        print_success "Ollama API يعمل / Ollama API working"
    else
        print_error "Ollama API لا يستجيب / Ollama API not responding"
    fi
    
    # قائمة النماذج / List models
    print_info "النماذج المتاحة / Available models:"
    ollama list || true
    
    # اختبار supreme-agent / Test supreme-agent
    if command -v supreme-agent &> /dev/null; then
        print_success "أمر supreme-agent جاهز / supreme-agent command ready"
        print_info "تجربة: supreme-agent models / Try: supreme-agent models"
    else
        print_error "أمر supreme-agent غير متاح / supreme-agent command not available"
    fi
}

# عرض المعلومات النهائية / Show final information
show_final_info() {
    print_header "التثبيت مكتمل / Installation Complete"
    
    cat << EOF
${GREEN}تم تثبيت Supreme Agent بنجاح! / Supreme Agent installed successfully!${NC}

${YELLOW}الأوامر المتاحة / Available commands:${NC}

  ${BLUE}supreme-agent chat${NC} "رسالتك / your message"
    محادثة مع الوكيل / Chat with the agent

  ${BLUE}supreme-agent execute${NC} "أمرك / your command"
    تنفيذ أمر معين / Execute a specific command

  ${BLUE}supreme-agent analyze-file${NC} path/to/file
    تحليل ملف / Analyze a file

  ${BLUE}supreme-agent generate-code${NC} "وصف الكود / code description" --lang python
    توليد كود برمجي / Generate code

  ${BLUE}supreme-agent health${NC}
    فحص صحة النظام / Check system health

  ${BLUE}supreme-agent models${NC}
    عرض النماذج المتاحة / Show available models

${YELLOW}الخطوات التالية / Next steps:${NC}

  1. ${BLUE}تشغيل API Server:${NC}
     cd api && python3 server.py

  2. ${BLUE}فتح الواجهة:${NC}
     افتح web/index.html في المتصفح
     Open web/index.html in browser

  3. ${BLUE}التكامل مع OpenWebUI:${NC}
     ./scripts/integrate-openwebui.sh

${YELLOW}المزيد من المعلومات / More information:${NC}
  - README.md
  - docs/API.md
  - docs/MODELS.md

${GREEN}استمتع باستخدام Supreme Agent! / Enjoy using Supreme Agent!${NC}
EOF
}

# البرنامج الرئيسي / Main program
main() {
    print_header "Supreme Agent Installation / تثبيت الوكيل الأعلى"
    
    check_sudo
    
    print_info "بدء عملية التثبيت / Starting installation process..."
    echo
    
    # الخطوات / Steps
    install_ollama
    echo
    
    download_models
    echo
    
    create_supreme_model
    echo
    
    install_python_deps
    echo
    
    create_command
    echo
    
    test_system
    echo
    
    show_final_info
}

# تشغيل البرنامج / Run program
main
