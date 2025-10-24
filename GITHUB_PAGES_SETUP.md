# GitHub Pages Setup Guide / دليل إعداد صفحات GitHub

## المشكلة / The Problem

تحصل على خطأ 404 عند محاولة الوصول إلى موقع GitHub Pages.  
You're getting a 404 error when trying to access the GitHub Pages site.

**السبب / Reason:** صفحات GitHub غير مفعلة في إعدادات المستودع  
**Cause:** GitHub Pages is not enabled in the repository settings

## الحل السريع / Quick Solution

### الخطوة 1: تفعيل GitHub Pages / Step 1: Enable GitHub Pages

1. اذهب إلى إعدادات المستودع / Go to repository settings:
   ```
   https://github.com/wasalstor-web/AI-Agent-Platform/settings/pages
   ```

2. في قسم "Source" / Under "Source" section:
   - اختر "GitHub Actions" / Select "GitHub Actions"
   - أو اختر "Deploy from a branch" واختر "main" و "/" / Or select "Deploy from a branch" and choose "main" and "/"

3. احفظ التغييرات / Save changes

4. انتظر بضع دقائق حتى يتم النشر / Wait a few minutes for deployment

5. سيكون موقعك متاحًا على / Your site will be available at:
   ```
   https://wasalstor-web.github.io/AI-Agent-Platform/
   ```

### الخطوة 2: التحقق من النشر / Step 2: Verify Deployment

بعد تفعيل GitHub Pages، سيتم تشغيل workflow تلقائيًا:
After enabling GitHub Pages, the workflow will run automatically:

```bash
# راقب حالة النشر / Monitor deployment status
https://github.com/wasalstor-web/AI-Agent-Platform/actions
```

## طرق بديلة للنشر / Alternative Deployment Methods

إذا كنت تريد نشر الموقع بسرعة دون انتظار GitHub Pages:
If you want to deploy the site quickly without waiting for GitHub Pages:

### الخيار 1: Vercel (مجاني وسريع / Free and Fast)

```bash
# تثبيت Vercel CLI / Install Vercel CLI
npm i -g vercel

# نشر المشروع / Deploy the project
cd /home/runner/work/AI-Agent-Platform/AI-Agent-Platform
vercel --prod

# سيتم إنشاء رابط مؤقت مثل:
# A temporary URL will be created like:
# https://ai-agent-platform-xyz.vercel.app
```

### الخيار 2: Netlify (مجاني وسريع / Free and Fast)

```bash
# تثبيت Netlify CLI / Install Netlify CLI
npm i -g netlify-cli

# نشر المشروع / Deploy the project
cd /home/runner/work/AI-Agent-Platform/AI-Agent-Platform
netlify deploy --prod

# سيتم إنشاء رابط مؤقت مثل:
# A temporary URL will be created like:
# https://ai-agent-platform-xyz.netlify.app
```

### الخيار 3: Surge.sh (بسيط جداً / Very Simple)

```bash
# تثبيت Surge / Install Surge
npm i -g surge

# نشر المشروع / Deploy the project
cd /home/runner/work/AI-Agent-Platform/AI-Agent-Platform
surge . ai-agent-platform.surge.sh

# سيتم نشر الموقع على:
# The site will be published at:
# https://ai-agent-platform.surge.sh
```

### الخيار 4: Python HTTP Server (للتجربة المحلية / For Local Testing)

```bash
# تشغيل خادم محلي / Run local server
cd /home/runner/work/AI-Agent-Platform/AI-Agent-Platform
python3 -m http.server 8000

# افتح المتصفح على / Open browser at:
# http://localhost:8000
```

### الخيار 5: نشر على VPS الخاص بك / Deploy on Your VPS

إذا كان لديك VPS، يمكنك نشر الموقع عليه:
If you have a VPS, you can deploy the site on it:

```bash
# 1. اتصل بـ VPS / Connect to VPS
ssh user@your-vps.com

# 2. استنسخ المستودع / Clone the repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# 3. أ. استخدم Nginx / Option A: Use Nginx
sudo cp index.html /var/www/html/
# الموقع سيكون متاح على / Site will be available at:
# http://your-vps.com

# 3. ب. استخدم خادم Python / Option B: Use Python server
python3 -m http.server 80
# الموقع سيكون متاح على / Site will be available at:
# http://your-vps.com
```

## استكشاف الأخطاء / Troubleshooting

### المشكلة: لا يزال 404 بعد تفعيل GitHub Pages
### Problem: Still getting 404 after enabling GitHub Pages

**الحل / Solution:**

1. تأكد من وجود ملف `index.html` في الجذر / Ensure `index.html` exists in root
   ```bash
   ls -la index.html
   ```

2. تأكد من نجاح workflow / Verify workflow succeeded
   ```
   https://github.com/wasalstor-web/AI-Agent-Platform/actions
   ```

3. امسح ذاكرة التخزين المؤقت / Clear browser cache
   - اضغط Ctrl+Shift+R / Press Ctrl+Shift+R
   - أو افتح في وضع التخفي / Or open in incognito mode

4. انتظر حتى 10 دقائق / Wait up to 10 minutes
   - قد يستغرق النشر بعض الوقت / Deployment may take some time

### المشكلة: Workflow يفشل مع "Not Found"
### Problem: Workflow fails with "Not Found"

**الحل / Solution:**

هذا يعني أن GitHub Pages غير مفعل. اتبع الخطوة 1 أعلاه.
This means GitHub Pages is not enabled. Follow Step 1 above.

## الملفات المهمة / Important Files

- ✅ `index.html` - الصفحة الرئيسية / Main page
- ✅ `.nojekyll` - تعطيل Jekyll / Disable Jekyll
- ✅ `.github/workflows/deploy-pages.yml` - سير عمل النشر / Deployment workflow

## معلومات إضافية / Additional Information

### لماذا تحتاج إلى تفعيل GitHub Pages يدوياً؟
### Why do you need to enable GitHub Pages manually?

لأسباب أمنية، لا يمكن تفعيل GitHub Pages برمجياً. يجب تفعيله يدوياً من إعدادات المستودع.
For security reasons, GitHub Pages cannot be enabled programmatically. It must be enabled manually from repository settings.

### كيف تعمل GitHub Pages؟
### How does GitHub Pages work?

1. تفعيل Pages في الإعدادات / Enable Pages in settings
2. اختيار المصدر (Actions أو branch) / Choose source (Actions or branch)
3. GitHub ينشر الملفات تلقائياً / GitHub publishes files automatically
4. الموقع يصبح متاحاً على `username.github.io/repo` / Site becomes available at `username.github.io/repo`

## الدعم / Support

إذا واجهت أي مشاكل:
If you encounter any issues:

1. تحقق من workflow logs:
   ```
   https://github.com/wasalstor-web/AI-Agent-Platform/actions
   ```

2. راجع التوثيق الرسمي / Review official documentation:
   - [GitHub Pages Documentation](https://docs.github.com/en/pages)
   - [GitHub Actions Documentation](https://docs.github.com/en/actions)

3. افتح issue في المستودع / Open an issue in the repository:
   ```
   https://github.com/wasalstor-web/AI-Agent-Platform/issues
   ```

---

**AI-Agent-Platform** © 2025

✨ **نصيحة:** استخدم Vercel أو Netlify للحصول على رابط مؤقت فوري!  
✨ **Tip:** Use Vercel or Netlify to get an instant temporary link!
