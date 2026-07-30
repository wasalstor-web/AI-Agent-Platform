# 🔒 قائمة التحقق الأمني قبل جعل المستودع عام
# Security Checklist Before Making Repository Public

<div dir="rtl">

## ⚠️ تحذير مهم جداً

**تم العثور على ملفات حساسة مُتتبعة في Git!**

الملفات التالية تحتوي على بيانات حساسة ومُتتبعة حالياً في Git:
- `.env` - يحتوي على مفاتيح API وتوكنات JWT
- `.env.openwebui` - يحتوي على إعدادات OpenWebUI الحساسة

**يجب إزالة هذه الملفات من تتبع Git قبل جعل المستودع عام!**

</div>

---

## 🚨 Critical Security Issues Found

**Sensitive files are currently being tracked in Git!**

The following files contain sensitive data and are currently tracked:
- `.env` - Contains API keys and JWT tokens
- `.env.openwebui` - Contains sensitive OpenWebUI settings

**These files MUST be removed from Git tracking before making the repository public!**

---

<div dir="rtl">

## 📋 خطوات إزالة الملفات الحساسة من Git

### الطريقة 1: إزالة من التتبع فقط (الموصى بها للملفات الحالية)

```bash
# إزالة الملفات من تتبع Git مع الاحتفاظ بها محلياً
git rm --cached .env
git rm --cached .env.openwebui

# إنشاء commit للإزالة
git commit -m "Remove sensitive .env files from Git tracking"

# دفع التغييرات
git push
```

**ملاحظة**: هذه الطريقة تُزيل الملفات من التتبع المستقبلي فقط، لكن البيانات الحساسة ستبقى في تاريخ Git.

### الطريقة 2: إزالة من التاريخ الكامل (موصى بها قبل جعل المستودع عام)

⚠️ **تحذير**: هذه الطريقة تعيد كتابة تاريخ Git وتتطلب force push

#### باستخدام git filter-repo (الطريقة الموصى بها)

```bash
# تثبيت git-filter-repo
pip install git-filter-repo

# إنشاء نسخة احتياطية
git clone --mirror https://github.com/wasalstor-web/AI-Agent-Platform.git backup-repo

# إزالة الملفات من التاريخ الكامل
git filter-repo --path .env --invert-paths
git filter-repo --path .env.openwebui --invert-paths

# الدفع (يتطلب force push)
# تحذير: تأكد من أن جميع المتعاونين على علم بهذا التغيير
git push --force --all
git push --force --tags
```

#### باستخدام BFG Repo-Cleaner (طريقة بديلة)

```bash
# تنزيل BFG
wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar

# إنشاء نسخة احتياطية
git clone --mirror https://github.com/wasalstor-web/AI-Agent-Platform.git backup-repo

# إزالة الملفات
java -jar bfg-1.14.0.jar --delete-files .env
java -jar bfg-1.14.0.jar --delete-files .env.openwebui

# تنظيف
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# الدفع (يتطلب force push)
git push --force --all
git push --force --tags
```

</div>

---

## 📋 Steps to Remove Sensitive Files from Git

### Method 1: Remove from Tracking Only (Recommended for Current Files)

```bash
# Remove files from Git tracking while keeping them locally
git rm --cached .env
git rm --cached .env.openwebui

# Create commit for the removal
git commit -m "Remove sensitive .env files from Git tracking"

# Push changes
git push
```

**Note**: This method only removes files from future tracking, but sensitive data will remain in Git history.

### Method 2: Remove from Complete History (Recommended Before Making Public)

⚠️ **Warning**: This method rewrites Git history and requires force push

#### Using git filter-repo (Recommended Method)

```bash
# Install git-filter-repo
pip install git-filter-repo

# Create backup
git clone --mirror https://github.com/wasalstor-web/AI-Agent-Platform.git backup-repo

# Remove files from complete history
git filter-repo --path .env --invert-paths
git filter-repo --path .env.openwebui --invert-paths

# Push (requires force push)
# Warning: Ensure all collaborators are aware of this change
git push --force --all
git push --force --tags
```

#### Using BFG Repo-Cleaner (Alternative Method)

```bash
# Download BFG
wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar

# Create backup
git clone --mirror https://github.com/wasalstor-web/AI-Agent-Platform.git backup-repo

# Remove files
java -jar bfg-1.14.0.jar --delete-files .env
java -jar bfg-1.14.0.jar --delete-files .env.openwebui

# Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Push (requires force push)
git push --force --all
git push --force --tags
```

---

<div dir="rtl">

## ✅ قائمة التحقق الكاملة قبل جعل المستودع عام

### 1. إزالة البيانات الحساسة

- [ ] إزالة `.env` من تتبع Git
- [ ] إزالة `.env.openwebui` من تتبع Git
- [ ] التحقق من عدم وجود مفاتيح API في الكود
- [ ] التحقق من عدم وجود كلمات مرور في الملفات
- [ ] التحقق من عدم وجود توكنات JWT مكشوفة
- [ ] فحص تاريخ Git للبيانات الحساسة
- [ ] إزالة مفاتيح SSH إن وجدت
- [ ] إزالة معلومات الاتصال بقواعد البيانات

### 2. تحديث ملفات الأمثلة

- [ ] التأكد من أن `.env.example` لا يحتوي على قيم حقيقية
- [ ] التأكد من أن `.env.dlplus.example` لا يحتوي على قيم حقيقية
- [ ] التأكد من أن `.env.instant-deploy.example` لا يحتوي على قيم حقيقية
- [ ] إضافة تعليقات توضيحية في ملفات الأمثلة

### 3. إعداد GitHub Secrets

- [ ] إضافة `OPENROUTER_API_KEY` إلى GitHub Secrets
- [ ] إضافة `VPS_HOST` إلى GitHub Secrets (إن وجد)
- [ ] إضافة `VPS_USER` إلى GitHub Secrets (إن وجد)
- [ ] إضافة `VPS_KEY` إلى GitHub Secrets (إن وجد)
- [ ] إضافة `FASTAPI_SECRET_KEY` إلى GitHub Secrets
- [ ] إضافة `OPENWEBUI_JWT_TOKEN` إلى GitHub Secrets
- [ ] إضافة `OPENWEBUI_API_KEY` إلى GitHub Secrets

### 4. تحديث GitHub Actions Workflows

- [ ] التحقق من أن جميع workflows تستخدم Secrets بدلاً من القيم المباشرة
- [ ] مراجعة `.github/workflows/vps-auto-verify.yml`
- [ ] مراجعة `.github/workflows/deploy-pages.yml`
- [ ] مراجعة `.github/workflows/openweb-pages.yml`
- [ ] اختبار workflows للتأكد من عملها

### 5. مراجعة .gitignore

- [x] `.env` موجود في .gitignore
- [x] `.env.local` موجود في .gitignore
- [x] `*.key` موجود في .gitignore
- [x] `*.pem` موجود في .gitignore
- [ ] التحقق من عدم وجود ملفات أخرى يجب إضافتها

### 6. إضافة ملفات المشروع الأساسية

- [ ] إضافة ملف LICENSE
- [ ] إضافة ملف CODE_OF_CONDUCT.md
- [ ] إضافة ملف CONTRIBUTING.md
- [ ] إضافة ملف SECURITY.md (سياسة الأمان)
- [ ] تحديث README.md

### 7. مراجعة الوثائق

- [x] README.md محدث وواضح
- [ ] إضافة شارات (badges) للمشروع
- [ ] توثيق طريقة التثبيت
- [ ] توثيق طريقة الاستخدام
- [ ] إضافة أمثلة عملية

### 8. فحص الأمان

- [ ] تشغيل git-secrets للفحص
- [ ] فحص الكود بحثاً عن vulnerabilities
- [ ] مراجعة dependencies للتأكد من أمانها
- [ ] تفعيل GitHub Secret Scanning
- [ ] تفعيل Dependabot

### 9. الاختبار

- [ ] اختبار GitHub Actions workflows
- [ ] التأكد من عمل جميع السكريبتات
- [ ] اختبار التكاملات (OpenWebUI، Render، إلخ)
- [ ] مراجعة الأخطاء المحتملة

### 10. التحضير للإطلاق

- [ ] إنشاء نسخة احتياطية من المستودع
- [ ] إخطار المتعاونين (إن وجدوا)
- [ ] تحديد نسخة release (مثل v1.0.0)
- [ ] كتابة CHANGELOG.md

</div>

---

## ✅ Complete Checklist Before Making Repository Public

### 1. Remove Sensitive Data

- [ ] Remove `.env` from Git tracking
- [ ] Remove `.env.openwebui` from Git tracking
- [ ] Verify no API keys in code
- [ ] Verify no passwords in files
- [ ] Verify no exposed JWT tokens
- [ ] Scan Git history for sensitive data
- [ ] Remove SSH keys if present
- [ ] Remove database connection information

### 2. Update Example Files

- [ ] Ensure `.env.example` contains no real values
- [ ] Ensure `.env.dlplus.example` contains no real values
- [ ] Ensure `.env.instant-deploy.example` contains no real values
- [ ] Add explanatory comments in example files

### 3. Setup GitHub Secrets

- [ ] Add `OPENROUTER_API_KEY` to GitHub Secrets
- [ ] Add `VPS_HOST` to GitHub Secrets (if applicable)
- [ ] Add `VPS_USER` to GitHub Secrets (if applicable)
- [ ] Add `VPS_KEY` to GitHub Secrets (if applicable)
- [ ] Add `FASTAPI_SECRET_KEY` to GitHub Secrets
- [ ] Add `OPENWEBUI_JWT_TOKEN` to GitHub Secrets
- [ ] Add `OPENWEBUI_API_KEY` to GitHub Secrets

### 4. Update GitHub Actions Workflows

- [ ] Verify all workflows use Secrets instead of direct values
- [ ] Review `.github/workflows/vps-auto-verify.yml`
- [ ] Review `.github/workflows/deploy-pages.yml`
- [ ] Review `.github/workflows/openweb-pages.yml`
- [ ] Test workflows to ensure they work

### 5. Review .gitignore

- [x] `.env` is in .gitignore
- [x] `.env.local` is in .gitignore
- [x] `*.key` is in .gitignore
- [x] `*.pem` is in .gitignore
- [ ] Check for other files that should be added

### 6. Add Essential Project Files

- [ ] Add LICENSE file
- [ ] Add CODE_OF_CONDUCT.md
- [ ] Add CONTRIBUTING.md
- [ ] Add SECURITY.md (security policy)
- [ ] Update README.md

### 7. Review Documentation

- [x] README.md is updated and clear
- [ ] Add project badges
- [ ] Document installation process
- [ ] Document usage instructions
- [ ] Add practical examples

### 8. Security Scanning

- [ ] Run git-secrets for scanning
- [ ] Scan code for vulnerabilities
- [ ] Review dependencies for security
- [ ] Enable GitHub Secret Scanning
- [ ] Enable Dependabot

### 9. Testing

- [ ] Test GitHub Actions workflows
- [ ] Ensure all scripts work
- [ ] Test integrations (OpenWebUI, Render, etc.)
- [ ] Review potential errors

### 10. Launch Preparation

- [ ] Create repository backup
- [ ] Notify collaborators (if any)
- [ ] Define release version (e.g., v1.0.0)
- [ ] Write CHANGELOG.md

---

<div dir="rtl">

## 🔧 أوامر مفيدة للفحص

### فحص الملفات الحساسة

```bash
# البحث عن مفاتيح API
grep -r "api_key\|apikey\|api-key" --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" .

# البحث عن كلمات المرور
grep -r "password\|passwd\|pwd" --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" .

# البحث عن توكنات
grep -r "token\|secret\|jwt" --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" .

# البحث عن ملفات .env
find . -name "*.env" -not -name "*.example" -not -path "./.git/*"

# فحص ما إذا كانت الملفات مُتتبعة في Git
git ls-files | grep -E "\.env|secret|key"
```

### فحص تاريخ Git

```bash
# البحث في تاريخ Git عن كلمات حساسة
git log --all --full-history --source -- '*secret*' '*password*' '*key*' '*.env'

# عرض محتوى ملف في commit معين
git show <commit-hash>:.env

# البحث في جميع commits
git log -p -S "OPENROUTER_API_KEY"
```

### التحقق من .gitignore

```bash
# التحقق من أن ملف معين سيتم تجاهله
git check-ignore -v .env

# عرض جميع الملفات المتجاهلة
git status --ignored
```

</div>

---

## 🔧 Useful Commands for Scanning

### Scan for Sensitive Files

```bash
# Search for API keys
grep -r "api_key\|apikey\|api-key" --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" .

# Search for passwords
grep -r "password\|passwd\|pwd" --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" .

# Search for tokens
grep -r "token\|secret\|jwt" --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" .

# Find .env files
find . -name "*.env" -not -name "*.example" -not -path "./.git/*"

# Check if files are tracked in Git
git ls-files | grep -E "\.env|secret|key"
```

### Scan Git History

```bash
# Search Git history for sensitive words
git log --all --full-history --source -- '*secret*' '*password*' '*key*' '*.env'

# Show file content in specific commit
git show <commit-hash>:.env

# Search in all commits
git log -p -S "OPENROUTER_API_KEY"
```

### Verify .gitignore

```bash
# Check if a specific file will be ignored
git check-ignore -v .env

# Show all ignored files
git status --ignored
```

---

<div dir="rtl">

## 🎯 الخطوات الموصى بها

### 1. قبل إزالة الملفات الحساسة

```bash
# إنشاء نسخة احتياطية محلية
cp .env .env.backup.local
cp .env.openwebui .env.openwebui.backup.local

# حفظ القيم في مكان آمن (مدير كلمات المرور)
# ثم نقلها إلى GitHub Secrets
```

### 2. إزالة الملفات من التتبع

```bash
# إزالة من التتبع
git rm --cached .env
git rm --cached .env.openwebui

# إنشاء commit
git commit -m "🔒 Remove sensitive .env files from Git tracking

- Removed .env from version control
- Removed .env.openwebui from version control
- These files are already in .gitignore
- Sensitive data should be stored in GitHub Secrets"

# دفع التغييرات
git push
```

### 3. تنظيف التاريخ (اختياري لكن موصى به)

```bash
# استخدام git-filter-repo
pip install git-filter-repo
git filter-repo --path .env --invert-paths
git filter-repo --path .env.openwebui --invert-paths

# أو استخدام BFG
java -jar bfg.jar --delete-files .env
java -jar bfg.jar --delete-files .env.openwebui
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### 4. إعداد GitHub Secrets

1. اذهب إلى Settings > Secrets and variables > Actions
2. أضف جميع المفاتيح الموجودة في .env
3. حدّث workflows لاستخدام Secrets

### 5. جعل المستودع عام

بعد إكمال جميع الخطوات أعلاه:
1. Settings > Danger Zone > Change visibility
2. Make public
3. تأكيد الإجراء

</div>

---

## 🎯 Recommended Steps

### 1. Before Removing Sensitive Files

```bash
# Create local backup
cp .env .env.backup.local
cp .env.openwebui .env.openwebui.backup.local

# Save values in a secure place (password manager)
# Then move them to GitHub Secrets
```

### 2. Remove Files from Tracking

```bash
# Remove from tracking
git rm --cached .env
git rm --cached .env.openwebui

# Create commit
git commit -m "🔒 Remove sensitive .env files from Git tracking

- Removed .env from version control
- Removed .env.openwebui from version control
- These files are already in .gitignore
- Sensitive data should be stored in GitHub Secrets"

# Push changes
git push
```

### 3. Clean History (Optional but Recommended)

```bash
# Using git-filter-repo
pip install git-filter-repo
git filter-repo --path .env --invert-paths
git filter-repo --path .env.openwebui --invert-paths

# Or using BFG
java -jar bfg.jar --delete-files .env
java -jar bfg.jar --delete-files .env.openwebui
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### 4. Setup GitHub Secrets

1. Go to Settings > Secrets and variables > Actions
2. Add all keys from .env
3. Update workflows to use Secrets

### 5. Make Repository Public

After completing all steps above:
1. Settings > Danger Zone > Change visibility
2. Make public
3. Confirm action

---

## ⚠️ Important Warnings | تحذيرات مهمة

<div dir="rtl">

### عند إزالة الملفات من تاريخ Git:

1. **Force Push مطلوب**: ستحتاج لعمل force push، وهذا سيؤثر على جميع المتعاونين
2. **النسخ الاحتياطية**: أنشئ نسخة احتياطية كاملة قبل البدء
3. **إعادة Clone**: قد يحتاج المتعاونون لإعادة clone المستودع
4. **Forks**: الـ forks الموجودة قد تحتفظ بالبيانات الحساسة

### بعد جعل المستودع عام:

1. **لا يمكن التراجع عن نشر البيانات**: أي بيانات حساسة تم نشرها تعتبر مكشوفة للأبد
2. **تغيير المفاتيح**: غيّر جميع API keys والـ tokens التي كانت موجودة في الملفات
3. **المراقبة**: راقب المستودع لأي نشاط غير عادي
4. **GitHub Secret Scanning**: سيُفعّل تلقائياً وقد يكتشف مفاتيح مكشوفة

</div>

### When Removing Files from Git History:

1. **Force Push Required**: You'll need to force push, affecting all collaborators
2. **Backups**: Create a complete backup before starting
3. **Re-clone**: Collaborators may need to re-clone the repository
4. **Forks**: Existing forks may retain sensitive data

### After Making Repository Public:

1. **Can't Undo Data Publication**: Any published sensitive data is considered exposed forever
2. **Rotate Keys**: Change all API keys and tokens that were in the files
3. **Monitor**: Watch repository for unusual activity
4. **GitHub Secret Scanning**: Will automatically enable and may detect exposed keys

---

<div align="center">

**🔒 الأمان أولاً | Security First 🔒**

**لا تتسرع في جعل المستودع عام قبل إكمال جميع خطوات الأمان**

**Don't rush to make the repository public before completing all security steps**

</div>
