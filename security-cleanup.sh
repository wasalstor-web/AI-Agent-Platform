#!/bin/bash
# Security Cleanup Script for Making Repository Public
# نص الأمان لتنظيف المستودع قبل جعله عام

set -e

echo "================================================"
echo "🔒 Security Cleanup Script"
echo "نص تنظيف الأمان"
echo "================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo ""
print_status "Starting security cleanup process..."
print_status "بدء عملية تنظيف الأمان..."
echo ""

# Step 1: Backup sensitive files
print_status "Step 1: Creating backups of sensitive files..."
print_status "الخطوة 1: إنشاء نسخ احتياطية من الملفات الحساسة..."

if [ -f ".env" ]; then
    cp .env .env.backup.local
    print_success "Backed up .env to .env.backup.local"
    print_warning "⚠️  Please save your .env values to a password manager!"
    print_warning "⚠️  يرجى حفظ قيم .env في مدير كلمات المرور!"
else
    print_warning ".env file not found"
fi

if [ -f ".env.openwebui" ]; then
    cp .env.openwebui .env.openwebui.backup.local
    print_success "Backed up .env.openwebui to .env.openwebui.backup.local"
else
    print_warning ".env.openwebui file not found"
fi

echo ""

# Step 2: Check if files are tracked in Git
print_status "Step 2: Checking if sensitive files are tracked in Git..."
print_status "الخطوة 2: التحقق من الملفات الحساسة المُتتبعة في Git..."

TRACKED_FILES=$(git ls-files | grep -E "^\.env$|^\.env\.openwebui$" || true)

if [ -n "$TRACKED_FILES" ]; then
    print_error "⚠️  CRITICAL: The following sensitive files are tracked in Git:"
    print_error "⚠️  حرج: الملفات الحساسة التالية مُتتبعة في Git:"
    echo "$TRACKED_FILES"
    echo ""
    
    read -p "Do you want to remove these files from Git tracking? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Removing files from Git tracking..."
        print_status "إزالة الملفات من تتبع Git..."
        
        git rm --cached .env 2>/dev/null || true
        git rm --cached .env.openwebui 2>/dev/null || true
        
        print_success "Files removed from Git tracking"
        print_success "تم إزالة الملفات من تتبع Git"
        
        print_status "Creating commit..."
        git commit -m "🔒 Remove sensitive .env files from Git tracking

- Removed .env from version control
- Removed .env.openwebui from version control
- These files are already in .gitignore
- Sensitive data should be stored in GitHub Secrets

تمت إزالة الملفات الحساسة من التحكم في الإصدار"
        
        print_success "Commit created successfully"
        print_warning "⚠️  Don't forget to push: git push"
        print_warning "⚠️  لا تنس الدفع: git push"
    else
        print_warning "Skipped removing files from Git tracking"
    fi
else
    print_success "No sensitive files are tracked in Git"
    print_success "لا توجد ملفات حساسة مُتتبعة في Git"
fi

echo ""

# Step 3: Scan for API keys in code
print_status "Step 3: Scanning for potential API keys in code..."
print_status "الخطوة 3: البحث عن مفاتيح API المحتملة في الكود..."

API_KEYS=$(grep -r "sk-[a-zA-Z0-9]\{32,\}" --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" --exclude="*.backup*" --exclude="security-cleanup.sh" . || true)

if [ -n "$API_KEYS" ]; then
    print_error "⚠️  Potential API keys found in code:"
    print_error "⚠️  تم العثور على مفاتيح API محتملة في الكود:"
    echo "$API_KEYS"
    print_warning "Please review and remove these before making repository public!"
    print_warning "يرجى المراجعة والإزالة قبل جعل المستودع عام!"
else
    print_success "No obvious API keys found in code"
    print_success "لم يتم العثور على مفاتيح API واضحة في الكود"
fi

echo ""

# Step 4: Check .gitignore
print_status "Step 4: Verifying .gitignore configuration..."
print_status "الخطوة 4: التحقق من إعدادات .gitignore..."

REQUIRED_IGNORES=(".env" ".env.local" "*.key" "*.pem")
MISSING_IGNORES=()

for pattern in "${REQUIRED_IGNORES[@]}"; do
    if ! grep -q "^${pattern}$" .gitignore; then
        MISSING_IGNORES+=("$pattern")
    fi
done

if [ ${#MISSING_IGNORES[@]} -eq 0 ]; then
    print_success ".gitignore is properly configured"
    print_success ".gitignore مُعد بشكل صحيح"
else
    print_warning "The following patterns are missing from .gitignore:"
    print_warning "الأنماط التالية مفقودة من .gitignore:"
    printf '%s\n' "${MISSING_IGNORES[@]}"
fi

echo ""

# Step 5: List GitHub Secrets that need to be configured
print_status "Step 5: GitHub Secrets that should be configured..."
print_status "الخطوة 5: GitHub Secrets التي يجب إعدادها..."

echo ""
echo "Please add the following secrets in GitHub Settings > Secrets and variables > Actions:"
echo "يرجى إضافة الأسرار التالية في GitHub Settings > Secrets and variables > Actions:"
echo ""
echo "  - OPENROUTER_API_KEY"
echo "  - FASTAPI_SECRET_KEY"
echo "  - OPENWEBUI_JWT_TOKEN"
echo "  - OPENWEBUI_API_KEY"
echo "  - VPS_HOST (if applicable)"
echo "  - VPS_USER (if applicable)"
echo "  - VPS_KEY (if applicable)"
echo ""

# Step 6: Summary
echo ""
print_status "================================================"
print_status "📊 Security Cleanup Summary | ملخص تنظيف الأمان"
print_status "================================================"
echo ""

if [ -f ".env.backup.local" ]; then
    print_success "✓ Backups created in .env.backup.local and .env.openwebui.backup.local"
    print_success "✓ تم إنشاء نسخ احتياطية"
fi

if [ -z "$TRACKED_FILES" ]; then
    print_success "✓ No sensitive files tracked in Git"
    print_success "✓ لا توجد ملفات حساسة مُتتبعة في Git"
else
    print_warning "⚠ Sensitive files need to be removed from Git tracking"
    print_warning "⚠ الملفات الحساسة تحتاج للإزالة من تتبع Git"
fi

if [ -z "$API_KEYS" ]; then
    print_success "✓ No obvious API keys found in code"
    print_success "✓ لم يتم العثور على مفاتيح API واضحة"
else
    print_error "✗ Potential API keys found - review required"
    print_error "✗ تم العثور على مفاتيح API محتملة - مراجعة مطلوبة"
fi

echo ""
print_status "================================================"
print_status "📚 Next Steps | الخطوات التالية"
print_status "================================================"
echo ""
echo "1. Review SECURITY_CHECKLIST_BEFORE_PUBLIC.md"
echo "   راجع SECURITY_CHECKLIST_BEFORE_PUBLIC.md"
echo ""
echo "2. Add all secrets to GitHub Secrets"
echo "   أضف جميع الأسرار إلى GitHub Secrets"
echo ""
echo "3. (Optional) Clean Git history using git-filter-repo or BFG"
echo "   (اختياري) نظف تاريخ Git باستخدام git-filter-repo أو BFG"
echo ""
echo "4. Review MAKE_REPOSITORY_PUBLIC_GUIDE.md for making repo public"
echo "   راجع MAKE_REPOSITORY_PUBLIC_GUIDE.md لجعل المستودع عام"
echo ""
echo "5. Test all GitHub Actions workflows"
echo "   اختبر جميع سير عمل GitHub Actions"
echo ""
echo "6. Make repository public: Settings > Danger Zone > Change visibility"
echo "   اجعل المستودع عام: Settings > Danger Zone > Change visibility"
echo ""
print_success "Security cleanup process completed!"
print_success "اكتملت عملية تنظيف الأمان!"
echo ""
