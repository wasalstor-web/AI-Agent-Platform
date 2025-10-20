#!/bin/bash

#############################################################################
# OpenWebUI Setup Script
# Script for installing and configuring OpenWebUI on VPS
# Features: Docker installation, OpenWebUI setup, Nginx proxy configuration
#############################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration variables (can be set via environment variables)
OPENWEBUI_PORT="${OPENWEBUI_PORT:-3000}"
OPENWEBUI_HOST="${OPENWEBUI_HOST:-0.0.0.0}"
OPENWEBUI_VERSION="${OPENWEBUI_VERSION:-latest}"
OLLAMA_API_BASE_URL="${OLLAMA_API_BASE_URL:-http://localhost:11434}"
WEBUI_SECRET_KEY="${WEBUI_SECRET_KEY:-$(openssl rand -hex 32 2>/dev/null || echo 'change-me-to-a-secure-key')}"

#############################################################################
# Display Functions
#############################################################################

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
# Check Functions
#############################################################################

check_root() {
    if [ "$EUID" -ne 0 ] && [ -z "$SKIP_ROOT_CHECK" ]; then 
        print_warning "يُفضل تشغيل هذا السكريبت كمستخدم root / It's recommended to run this script as root"
        print_info "أو استخدم: sudo $0 / Or use: sudo $0"
        read -p "هل تريد المتابعة؟ (y/n) / Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

check_docker() {
    print_header "فحص Docker / Checking Docker"
    
    if command -v docker &> /dev/null; then
        print_success "Docker مثبت / Docker is installed"
        docker --version
        return 0
    else
        print_warning "Docker غير مثبت / Docker is not installed"
        return 1
    fi
}

check_docker_compose() {
    print_header "فحص Docker Compose / Checking Docker Compose"
    
    if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
        print_success "Docker Compose مثبت / Docker Compose is installed"
        if command -v docker-compose &> /dev/null; then
            docker-compose --version
        else
            docker compose version
        fi
        return 0
    else
        print_warning "Docker Compose غير مثبت / Docker Compose is not installed"
        return 1
    fi
}

#############################################################################
# Installation Functions
#############################################################################

install_docker() {
    print_header "تثبيت Docker / Installing Docker"
    
    print_info "جاري تحديث قائمة الحزم / Updating package list..."
    apt-get update -qq
    
    print_info "جاري تثبيت المتطلبات / Installing prerequisites..."
    apt-get install -y -qq apt-transport-https ca-certificates curl software-properties-common gnupg
    
    print_info "جاري إضافة مفتاح Docker GPG / Adding Docker GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    print_info "جاري إضافة مستودع Docker / Adding Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    print_info "جاري تثبيت Docker / Installing Docker..."
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io
    
    print_info "جاري تشغيل Docker / Starting Docker..."
    systemctl start docker
    systemctl enable docker
    
    if command -v docker &> /dev/null; then
        print_success "تم تثبيت Docker بنجاح / Docker installed successfully"
        return 0
    else
        print_error "فشل تثبيت Docker / Docker installation failed"
        return 1
    fi
}

install_docker_compose() {
    print_header "تثبيت Docker Compose / Installing Docker Compose"
    
    # Try to use docker compose plugin first
    if docker compose version &> /dev/null; then
        print_success "Docker Compose plugin متوفر / Docker Compose plugin available"
        return 0
    fi
    
    print_info "جاري تثبيت Docker Compose / Installing Docker Compose..."
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
    
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    if command -v docker-compose &> /dev/null; then
        print_success "تم تثبيت Docker Compose بنجاح / Docker Compose installed successfully"
        return 0
    else
        print_error "فشل تثبيت Docker Compose / Docker Compose installation failed"
        return 1
    fi
}

#############################################################################
# OpenWebUI Installation Functions
#############################################################################

install_openwebui() {
    print_header "تثبيت OpenWebUI / Installing OpenWebUI"
    
    print_info "جاري إنشاء مجلد OpenWebUI / Creating OpenWebUI directory..."
    mkdir -p /opt/openwebui
    cd /opt/openwebui
    
    print_info "جاري إنشاء ملف docker-compose.yml / Creating docker-compose.yml..."
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  openwebui:
    image: ghcr.io/open-webui/open-webui:${OPENWEBUI_VERSION}
    container_name: openwebui
    restart: unless-stopped
    ports:
      - "${OPENWEBUI_PORT}:8080"
    volumes:
      - openwebui_data:/app/backend/data
    environment:
      - OLLAMA_API_BASE_URL=${OLLAMA_API_BASE_URL}
      - WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
      - WEBUI_AUTH=true
    networks:
      - openwebui_network

volumes:
  openwebui_data:

networks:
  openwebui_network:
    driver: bridge
EOF

    print_success "تم إنشاء ملف التكوين / Configuration file created"
    
    print_info "جاري سحب صورة OpenWebUI / Pulling OpenWebUI image..."
    if docker compose pull || docker-compose pull; then
        print_success "تم سحب الصورة بنجاح / Image pulled successfully"
    else
        print_error "فشل سحب الصورة / Failed to pull image"
        return 1
    fi
    
    print_info "جاري تشغيل OpenWebUI / Starting OpenWebUI..."
    if docker compose up -d || docker-compose up -d; then
        print_success "تم تشغيل OpenWebUI بنجاح / OpenWebUI started successfully"
        return 0
    else
        print_error "فشل تشغيل OpenWebUI / Failed to start OpenWebUI"
        return 1
    fi
}

install_ollama() {
    print_header "تثبيت Ollama (اختياري) / Installing Ollama (Optional)"
    
    print_info "هل تريد تثبيت Ollama على هذا الخادم؟ / Do you want to install Ollama on this server?"
    read -p "(y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "تخطي تثبيت Ollama / Skipping Ollama installation"
        return 0
    fi
    
    print_info "جاري تثبيت Ollama / Installing Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
    
    if command -v ollama &> /dev/null; then
        print_success "تم تثبيت Ollama بنجاح / Ollama installed successfully"
        
        print_info "جاري تشغيل خدمة Ollama / Starting Ollama service..."
        systemctl start ollama
        systemctl enable ollama
        
        print_success "تم تشغيل Ollama / Ollama is running"
        print_info "يمكنك تحميل نماذج مثل: ollama pull llama2"
        print_info "You can download models like: ollama pull llama2"
        return 0
    else
        print_warning "فشل تثبيت Ollama / Failed to install Ollama"
        return 1
    fi
}

#############################################################################
# Configuration Functions
#############################################################################

configure_nginx() {
    print_header "تكوين Nginx (اختياري) / Configuring Nginx (Optional)"
    
    if ! command -v nginx &> /dev/null; then
        print_warning "Nginx غير مثبت / Nginx is not installed"
        read -p "هل تريد تثبيت Nginx؟ (y/n) / Install Nginx? (y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "جاري تثبيت Nginx / Installing Nginx..."
            apt-get update -qq
            apt-get install -y -qq nginx
        else
            return 0
        fi
    fi
    
    read -p "أدخل اسم النطاق (مثال: ai.example.com) / Enter domain name (example: ai.example.com): " domain
    
    if [ -z "$domain" ]; then
        print_warning "لم يتم إدخال نطاق، تخطي تكوين Nginx / No domain entered, skipping Nginx configuration"
        return 0
    fi
    
    print_info "جاري إنشاء تكوين Nginx / Creating Nginx configuration..."
    cat > /etc/nginx/sites-available/openwebui << EOF
server {
    listen 80;
    server_name ${domain};

    location / {
        proxy_pass http://localhost:${OPENWEBUI_PORT};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

    ln -sf /etc/nginx/sites-available/openwebui /etc/nginx/sites-enabled/
    
    print_info "جاري اختبار تكوين Nginx / Testing Nginx configuration..."
    if nginx -t; then
        print_success "تكوين Nginx صحيح / Nginx configuration is valid"
        systemctl reload nginx
        print_success "تم إعادة تحميل Nginx / Nginx reloaded"
        
        print_info "يمكنك الآن إعداد SSL باستخدام: / You can now setup SSL using:"
        print_info "sudo certbot --nginx -d ${domain}"
    else
        print_error "خطأ في تكوين Nginx / Nginx configuration error"
        return 1
    fi
}

#############################################################################
# Management Functions
#############################################################################

show_status() {
    print_header "حالة OpenWebUI / OpenWebUI Status"
    
    cd /opt/openwebui 2>/dev/null || {
        print_error "OpenWebUI غير مثبت / OpenWebUI is not installed"
        return 1
    }
    
    if docker compose ps || docker-compose ps; then
        echo ""
        print_info "الوصول إلى OpenWebUI / Access OpenWebUI at:"
        echo -e "${GREEN}http://localhost:${OPENWEBUI_PORT}${NC}"
        echo -e "${GREEN}http://$(hostname -I | awk '{print $1}'):${OPENWEBUI_PORT}${NC}"
    else
        print_error "فشل عرض الحالة / Failed to show status"
        return 1
    fi
}

show_logs() {
    print_header "سجلات OpenWebUI / OpenWebUI Logs"
    
    cd /opt/openwebui 2>/dev/null || {
        print_error "OpenWebUI غير مثبت / OpenWebUI is not installed"
        return 1
    }
    
    docker compose logs -f --tail=100 || docker-compose logs -f --tail=100
}

restart_service() {
    print_header "إعادة تشغيل OpenWebUI / Restarting OpenWebUI"
    
    cd /opt/openwebui 2>/dev/null || {
        print_error "OpenWebUI غير مثبت / OpenWebUI is not installed"
        return 1
    }
    
    if docker compose restart || docker-compose restart; then
        print_success "تم إعادة تشغيل OpenWebUI / OpenWebUI restarted successfully"
        return 0
    else
        print_error "فشل إعادة التشغيل / Restart failed"
        return 1
    fi
}

stop_service() {
    print_header "إيقاف OpenWebUI / Stopping OpenWebUI"
    
    cd /opt/openwebui 2>/dev/null || {
        print_error "OpenWebUI غير مثبت / OpenWebUI is not installed"
        return 1
    }
    
    if docker compose down || docker-compose down; then
        print_success "تم إيقاف OpenWebUI / OpenWebUI stopped successfully"
        return 0
    else
        print_error "فشل الإيقاف / Stop failed"
        return 1
    fi
}

#############################################################################
# Main Menu
#############################################################################

show_menu() {
    clear
    print_header "إدارة OpenWebUI / OpenWebUI Management"
    echo "1) تثبيت OpenWebUI / Install OpenWebUI"
    echo "2) عرض الحالة / Show Status"
    echo "3) عرض السجلات / Show Logs"
    echo "4) إعادة التشغيل / Restart"
    echo "5) إيقاف الخدمة / Stop Service"
    echo "6) تكوين Nginx / Configure Nginx"
    echo "7) تثبيت Ollama / Install Ollama"
    echo "8) الخروج / Exit"
    echo ""
}

#############################################################################
# Main Execution
#############################################################################

main() {
    check_root
    
    # If arguments provided, run in automated mode
    if [ $# -gt 0 ]; then
        case $1 in
            install)
                check_docker || install_docker
                check_docker_compose || install_docker_compose
                install_openwebui
                ;;
            status)
                show_status
                ;;
            logs)
                show_logs
                ;;
            restart)
                restart_service
                ;;
            stop)
                stop_service
                ;;
            *)
                echo "Usage: $0 {install|status|logs|restart|stop}"
                exit 1
                ;;
        esac
        exit 0
    fi
    
    # Interactive menu
    while true; do
        show_menu
        read -p "اختر خيارًا / Choose an option: " choice
        
        case $choice in
            1)
                check_docker || install_docker
                check_docker_compose || install_docker_compose
                install_openwebui
                read -p "اضغط Enter للمتابعة / Press Enter to continue..."
                ;;
            2)
                show_status
                read -p "اضغط Enter للمتابعة / Press Enter to continue..."
                ;;
            3)
                show_logs
                ;;
            4)
                restart_service
                read -p "اضغط Enter للمتابعة / Press Enter to continue..."
                ;;
            5)
                stop_service
                read -p "اضغط Enter للمتابعة / Press Enter to continue..."
                ;;
            6)
                configure_nginx
                read -p "اضغط Enter للمتابعة / Press Enter to continue..."
                ;;
            7)
                install_ollama
                read -p "اضغط Enter للمتابعة / Press Enter to continue..."
                ;;
            8)
                print_success "إنهاء... / Exiting..."
                exit 0
                ;;
            *)
                print_error "خيار غير صالح / Invalid option"
                read -p "اضغط Enter للمتابعة / Press Enter to continue..."
                ;;
        esac
    done
}

# Run main function
main "$@"
