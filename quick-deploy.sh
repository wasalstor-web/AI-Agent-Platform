#!/bin/bash

# Quick Deploy Script for AI Agent Platform
# نشر سريع لمنصة وكيل الذكاء الاصطناعي

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Header
print_header() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  نشر سريع - AI Agent Platform - Quick Deploy${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Success message
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Error message
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Info message
print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Warning message
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Menu options
show_menu() {
    echo -e "${CYAN}اختر طريقة النشر / Choose Deployment Method:${NC}"
    echo ""
    echo "1) 🚀 Vercel - نشر سريع ومجاني / Quick & Free"
    echo "2) 🌐 Netlify - نشر سريع ومجاني / Quick & Free"
    echo "3) 📡 Surge.sh - نشر بسيط جداً / Very Simple"
    echo "4) 🖥️  VPS - النشر على خادمك / Deploy to Your Server"
    echo "5) 🏠 Local Server - خادم محلي للتجربة / Local Testing Server"
    echo "6) 📖 GitHub Pages - تعليمات التفعيل / Activation Instructions"
    echo "7) ❌ إلغاء / Cancel"
    echo ""
    echo -n "اختيارك / Your choice [1-7]: "
}

# Deploy to Vercel
deploy_vercel() {
    print_header
    echo -e "${CYAN}النشر على Vercel / Deploying to Vercel${NC}"
    echo ""
    
    # Check if vercel is installed
    if ! command -v vercel &> /dev/null; then
        print_warning "Vercel CLI غير مثبت / Vercel CLI not installed"
        echo -e "${YELLOW}تثبيت Vercel CLI... / Installing Vercel CLI...${NC}"
        npm i -g vercel
    fi
    
    print_info "نشر المشروع... / Deploying project..."
    vercel --prod
    
    print_success "تم النشر بنجاح! / Deployed successfully!"
    echo ""
    echo -e "${GREEN}موقعك الآن متاح على الرابط أعلاه${NC}"
    echo -e "${GREEN}Your site is now available at the URL above${NC}"
}

# Deploy to Netlify
deploy_netlify() {
    print_header
    echo -e "${CYAN}النشر على Netlify / Deploying to Netlify${NC}"
    echo ""
    
    # Check if netlify is installed
    if ! command -v netlify &> /dev/null; then
        print_warning "Netlify CLI غير مثبت / Netlify CLI not installed"
        echo -e "${YELLOW}تثبيت Netlify CLI... / Installing Netlify CLI...${NC}"
        npm i -g netlify-cli
    fi
    
    print_info "نشر المشروع... / Deploying project..."
    netlify deploy --prod
    
    print_success "تم النشر بنجاح! / Deployed successfully!"
    echo ""
    echo -e "${GREEN}موقعك الآن متاح على الرابط أعلاه${NC}"
    echo -e "${GREEN}Your site is now available at the URL above${NC}"
}

# Deploy to Surge
deploy_surge() {
    print_header
    echo -e "${CYAN}النشر على Surge.sh / Deploying to Surge.sh${NC}"
    echo ""
    
    # Check if surge is installed
    if ! command -v surge &> /dev/null; then
        print_warning "Surge CLI غير مثبت / Surge CLI not installed"
        echo -e "${YELLOW}تثبيت Surge CLI... / Installing Surge CLI...${NC}"
        npm i -g surge
    fi
    
    print_info "نشر المشروع... / Deploying project..."
    
    # Ask for domain name
    echo -n "اسم النطاق المطلوب / Desired domain (e.g., ai-agent-platform): "
    read -r domain
    
    if [ -z "$domain" ]; then
        domain="ai-agent-platform-$(date +%s)"
    fi
    
    surge . "${domain}.surge.sh"
    
    print_success "تم النشر بنجاح! / Deployed successfully!"
    echo ""
    echo -e "${GREEN}موقعك متاح على / Your site is available at:${NC}"
    echo -e "${CYAN}https://${domain}.surge.sh${NC}"
}

# Deploy to VPS
deploy_vps() {
    print_header
    echo -e "${CYAN}النشر على VPS / Deploying to VPS${NC}"
    echo ""
    
    # Get VPS details
    echo -n "عنوان VPS / VPS Address (e.g., user@vps.com): "
    read -r vps_host
    
    if [ -z "$vps_host" ]; then
        print_error "يجب إدخال عنوان VPS / VPS address is required"
        return 1
    fi
    
    echo -n "مسار النشر على VPS / Deployment path on VPS (default: /var/www/html): "
    read -r deploy_path
    
    if [ -z "$deploy_path" ]; then
        deploy_path="/var/www/html"
    fi
    
    print_info "نسخ الملفات إلى VPS... / Copying files to VPS..."
    
    # Create a temporary archive
    temp_archive="/tmp/ai-agent-platform-$(date +%s).tar.gz"
    tar -czf "$temp_archive" --exclude='.git' --exclude='node_modules' .
    
    # Copy to VPS
    scp "$temp_archive" "$vps_host:/tmp/"
    
    # Extract on VPS
    ssh "$vps_host" "cd $deploy_path && sudo tar -xzf /tmp/$(basename $temp_archive) && sudo rm /tmp/$(basename $temp_archive)"
    
    # Clean up
    rm "$temp_archive"
    
    print_success "تم النشر بنجاح! / Deployed successfully!"
    echo ""
    echo -e "${GREEN}موقعك الآن متاح على VPS الخاص بك${NC}"
    echo -e "${GREEN}Your site is now available on your VPS${NC}"
}

# Start local server
start_local_server() {
    print_header
    echo -e "${CYAN}تشغيل خادم محلي / Starting Local Server${NC}"
    echo ""
    
    PORT=8000
    
    print_info "بدء الخادم على المنفذ $PORT / Starting server on port $PORT..."
    print_success "الخادم يعمل! / Server is running!"
    echo ""
    echo -e "${GREEN}افتح المتصفح على / Open browser at:${NC}"
    echo -e "${CYAN}http://localhost:$PORT${NC}"
    echo ""
    echo -e "${YELLOW}اضغط Ctrl+C للإيقاف / Press Ctrl+C to stop${NC}"
    echo ""
    
    # Try to open browser
    if command -v xdg-open &> /dev/null; then
        xdg-open "http://localhost:$PORT" 2>/dev/null &
    elif command -v open &> /dev/null; then
        open "http://localhost:$PORT" 2>/dev/null &
    fi
    
    # Start Python HTTP server
    python3 -m http.server $PORT
}

# Show GitHub Pages instructions
show_github_pages_instructions() {
    print_header
    echo -e "${CYAN}تعليمات تفعيل GitHub Pages / GitHub Pages Activation Instructions${NC}"
    echo ""
    
    print_info "لتفعيل GitHub Pages، اتبع الخطوات التالية:"
    print_info "To enable GitHub Pages, follow these steps:"
    echo ""
    
    echo "1. ${BLUE}اذهب إلى / Go to:${NC}"
    echo "   https://github.com/wasalstor-web/AI-Agent-Platform/settings/pages"
    echo ""
    
    echo "2. ${BLUE}في قسم 'Source' اختر / Under 'Source' select:${NC}"
    echo "   - GitHub Actions"
    echo ""
    
    echo "3. ${BLUE}احفظ التغييرات / Save changes${NC}"
    echo ""
    
    echo "4. ${BLUE}انتظر بضع دقائق / Wait a few minutes${NC}"
    echo ""
    
    echo "5. ${BLUE}موقعك سيكون متاحاً على / Your site will be at:${NC}"
    echo "   ${CYAN}https://wasalstor-web.github.io/AI-Agent-Platform/${NC}"
    echo ""
    
    print_warning "ملاحظة: لا يمكن تفعيل GitHub Pages برمجياً لأسباب أمنية"
    print_warning "Note: GitHub Pages cannot be enabled programmatically for security reasons"
    echo ""
    
    echo -e "${YELLOW}للمزيد من التفاصيل، راجع: GITHUB_PAGES_SETUP.md${NC}"
    echo -e "${YELLOW}For more details, see: GITHUB_PAGES_SETUP.md${NC}"
    echo ""
    
    echo -n "اضغط Enter للعودة للقائمة / Press Enter to return to menu..."
    read -r
}

# Main script
main() {
    clear
    print_header
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                deploy_vercel
                break
                ;;
            2)
                deploy_netlify
                break
                ;;
            3)
                deploy_surge
                break
                ;;
            4)
                deploy_vps
                break
                ;;
            5)
                start_local_server
                break
                ;;
            6)
                show_github_pages_instructions
                clear
                print_header
                ;;
            7)
                print_info "تم الإلغاء / Cancelled"
                exit 0
                ;;
            *)
                print_error "خيار غير صحيح / Invalid choice"
                echo ""
                ;;
        esac
    done
}

# Run main function
main
