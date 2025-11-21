#!/bin/bash

#############################################################################
# Docker Compose Quick Start Script
# سكريبت البدء السريع لـ Docker Compose
#
# This script helps you quickly start the AI Agent Platform using Docker
# يساعدك هذا السكريبت على بدء منصة وكيل الذكاء الاصطناعي بسرعة باستخدام Docker
#############################################################################

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${BLUE}ℹ $1${NC}"
}

#############################################################################
# Check Docker and Docker Compose
#############################################################################

check_docker() {
    print_header "فحص Docker / Checking Docker"
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker غير مثبت / Docker is not installed"
        print_info "يرجى تثبيت Docker من: https://docs.docker.com/get-docker/"
        print_info "Please install Docker from: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    print_success "Docker مثبت / Docker is installed"
    docker --version
    
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        print_error "Docker غير قيد التشغيل / Docker is not running"
        print_info "يرجى بدء خدمة Docker / Please start Docker service"
        exit 1
    fi
    
    print_success "Docker قيد التشغيل / Docker is running"
}

check_docker_compose() {
    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose غير مثبت / Docker Compose is not installed"
        print_info "يرجى تثبيت Docker Compose / Please install Docker Compose"
        exit 1
    fi
    
    print_success "Docker Compose مثبت / Docker Compose is installed"
    docker compose version
}

#############################################################################
# Environment Setup
#############################################################################

setup_environment() {
    print_header "إعداد البيئة / Setting Up Environment"
    
    if [ ! -f .env ]; then
        if [ -f .env.docker ]; then
            print_info "نسخ .env.docker إلى .env / Copying .env.docker to .env"
            cp .env.docker .env
            print_success "تم إنشاء ملف .env / Created .env file"
        elif [ -f .env.example ]; then
            print_info "نسخ .env.example إلى .env / Copying .env.example to .env"
            cp .env.example .env
            print_success "تم إنشاء ملف .env / Created .env file"
        else
            print_warning "لم يتم العثور على ملف البيئة / Environment file not found"
            print_info "سيتم استخدام القيم الافتراضية / Default values will be used"
        fi
    else
        print_success "ملف .env موجود / .env file exists"
    fi
    
    # Generate secrets if needed
    if grep -q "change-me-to-a-secure" .env 2>/dev/null; then
        print_warning "تحذير: يرجى تغيير المفاتيح السرية في ملف .env"
        print_warning "Warning: Please change secret keys in .env file"
        print_info "يمكنك توليد مفتاح باستخدام: openssl rand -hex 32"
        print_info "You can generate a key using: openssl rand -hex 32"
    fi
}

#############################################################################
# Docker Compose Operations
#############################################################################

start_services() {
    print_header "بدء الخدمات / Starting Services"
    
    MODE=${1:-basic}
    
    case $MODE in
        basic)
            print_info "بدء الخدمات الأساسية (DL+ فقط) / Starting basic services (DL+ only)"
            docker compose up -d dlplus
            ;;
        full)
            print_info "بدء جميع الخدمات (DL+ + OpenWebUI) / Starting all services (DL+ + OpenWebUI)"
            docker compose --profile full up -d
            ;;
        openwebui)
            print_info "بدء مع OpenWebUI / Starting with OpenWebUI"
            docker compose --profile openwebui up -d
            ;;
        *)
            print_error "وضع غير صحيح / Invalid mode"
            exit 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        print_success "تم بدء الخدمات بنجاح / Services started successfully"
    else
        print_error "فشل بدء الخدمات / Failed to start services"
        exit 1
    fi
}

show_status() {
    print_header "حالة الخدمات / Services Status"
    docker compose ps
}

show_logs() {
    print_header "سجلات الخدمات / Services Logs"
    docker compose logs --tail=50 -f
}

stop_services() {
    print_header "إيقاف الخدمات / Stopping Services"
    docker compose down
    print_success "تم إيقاف الخدمات / Services stopped"
}

rebuild_services() {
    print_header "إعادة بناء الخدمات / Rebuilding Services"
    docker compose build --no-cache
    print_success "تم إعادة البناء / Rebuild complete"
}

#############################################################################
# Display Information
#############################################################################

show_info() {
    print_header "معلومات الوصول / Access Information"
    
    echo ""
    print_info "📍 نقاط نهاية API / API Endpoints:"
    echo ""
    echo -e "  ${GREEN}DL+ System:${NC}"
    echo -e "    - API: http://localhost:8000"
    echo -e "    - Health: http://localhost:8000/api/health"
    echo -e "    - Status: http://localhost:8000/api/status"
    echo -e "    - Docs: http://localhost:8000/docs"
    echo ""
    
    if docker compose ps | grep -q openwebui; then
        echo -e "  ${GREEN}OpenWebUI:${NC}"
        echo -e "    - Interface: http://localhost:3000"
        echo ""
    fi
    
    print_info "📊 للتحقق من الحالة / To check status:"
    echo "  docker compose ps"
    echo ""
    
    print_info "📋 لعرض السجلات / To view logs:"
    echo "  docker compose logs -f"
    echo ""
    
    print_info "🛑 لإيقاف الخدمات / To stop services:"
    echo "  docker compose down"
    echo ""
}

#############################################################################
# Main Menu
#############################################################################

show_menu() {
    print_header "قائمة Docker Compose / Docker Compose Menu"
    
    echo "1. بدء الخدمات الأساسية (DL+ فقط) / Start basic services (DL+ only)"
    echo "2. بدء جميع الخدمات (مع OpenWebUI) / Start all services (with OpenWebUI)"
    echo "3. عرض حالة الخدمات / Show services status"
    echo "4. عرض السجلات / Show logs"
    echo "5. إيقاف الخدمات / Stop services"
    echo "6. إعادة بناء الخدمات / Rebuild services"
    echo "7. عرض معلومات الوصول / Show access information"
    echo "8. خروج / Exit"
    echo ""
    
    read -p "اختر خياراً / Choose an option (1-8): " choice
    
    case $choice in
        1)
            start_services basic
            show_info
            ;;
        2)
            start_services full
            show_info
            ;;
        3)
            show_status
            ;;
        4)
            show_logs
            ;;
        5)
            stop_services
            ;;
        6)
            rebuild_services
            ;;
        7)
            show_info
            ;;
        8)
            print_info "وداعاً! / Goodbye!"
            exit 0
            ;;
        *)
            print_error "خيار غير صحيح / Invalid option"
            ;;
    esac
}

#############################################################################
# Main Script
#############################################################################

main() {
    print_header "🚀 AI Agent Platform - Docker Compose"
    print_header "منصة وكيل الذكاء الاصطناعي - Docker Compose"
    
    # Check prerequisites
    check_docker
    check_docker_compose
    
    # Setup environment
    setup_environment
    
    # Check for command line arguments
    if [ $# -eq 0 ]; then
        # Interactive mode
        while true; do
            show_menu
            echo ""
            read -p "اضغط Enter للمتابعة / Press Enter to continue..."
            echo ""
        done
    else
        # Command line mode
        case $1 in
            start)
                start_services ${2:-basic}
                show_info
                ;;
            stop)
                stop_services
                ;;
            status)
                show_status
                ;;
            logs)
                show_logs
                ;;
            rebuild)
                rebuild_services
                ;;
            info)
                show_info
                ;;
            *)
                print_error "أمر غير معروف / Unknown command: $1"
                echo ""
                echo "الاستخدام / Usage:"
                echo "  $0                    # وضع تفاعلي / Interactive mode"
                echo "  $0 start [basic|full] # بدء الخدمات / Start services"
                echo "  $0 stop               # إيقاف الخدمات / Stop services"
                echo "  $0 status             # عرض الحالة / Show status"
                echo "  $0 logs               # عرض السجلات / Show logs"
                echo "  $0 rebuild            # إعادة البناء / Rebuild"
                echo "  $0 info               # عرض المعلومات / Show info"
                exit 1
                ;;
        esac
    fi
}

# Run main function
main "$@"
