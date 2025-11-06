#!/bin/bash

#############################################################################
# DEPLOY-NOW.sh - السكريبت الرئيسي للنشر التلقائي
# Main Automatic Deployment Script for AI Agent Platform
#
# Description: Universal deployment script with support for:
#              - Automatic environment detection
#              - Multiple deployment targets (Local, VPS, GitHub Pages)
#              - Interactive and non-interactive modes
#              - Complete validation and health checks
#
# Usage: bash DEPLOY-NOW.sh [options]
#        Options:
#          --auto    : Automatic mode (no prompts)
#          --local   : Deploy locally only
#          --vps     : Deploy to VPS
#          --github  : Deploy to GitHub Pages
#          --help    : Show help message
#############################################################################

set -e  # Exit on error

# Version
VERSION="1.0.0"

# Color codes for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Deployment configuration
DEPLOYMENT_MODE="auto"
TARGET=""
PROJECT_NAME="AI Agent Platform"
PROJECT_DIR=$(pwd)

#############################################################################
# Display Functions
#############################################################################

print_banner() {
    clear
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}                                                               ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${CYAN}🚀 AI Agent Platform - Deployment System 🚀${NC}              ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${CYAN}منصة وكيل الذكاء الاصطناعي - نظام النشر${NC}                ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                                                               ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}  ${WHITE}Version: ${VERSION}${NC}                                          ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}                                                               ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
    echo -e "${BLUE}ℹ${NC} $1"
}

print_step() {
    echo -e "${PURPLE}▶${NC} $1"
}

#############################################################################
# Helper Functions
#############################################################################

show_help() {
    cat << EOF
${GREEN}DEPLOY-NOW.sh${NC} - Universal Deployment Script

${CYAN}Usage:${NC}
  bash DEPLOY-NOW.sh [options]

${CYAN}Options:${NC}
  --auto      Automatic deployment (no prompts)
  --local     Deploy locally only
  --vps       Deploy to VPS server
  --github    Deploy to GitHub Pages
  --help      Show this help message

${CYAN}Examples:${NC}
  bash DEPLOY-NOW.sh              # Interactive mode
  bash DEPLOY-NOW.sh --auto       # Automatic deployment
  bash DEPLOY-NOW.sh --local      # Local deployment only
  bash DEPLOY-NOW.sh --vps        # VPS deployment

${CYAN}Environment Variables:${NC}
  VPS_HOST    VPS server hostname or IP
  VPS_USER    VPS username (default: root)
  VPS_PORT    SSH port (default: 22)

${CYAN}Documentation:${NC}
  README.md           Complete project guide
  START-HERE.md       Quick start guide
  DEPLOYMENT.md       Detailed deployment guide
  GITHUB-DOWNLOAD.txt Download instructions

${GREEN}Made with ❤️ for the Community${NC}
EOF
    exit 0
}

check_command() {
    if command -v "$1" &> /dev/null; then
        print_success "$1 is installed"
        return 0
    else
        print_warning "$1 is not installed"
        return 1
    fi
}

#############################################################################
# System Checks
#############################################################################

check_system_requirements() {
    print_section "🔍 فحص متطلبات النظام | Checking System Requirements"
    
    local all_ok=true
    
    # Essential tools
    print_step "Checking essential tools..."
    
    if check_command "bash"; then
        BASH_VERSION_NUM=$(bash --version | head -n1 | grep -oP '\d+\.\d+' | head -1)
        print_info "Bash version: $BASH_VERSION_NUM"
    else
        all_ok=false
    fi
    
    if check_command "git"; then
        GIT_VERSION=$(git --version | grep -oP '\d+\.\d+\.\d+')
        print_info "Git version: $GIT_VERSION"
    else
        print_warning "Git is recommended for version control"
    fi
    
    if check_command "python3"; then
        PYTHON_VERSION=$(python3 --version | grep -oP '\d+\.\d+\.\d+')
        print_info "Python version: $PYTHON_VERSION"
    else
        print_error "Python 3 is required!"
        all_ok=false
    fi
    
    if check_command "pip3" || check_command "pip"; then
        PIP_VERSION=$(pip3 --version 2>/dev/null || pip --version | grep -oP '\d+\.\d+\.\d+' | head -1)
        print_info "Pip version: $PIP_VERSION"
    else
        print_error "Pip is required!"
        all_ok=false
    fi
    
    # Optional but recommended tools
    print_step "Checking optional tools..."
    check_command "curl" || true
    check_command "wget" || true
    check_command "docker" || true
    check_command "docker-compose" || true
    
    # Check disk space
    print_step "Checking disk space..."
    AVAILABLE_SPACE=$(df -h . | awk 'NR==2 {print $4}')
    print_info "Available disk space: $AVAILABLE_SPACE"
    
    # Check memory
    if command -v free &> /dev/null; then
        TOTAL_MEM=$(free -h | awk 'NR==2 {print $2}')
        AVAILABLE_MEM=$(free -h | awk 'NR==2 {print $7}')
        print_info "Total memory: $TOTAL_MEM, Available: $AVAILABLE_MEM"
    fi
    
    echo ""
    if [ "$all_ok" = true ]; then
        print_success "All essential requirements are met!"
        return 0
    else
        print_error "Some requirements are missing. Please install them first."
        echo ""
        print_info "Quick install commands:"
        echo "  Ubuntu/Debian: sudo apt-get update && sudo apt-get install -y python3 python3-pip git"
        echo "  CentOS/RHEL:   sudo yum install -y python3 python3-pip git"
        echo "  macOS:         brew install python3 git"
        echo ""
        return 1
    fi
}

#############################################################################
# Environment Setup
#############################################################################

setup_environment() {
    print_section "⚙️ إعداد البيئة | Setting Up Environment"
    
    print_step "Checking for .env file..."
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            print_warning ".env file not found, creating from .env.example"
            cp .env.example .env
            print_success ".env file created"
            print_warning "Please edit .env file and add your API keys!"
            echo ""
            print_info "Required API keys:"
            echo "  - OPENROUTER_API_KEY: Get from https://openrouter.ai/"
            echo "  - Add any other required keys"
            echo ""
            read -p "Press Enter after you've configured .env file..."
        else
            print_warning ".env.example not found, creating basic .env"
            cat > .env << 'EOF'
# AI Agent Platform Environment Configuration
# Configure these values before deployment

# OpenRouter API Configuration
OPENROUTER_API_KEY=your_api_key_here

# Server Configuration
PORT=5000
HOST=0.0.0.0

# Environment
ENVIRONMENT=production

# Debug Mode (set to false in production)
DEBUG=false
EOF
            print_success "Basic .env file created"
            print_warning "Please edit .env and add your API keys!"
            read -p "Press Enter after configuration..."
        fi
    else
        print_success ".env file exists"
    fi
    
    # Install Python dependencies
    print_step "Installing Python dependencies..."
    if [ -f "requirements.txt" ]; then
        pip3 install -q -r requirements.txt 2>&1 | grep -v "already satisfied" || {
            print_warning "Some packages may already be installed"
        }
        print_success "Python dependencies installed"
    else
        print_warning "requirements.txt not found, installing basic packages"
        pip3 install -q flask flask-cors requests
        print_success "Basic packages installed"
    fi
    
    # Create necessary directories
    print_step "Creating necessary directories..."
    mkdir -p logs backups temp
    print_success "Directories created"
    
    echo ""
    print_success "Environment setup complete!"
}

#############################################################################
# Deployment Functions
#############################################################################

deploy_local() {
    print_section "💻 نشر محلي | Local Deployment"
    
    print_step "Starting local deployment..."
    
    # Check if Flask app exists
    if [ -f "api/app.py" ] || [ -f "app.py" ]; then
        print_info "Flask application found"
        
        # Find the app file
        if [ -f "api/app.py" ]; then
            APP_FILE="api/app.py"
        else
            APP_FILE="app.py"
        fi
        
        print_step "Starting Flask server..."
        echo ""
        print_success "Server will start at http://localhost:5000"
        print_info "Available endpoints:"
        echo "  - GET  /api/health   - Health check"
        echo "  - GET  /api/status   - Status information"
        echo "  - POST /api/process  - Process requests"
        echo ""
        print_warning "Press Ctrl+C to stop the server"
        echo ""
        
        # Start the server
        export FLASK_APP="$APP_FILE"
        export FLASK_ENV=production
        python3 -m flask run --host=0.0.0.0 --port=5000
    else
        print_warning "Flask application not found, starting simple HTTP server"
        
        if [ -f "index.html" ]; then
            print_info "Starting Python HTTP server..."
            echo ""
            print_success "Server will start at http://localhost:8000"
            print_warning "Press Ctrl+C to stop the server"
            echo ""
            python3 -m http.server 8000
        else
            print_error "No application files found!"
            return 1
        fi
    fi
}

deploy_vps() {
    print_section "🌐 نشر على VPS | VPS Deployment"
    
    # Check if VPS configuration exists
    if [ -z "$VPS_HOST" ]; then
        print_warning "VPS_HOST not configured"
        read -p "Enter VPS hostname or IP: " VPS_HOST
        export VPS_HOST
    fi
    
    if [ -z "$VPS_USER" ]; then
        VPS_USER="root"
    fi
    
    if [ -z "$VPS_PORT" ]; then
        VPS_PORT="22"
    fi
    
    print_info "VPS Configuration:"
    echo "  Host: $VPS_HOST"
    echo "  User: $VPS_USER"
    echo "  Port: $VPS_PORT"
    echo ""
    
    # Test SSH connection
    print_step "Testing SSH connection..."
    if ssh -o ConnectTimeout=5 -p "$VPS_PORT" "$VPS_USER@$VPS_HOST" "echo 'Connection successful'" 2>/dev/null; then
        print_success "SSH connection successful"
    else
        print_error "Cannot connect to VPS via SSH"
        print_info "Please check:"
        echo "  1. VPS is running and accessible"
        echo "  2. SSH keys are configured"
        echo "  3. Firewall allows SSH connections"
        return 1
    fi
    
    # Check if deploy script exists
    if [ -f "deploy.sh" ]; then
        print_step "Running comprehensive deployment script..."
        chmod +x deploy.sh
        ./deploy.sh
    else
        print_step "Copying files to VPS..."
        rsync -avz -e "ssh -p $VPS_PORT" \
            --exclude='.git' \
            --exclude='node_modules' \
            --exclude='__pycache__' \
            --exclude='*.pyc' \
            --exclude='.env' \
            ./ "$VPS_USER@$VPS_HOST:/var/www/ai-agent-platform/"
        
        print_success "Files copied successfully"
        
        print_step "Setting up environment on VPS..."
        ssh -p "$VPS_PORT" "$VPS_USER@$VPS_HOST" << 'ENDSSH'
cd /var/www/ai-agent-platform
pip3 install -r requirements.txt
sudo systemctl restart ai-agent-platform || echo "Service not configured"
ENDSSH
        
        print_success "VPS deployment complete!"
    fi
}

deploy_github_pages() {
    print_section "📄 نشر على GitHub Pages | GitHub Pages Deployment"
    
    if [ ! -d ".git" ]; then
        print_error "Not a git repository!"
        print_info "Initialize git first: git init"
        return 1
    fi
    
    print_step "Checking GitHub Pages status..."
    
    # Check if index.html exists
    if [ ! -f "index.html" ]; then
        print_error "index.html not found!"
        print_info "GitHub Pages requires an index.html file"
        return 1
    fi
    
    print_success "index.html found"
    
    print_step "Committing changes..."
    git add .
    git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')" || print_warning "No changes to commit"
    
    print_step "Pushing to GitHub..."
    git push origin main || git push origin master
    
    print_success "GitHub Pages deployment complete!"
    print_info "Your site will be available at:"
    echo "  https://$(git remote get-url origin | sed 's/.*github.com[:\/]//' | sed 's/.git$//' | sed 's/\//github.io\//')"
}

#############################################################################
# Main Deployment Menu
#############################################################################

show_deployment_menu() {
    print_section "📋 قائمة النشر | Deployment Menu"
    
    echo -e "${CYAN}اختر خيار النشر | Choose deployment option:${NC}"
    echo ""
    echo "  1) ${GREEN}نشر محلي${NC}               | Local Deployment"
    echo "     تشغيل على جهازك المحلي      Start on your local machine"
    echo ""
    echo "  2) ${BLUE}نشر على VPS${NC}             | VPS Deployment"
    echo "     نشر على خادم VPS            Deploy to VPS server"
    echo ""
    echo "  3) ${PURPLE}نشر على GitHub Pages${NC}   | GitHub Pages"
    echo "     نشر موقع ثابت               Deploy static website"
    echo ""
    echo "  4) ${YELLOW}نشر كامل${NC}                | Full Deployment"
    echo "     نشر على جميع المنصات        Deploy to all platforms"
    echo ""
    echo "  5) ${WHITE}اختبار النظام${NC}           | System Test"
    echo "     اختبار البيئة فقط           Test environment only"
    echo ""
    echo "  6) ${RED}خروج${NC}                    | Exit"
    echo ""
    
    read -p "$(echo -e ${CYAN}Enter your choice [1-6]:${NC} )" choice
    
    case $choice in
        1)
            deploy_local
            ;;
        2)
            deploy_vps
            ;;
        3)
            deploy_github_pages
            ;;
        4)
            print_info "Starting full deployment..."
            deploy_local &
            LOCAL_PID=$!
            sleep 2
            deploy_vps
            deploy_github_pages
            print_success "Full deployment complete!"
            ;;
        5)
            check_system_requirements
            setup_environment
            print_success "System test complete!"
            ;;
        6)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice!"
            show_deployment_menu
            ;;
    esac
}

#############################################################################
# Main Program
#############################################################################

main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                ;;
            --auto)
                DEPLOYMENT_MODE="auto"
                shift
                ;;
            --local)
                TARGET="local"
                shift
                ;;
            --vps)
                TARGET="vps"
                shift
                ;;
            --github)
                TARGET="github"
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Show banner
    print_banner
    
    # System checks
    check_system_requirements || exit 1
    
    # Setup environment
    setup_environment
    
    # Execute deployment based on mode
    if [ -n "$TARGET" ]; then
        case $TARGET in
            local)
                deploy_local
                ;;
            vps)
                deploy_vps
                ;;
            github)
                deploy_github_pages
                ;;
        esac
    else
        # Interactive mode
        show_deployment_menu
    fi
    
    echo ""
    print_section "🎉 النشر مكتمل | Deployment Complete"
    print_success "Thank you for using AI Agent Platform!"
    print_info "For support, visit: https://github.com/wasalstor-web/AI-Agent-Platform"
    echo ""
}

# Trap Ctrl+C
trap 'echo ""; print_warning "Deployment interrupted"; exit 130' INT

# Run main program
main "$@"
