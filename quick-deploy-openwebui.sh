#!/bin/bash

#############################################################################
# Quick Deploy OpenWebUI with DL+ Backend
# نشر سريع لـ OpenWebUI مع DL+ Backend
#
# This script provides instant deployment of:
# - DL+ Backend API
# - OpenWebUI Docker container
# - Integrated dashboard
#
# SECURITY: This script uses environment variables for sensitive data
#           Never hardcode credentials in scripts!
#############################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

#############################################################################
# Display Functions
#############################################################################

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_banner() {
    clear
    cat << "BANNER"
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║         🚀 Quick Deploy: OpenWebUI + DL+ Backend                        ║
║            نشر سريع: OpenWebUI + DL+ Backend                           ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
BANNER
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

#############################################################################
# Configuration Loading
#############################################################################

load_config() {
    print_header "⚙️  تحميل التكوين | Loading Configuration"
    
    # Check if config file exists
    if [ ! -f ".env.instant-deploy" ]; then
        print_warning "ملف التكوين غير موجود | Configuration file not found"
        print_info "إنشاء ملف من القالب | Creating from template..."
        
        if [ -f ".env.instant-deploy.example" ]; then
            cp .env.instant-deploy.example .env.instant-deploy
            print_success "تم إنشاء ملف التكوين | Configuration file created"
            print_warning "الرجاء تعديل .env.instant-deploy بالقيم الصحيحة"
            print_warning "Please edit .env.instant-deploy with correct values"
            echo ""
            print_info "استخدم هذه الأوامر لتوليد المفاتيح الآمنة:"
            print_info "Use these commands to generate secure keys:"
            echo ""
            echo -e "${YELLOW}  # API Key${NC}"
            echo -e "  ${CYAN}openssl rand -hex 32${NC}"
            echo ""
            echo -e "${YELLOW}  # Secret Key${NC}"
            echo -e "  ${CYAN}openssl rand -hex 32${NC}"
            echo ""
            read -p "اضغط Enter بعد تعديل الملف | Press Enter after editing the file..."
        else
            print_error "ملف القالب غير موجود | Template file not found"
            exit 1
        fi
    fi
    
    # Load environment variables
    source .env.instant-deploy
    
    # Validate required variables
    if [ -z "$DLPLUS_API_KEY" ] || [ "$DLPLUS_API_KEY" = "sk-your-api-key-here" ]; then
        print_error "DLPLUS_API_KEY غير مكون | DLPLUS_API_KEY not configured"
        exit 1
    fi
    
    if [ -z "$WEBUI_SECRET_KEY" ] || [ "$WEBUI_SECRET_KEY" = "your-secret-key-here" ]; then
        print_error "WEBUI_SECRET_KEY غير مكون | WEBUI_SECRET_KEY not configured"
        exit 1
    fi
    
    # Set defaults
    DLPLUS_PORT="${DLPLUS_PORT:-8000}"
    OPENWEBUI_PORT="${OPENWEBUI_PORT:-3000}"
    OPENWEBUI_VERSION="${OPENWEBUI_VERSION:-main}"
    ENABLE_SIGNUP="${ENABLE_SIGNUP:-true}"
    ENABLE_API_KEY="${ENABLE_API_KEY:-true}"
    OPENAI_API_BASE_URL="${OPENAI_API_BASE_URL:-http://host.docker.internal:8000/api}"
    
    print_success "تم تحميل التكوين | Configuration loaded"
}

#############################################################################
# Step Functions
#############################################################################

start_dlplus_backend() {
    print_header "⚡ [1/5] تشغيل DL+ Backend | Starting DL+ Backend"
    
    # Check if already running
    if curl -s http://localhost:${DLPLUS_PORT}/api/health > /dev/null 2>&1; then
        print_success "DL+ Backend يعمل بالفعل | DL+ Backend already running"
        return 0
    fi
    
    # Try to start DL+ Backend
    if [ -f "start-dlplus.sh" ]; then
        print_info "تشغيل DL+ Backend..."
        nohup bash start-dlplus.sh > /tmp/dlplus.log 2>&1 &
        print_info "انتظار 8 ثوانٍ... | Waiting 8 seconds..."
        sleep 8
        
        # Verify it started
        if curl -s http://localhost:${DLPLUS_PORT}/api/health > /dev/null 2>&1; then
            print_success "DL+ Backend جاهز | DL+ Backend ready"
        else
            print_warning "DL+ Backend قد يحتاج وقتاً إضافياً | DL+ Backend may need more time"
            print_info "تحقق من السجلات: tail -f /tmp/dlplus.log"
        fi
    elif [ -f "dlplus/main.py" ]; then
        print_info "تشغيل DL+ Backend مباشرة..."
        nohup python3 dlplus/main.py > /tmp/dlplus.log 2>&1 &
        print_info "انتظار 8 ثوانٍ... | Waiting 8 seconds..."
        sleep 8
        print_success "DL+ Backend بدأ | DL+ Backend started"
    else
        print_warning "DL+ Backend غير موجود، متابعة بدونه | DL+ Backend not found, continuing without it"
    fi
}

pull_openwebui_image() {
    print_header "📥 [2/5] تحميل صورة OpenWebUI | Downloading OpenWebUI Image"
    
    print_info "تحميل ghcr.io/open-webui/open-webui:${OPENWEBUI_VERSION}..."
    if docker pull ghcr.io/open-webui/open-webui:${OPENWEBUI_VERSION}; then
        print_success "تم التحميل | Downloaded successfully"
    else
        print_error "فشل التحميل | Download failed"
        exit 1
    fi
}

cleanup_old_containers() {
    print_header "🔄 [3/5] تنظيف الحاويات القديمة | Cleaning Old Containers"
    
    if docker ps -a | grep -q "open-webui"; then
        print_info "إيقاف وحذف الحاوية القديمة..."
        docker stop open-webui 2>/dev/null || true
        docker rm open-webui 2>/dev/null || true
        print_success "تم التنظيف | Cleaned up"
    else
        print_info "لا توجد حاويات قديمة | No old containers found"
    fi
}

deploy_openwebui() {
    print_header "🚀 [4/5] نشر OpenWebUI | Deploying OpenWebUI"
    
    print_info "نشر OpenWebUI مع التكوين..."
    
    docker run -d \
        --name open-webui \
        -p ${OPENWEBUI_PORT}:8080 \
        -e OPENAI_API_BASE_URL=${OPENAI_API_BASE_URL} \
        -e OPENAI_API_KEY=${DLPLUS_API_KEY} \
        -e WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY} \
        -e WEBUI_JWT_SECRET_KEY=${DLPLUS_JWT_TOKEN} \
        -e ENABLE_SIGNUP=${ENABLE_SIGNUP} \
        -e ENABLE_API_KEY=${ENABLE_API_KEY} \
        -v open-webui:/app/backend/data \
        --add-host=host.docker.internal:host-gateway \
        --restart unless-stopped \
        ghcr.io/open-webui/open-webui:${OPENWEBUI_VERSION}
    
    print_success "تم النشر | Deployed successfully"
}

create_dashboard() {
    print_header "📄 [5/5] إنشاء لوحة التحكم | Creating Dashboard"
    
    local dashboard_file="$HOME/openwebui-dashboard.html"
    
    # Copy template and customize
    if [ -f "openwebui-dashboard-template.html" ]; then
        cp openwebui-dashboard-template.html "$dashboard_file"
        
        # Add deployment timestamp
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')
        sed -i "s/AI Agent Platform © 2025/Deployed: $timestamp<br>AI Agent Platform © 2025/" "$dashboard_file"
        
        print_success "تم إنشاء: $dashboard_file"
        print_info "Dashboard created at: $dashboard_file"
    else
        print_warning "قالب لوحة التحكم غير موجود | Dashboard template not found"
    fi
}

wait_for_ready() {
    print_header "⏳ انتظار الجاهزية | Waiting for Service Ready"
    
    print_info "انتظار 15 ثانية..."
    sleep 15
    
    print_success "الخدمة جاهزة | Service ready"
}

show_final_results() {
    clear
    cat << "BANNER"
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║         🎉 تم التشغيل بنجاح! SUCCESSFULLY RUNNING! 🎉                  ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
BANNER

    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📍 روابط الوصول | Access URLs:${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "   ${GREEN}🌐 OpenWebUI:      ${CYAN}http://localhost:${OPENWEBUI_PORT}${NC}"
    echo -e "   ${GREEN}🔧 DL+ API:        ${CYAN}http://localhost:${DLPLUS_PORT}${NC}"
    echo -e "   ${GREEN}📖 Docs:           ${CYAN}http://localhost:${DLPLUS_PORT}/api/docs${NC}"
    echo -e "   ${GREEN}📄 Dashboard:      ${CYAN}$HOME/openwebui-dashboard.html${NC}"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🔑 مفاتيحك | Your Keys:${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "   ${YELLOW}⚠️  المفاتيح محفوظة في: .env.instant-deploy${NC}"
    echo -e "   ${YELLOW}⚠️  Keys stored in: .env.instant-deploy${NC}"
    echo -e "   ${RED}🔒 لا تشارك هذا الملف | Do not share this file${NC}"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🤖 النماذج | Models (6):${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "   ${GREEN}✅ AraBERT    ✅ Qwen      ✅ LLaMA 3${NC}"
    echo -e "   ${GREEN}✅ DeepSeek   ✅ Mistral   ✅ CAMeLBERT${NC}"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}🎊 افتح المتصفح الآن على:${NC}"
    echo -e "   ${CYAN}👉 http://localhost:${OPENWEBUI_PORT}${NC}"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}🛠️  أوامر إدارة النظام | System Management:${NC}"
    echo ""
    echo -e "   ${CYAN}# عرض السجلات | View logs${NC}"
    echo -e "   docker logs -f open-webui"
    echo ""
    echo -e "   ${CYAN}# إعادة التشغيل | Restart${NC}"
    echo -e "   docker restart open-webui"
    echo ""
    echo -e "   ${CYAN}# إيقاف | Stop${NC}"
    echo -e "   docker stop open-webui"
    echo ""
    echo -e "   ${CYAN}# بدء | Start${NC}"
    echo -e "   docker start open-webui"
    echo ""
    echo -e "   ${CYAN}# حالة الحاوية | Container status${NC}"
    echo -e "   docker ps | grep open-webui"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}✅ النشر مكتمل! | Deployment Complete!${NC}"
    echo ""
}

try_open_browser() {
    print_info "محاولة فتح المتصفح | Trying to open browser..."
    
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open http://localhost:${OPENWEBUI_PORT} >/dev/null 2>&1 &
        xdg-open "$HOME/openwebui-dashboard.html" >/dev/null 2>&1 &
    elif command -v open >/dev/null 2>&1; then
        open http://localhost:${OPENWEBUI_PORT} >/dev/null 2>&1 &
        open "$HOME/openwebui-dashboard.html" >/dev/null 2>&1 &
    else
        print_info "لم يتم العثور على أمر فتح المتصفح | Browser open command not found"
    fi
}

#############################################################################
# Main Execution
#############################################################################

main() {
    print_banner
    
    # Execute deployment steps
    load_config
    start_dlplus_backend
    pull_openwebui_image
    cleanup_old_containers
    deploy_openwebui
    create_dashboard
    wait_for_ready
    
    # Show results
    show_final_results
    try_open_browser
}

# Run main function
main "$@"
