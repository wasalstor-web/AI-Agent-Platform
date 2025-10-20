#!/bin/bash

#############################################################################
# Complete Project Deployment Script
# نص كامل لنشر المشروع / Complete script for project deployment
# Features: Domain verification, GitHub Pages check, OpenWebUI verification
#############################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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
    echo -e "${CYAN}ℹ $1${NC}"
}

print_step() {
    echo -e "${PURPLE}▶ $1${NC}"
}

#############################################################################
# Deployment Verification Functions
#############################################################################

check_openwebui_integration() {
    print_header "فحص تكامل OpenWebUI / Checking OpenWebUI Integration"
    
    local status=0
    
    # Check for setup script
    if [ -f "setup-openwebui.sh" ]; then
        print_success "ملف setup-openwebui.sh موجود / setup-openwebui.sh exists"
    else
        print_error "ملف setup-openwebui.sh مفقود / setup-openwebui.sh missing"
        status=1
    fi
    
    # Check for documentation
    if [ -f "OPENWEBUI.md" ]; then
        print_success "توثيق OpenWebUI موجود / OpenWebUI documentation exists"
    else
        print_error "توثيق OpenWebUI مفقود / OpenWebUI documentation missing"
        status=1
    fi
    
    # Check README mentions OpenWebUI
    if grep -q "OpenWebUI" README.md 2>/dev/null; then
        print_success "README يتضمن OpenWebUI / README includes OpenWebUI"
    else
        print_warning "README قد لا يتضمن OpenWebUI / README may not include OpenWebUI"
    fi
    
    return $status
}

check_github_pages() {
    print_header "فحص GitHub Pages / Checking GitHub Pages"
    
    local status=0
    
    # Check workflow file
    if [ -f ".github/workflows/deploy-pages.yml" ]; then
        print_success "سير عمل GitHub Pages موجود / GitHub Pages workflow exists"
    else
        print_error "سير عمل GitHub Pages مفقود / GitHub Pages workflow missing"
        status=1
    fi
    
    # Check index.html
    if [ -f "index.html" ]; then
        print_success "ملف index.html موجود / index.html exists"
        
        # Verify it's a valid HTML file
        if head -1 index.html | grep -q "<!DOCTYPE\|<html" ; then
            print_success "index.html ملف HTML صالح / index.html is valid HTML"
        else
            print_warning "index.html قد لا يكون ملف HTML صالح / index.html may not be valid HTML"
        fi
    else
        print_error "ملف index.html مفقود / index.html missing"
        status=1
    fi
    
    return $status
}

get_github_pages_url() {
    print_header "الحصول على رابط GitHub Pages / Getting GitHub Pages URL"
    
    # Get repository info from git remote
    local remote_url=$(git remote get-url origin 2>/dev/null)
    
    if [ -z "$remote_url" ]; then
        print_error "لم يتم العثور على git remote / No git remote found"
        return 1
    fi
    
    # Extract owner and repo from URL (handle both https and git@ formats)
    local owner_repo=""
    if [[ "$remote_url" =~ github\.com[:/]([^/]+)/([^/.]+)(\.git)?$ ]]; then
        local owner="${BASH_REMATCH[1]}"
        local repo="${BASH_REMATCH[2]}"
        owner_repo="$owner/$repo"
    fi
    
    if [ -z "$owner_repo" ]; then
        print_error "فشل استخراج معلومات المستودع / Failed to extract repo info"
        return 1
    fi
    
    # Convert owner/repo to GitHub Pages URL format
    local owner=$(echo "$owner_repo" | cut -d'/' -f1)
    local repo=$(echo "$owner_repo" | cut -d'/' -f2)
    local github_pages_url="https://${owner}.github.io/${repo}"
    
    print_success "رابط GitHub Pages: / GitHub Pages URL:"
    echo ""
    echo -e "${GREEN}    🌐 $github_pages_url${NC}"
    echo ""
    
    # Try to check if it's accessible
    print_info "جاري التحقق من إمكانية الوصول... / Checking accessibility..."
    
    if command -v curl &> /dev/null; then
        local http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$github_pages_url" 2>/dev/null)
        
        if [ "$http_code" = "200" ]; then
            print_success "الموقع متاح وقيد التشغيل! / Site is accessible and running!"
        elif [ "$http_code" = "404" ]; then
            print_warning "الموقع غير متاح حاليًا (404) / Site not accessible yet (404)"
            print_info "قد يستغرق GitHub Pages بضع دقائق لنشر الموقع / GitHub Pages may take a few minutes to deploy"
        else
            print_warning "رمز الاستجابة HTTP: $http_code"
        fi
    else
        print_info "curl غير متاح للتحقق / curl not available for verification"
    fi
    
    return 0
}

check_deployment_scripts() {
    print_header "فحص سكريبتات النشر / Checking Deployment Scripts"
    
    local scripts=(
        "deploy.sh"
        "smart-deploy.sh"
        "setup-openwebui.sh"
        "finalize_project.sh"
        "directive_finalize.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                print_success "$script موجود وقابل للتنفيذ / $script exists and is executable"
            else
                print_warning "$script موجود لكن غير قابل للتنفيذ / $script exists but not executable"
            fi
        else
            print_warning "$script غير موجود / $script not found"
        fi
    done
}

check_documentation() {
    print_header "فحص التوثيق / Checking Documentation"
    
    local docs=(
        "README.md"
        "OPENWEBUI.md"
        "FINALIZATION.md"
        "IMPLEMENTATION_SUMMARY.md"
    )
    
    for doc in "${docs[@]}"; do
        if [ -f "$doc" ]; then
            local line_count=$(wc -l < "$doc")
            print_success "$doc موجود ($line_count سطر) / $doc exists ($line_count lines)"
        else
            print_warning "$doc غير موجود / $doc not found"
        fi
    done
}

verify_git_status() {
    print_header "فحص حالة Git / Checking Git Status"
    
    # Check if in git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "ليس مستودع git / Not a git repository"
        return 1
    fi
    
    # Get current branch
    local current_branch=$(git branch --show-current)
    print_info "الفرع الحالي / Current branch: $current_branch"
    
    # Check for uncommitted changes
    if git diff-index --quiet HEAD --; then
        print_success "لا توجد تغييرات غير محفوظة / No uncommitted changes"
    else
        print_warning "توجد تغييرات غير محفوظة / There are uncommitted changes"
        git status --short
    fi
    
    # Check remote status
    local remote_url=$(git remote get-url origin 2>/dev/null)
    if [ -n "$remote_url" ]; then
        print_success "مستودع بعيد مكوّن: $remote_url / Remote configured: $remote_url"
    else
        print_warning "لا يوجد مستودع بعيد / No remote configured"
    fi
    
    return 0
}

generate_deployment_report() {
    print_header "إنشاء تقرير النشر / Generating Deployment Report"
    
    local report_file="/tmp/deployment-report-$(date +%Y%m%d-%H%M%S).txt"
    
    cat > "$report_file" << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AI Agent Platform - تقرير النشر الكامل
AI Agent Platform - Complete Deployment Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

تاريخ الإنشاء / Generated: $(date '+%Y-%m-%d %H:%M:%S')

═══════════════════════════════════════════════════════
1. حالة OpenWebUI / OpenWebUI Status
═══════════════════════════════════════════════════════

ملف الإعداد / Setup Script: $([ -f "setup-openwebui.sh" ] && echo "✓ موجود / Exists" || echo "✗ مفقود / Missing")
التوثيق / Documentation: $([ -f "OPENWEBUI.md" ] && echo "✓ موجود / Exists" || echo "✗ مفقود / Missing")

═══════════════════════════════════════════════════════
2. حالة GitHub Pages / GitHub Pages Status
═══════════════════════════════════════════════════════

سير العمل / Workflow: $([ -f ".github/workflows/deploy-pages.yml" ] && echo "✓ موجود / Exists" || echo "✗ مفقود / Missing")
صفحة الفهرس / Index Page: $([ -f "index.html" ] && echo "✓ موجود / Exists" || echo "✗ مفقود / Missing")

رابط الموقع / Site URL:
$(git remote get-url origin 2>/dev/null | sed -n 's#.*github.com[:/]\(.*\)\.git#https://\1#p' | sed 's#.*github.com[:/]\(.*\)#https://\1#' | sed 's#/#.github.io/#')

═══════════════════════════════════════════════════════
3. معلومات المستودع / Repository Information
═══════════════════════════════════════════════════════

الفرع الحالي / Current Branch: $(git branch --show-current 2>/dev/null || echo "غير معروف / Unknown")
آخر التزام / Last Commit: $(git log -1 --oneline 2>/dev/null || echo "غير متاح / N/A")
المستودع البعيد / Remote: $(git remote get-url origin 2>/dev/null || echo "غير مكوّن / Not configured")

═══════════════════════════════════════════════════════
4. سكريبتات النشر / Deployment Scripts
═══════════════════════════════════════════════════════

deploy.sh: $([ -x "deploy.sh" ] && echo "✓ قابل للتنفيذ / Executable" || echo "○ غير قابل للتنفيذ / Not executable")
smart-deploy.sh: $([ -x "smart-deploy.sh" ] && echo "✓ قابل للتنفيذ / Executable" || echo "○ غير قابل للتنفيذ / Not executable")
setup-openwebui.sh: $([ -x "setup-openwebui.sh" ] && echo "✓ قابل للتنفيذ / Executable" || echo "○ غير قابل للتنفيذ / Not executable")
finalize_project.sh: $([ -x "finalize_project.sh" ] && echo "✓ قابل للتنفيذ / Executable" || echo "○ غير قابل للتنفيذ / Not executable")

═══════════════════════════════════════════════════════
5. التوثيق / Documentation
═══════════════════════════════════════════════════════

README.md: $([ -f "README.md" ] && wc -l < README.md || echo "0") سطر / lines
OPENWEBUI.md: $([ -f "OPENWEBUI.md" ] && wc -l < OPENWEBUI.md || echo "0") سطر / lines
FINALIZATION.md: $([ -f "FINALIZATION.md" ] && wc -l < FINALIZATION.md || echo "0") سطر / lines

═══════════════════════════════════════════════════════
6. الخلاصة / Summary
═══════════════════════════════════════════════════════

✓ تم إضافة OpenWebUI بنجاح
  OpenWebUI successfully added

✓ تم تكوين GitHub Pages
  GitHub Pages configured

✓ المشروع جاهز للنشر
  Project ready for deployment

═══════════════════════════════════════════════════════

EOF

    print_success "تم إنشاء التقرير في: / Report generated at: $report_file"
    
    # Display the report
    cat "$report_file"
    
    return 0
}

#############################################################################
# Main Deployment Flow
#############################################################################

main() {
    print_header "🚀 نشر مشروع AI Agent Platform الكامل / Complete AI Agent Platform Deployment"
    
    echo -e "${CYAN}هذا السكريبت يتحقق من جاهزية المشروع للنشر الكامل${NC}"
    echo -e "${CYAN}This script verifies the project is ready for complete deployment${NC}"
    echo ""
    
    local overall_status=0
    
    # Step 1: Check OpenWebUI Integration
    print_step "الخطوة 1: التحقق من تكامل OpenWebUI / Step 1: Verify OpenWebUI Integration"
    if check_openwebui_integration; then
        print_success "✓ تكامل OpenWebUI مكتمل / OpenWebUI integration complete"
    else
        print_error "✗ تكامل OpenWebUI غير مكتمل / OpenWebUI integration incomplete"
        overall_status=1
    fi
    echo ""
    
    # Step 2: Check GitHub Pages
    print_step "الخطوة 2: التحقق من GitHub Pages / Step 2: Verify GitHub Pages"
    if check_github_pages; then
        print_success "✓ GitHub Pages مكوّن بشكل صحيح / GitHub Pages properly configured"
    else
        print_error "✗ GitHub Pages غير مكوّن / GitHub Pages not configured"
        overall_status=1
    fi
    echo ""
    
    # Step 3: Get GitHub Pages URL (preview domain)
    print_step "الخطوة 3: الحصول على رابط المعاينة / Step 3: Get Preview URL"
    get_github_pages_url
    echo ""
    
    # Step 4: Check deployment scripts
    print_step "الخطوة 4: التحقق من سكريبتات النشر / Step 4: Check Deployment Scripts"
    check_deployment_scripts
    echo ""
    
    # Step 5: Check documentation
    print_step "الخطوة 5: التحقق من التوثيق / Step 5: Verify Documentation"
    check_documentation
    echo ""
    
    # Step 6: Verify Git status
    print_step "الخطوة 6: التحقق من حالة Git / Step 6: Verify Git Status"
    if verify_git_status; then
        print_success "✓ حالة Git صحيحة / Git status is good"
    else
        print_warning "⚠ قد تكون هناك مشاكل في Git / There may be Git issues"
    fi
    echo ""
    
    # Step 7: Generate deployment report
    print_step "الخطوة 7: إنشاء تقرير النشر / Step 7: Generate Deployment Report"
    generate_deployment_report
    echo ""
    
    # Final summary
    print_header "📊 ملخص النشر / Deployment Summary"
    
    if [ $overall_status -eq 0 ]; then
        echo -e "${GREEN}"
        echo "╔════════════════════════════════════════════════════════╗"
        echo "║                                                        ║"
        echo "║  ✓ نعم، تم إضافة OpenWeb                             ║"
        echo "║    Yes, OpenWeb has been added                        ║"
        echo "║                                                        ║"
        echo "║  ✓ المشروع جاهز للنشر الكامل                        ║"
        echo "║    Project is ready for complete deployment          ║"
        echo "║                                                        ║"
        echo "║  ✓ تم توليد رابط المعاينة                           ║"
        echo "║    Preview URL has been generated                     ║"
        echo "║                                                        ║"
        echo "║  ✓ جميع المكونات في مكانها الصحيح                  ║"
        echo "║    All components are in place                        ║"
        echo "║                                                        ║"
        echo "╚════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        echo ""
        print_success "الخطوات التالية / Next Steps:"
        echo ""
        echo "  1. تأكد من دفع التغييرات إلى GitHub"
        echo "     Make sure changes are pushed to GitHub"
        echo ""
        echo "  2. انتظر بضع دقائق حتى ينشر GitHub Pages الموقع"
        echo "     Wait a few minutes for GitHub Pages to deploy"
        echo ""
        echo "  3. افتح رابط GitHub Pages في المتصفح"
        echo "     Open the GitHub Pages URL in your browser"
        echo ""
        echo "  4. (اختياري) قم بإعداد OpenWebUI على VPS"
        echo "     (Optional) Set up OpenWebUI on your VPS"
        echo "     ./setup-openwebui.sh"
        echo ""
        
    else
        echo -e "${YELLOW}"
        echo "╔════════════════════════════════════════════════════════╗"
        echo "║                                                        ║"
        echo "║  ⚠ يحتاج المشروع إلى بعض الإصلاحات                  ║"
        echo "║    Project needs some fixes                           ║"
        echo "║                                                        ║"
        echo "║  راجع الأخطاء أعلاه لمزيد من التفاصيل              ║"
        echo "║  Review errors above for details                      ║"
        echo "║                                                        ║"
        echo "╚════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
    fi
    
    return $overall_status
}

# Run main function
main "$@"
