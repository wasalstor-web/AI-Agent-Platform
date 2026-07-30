# 🚀 دليل سريع: جعل المستودع عام
# Quick Guide: Making the Repository Public

<div dir="rtl" align="center">

# ⚡ دليل سريع - خطوات جعل المستودع عام

</div>

---

<div dir="rtl">

## 📝 ملخص تنفيذي

أنت طلبت جعل مستودع AI-Agent-Platform عام. هذا الدليل السريع يوضح الخطوات الضرورية.

## ⚠️ تحذير مهم جداً

**المستودع يحتوي حالياً على ملفات حساسة مُتتبعة في Git:**
- `.env` - يحتوي على مفاتيح API و توكنات JWT
- `.env.openwebui` - يحتوي على إعدادات حساسة

**يجب إزالتها قبل جعل المستودع عام!**

---

## 🔐 الخطوات الضرورية (5 دقائق)

### 1️⃣ تشغيل سكريبت الأمان

```bash
cd AI-Agent-Platform
./security-cleanup.sh
```

هذا السكريبت سيقوم بـ:
- إنشاء نسخ احتياطية من الملفات الحساسة
- إزالة الملفات من تتبع Git
- فحص الكود بحثاً عن مفاتيح API
- إعطاءك تقرير أمني كامل

### 2️⃣ حفظ البيانات الحساسة

قبل الاستمرار، احفظ هذه القيم من ملف `.env`:
```
FASTAPI_SECRET_KEY=sk-3720ccd539704717ba9af3453500fe3c
OPENWEBUI_JWT_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
OPENWEBUI_API_KEY=sk-3720ccd539704717ba9af3453500fe3c
```

**احفظها في:**
- مدير كلمات المرور الخاص بك
- أو في GitHub Secrets (الخطوة التالية)

### 3️⃣ إضافة Secrets في GitHub

1. اذهب إلى: `https://github.com/wasalstor-web/AI-Agent-Platform/settings/secrets/actions`
2. انقر **New repository secret**
3. أضف هذه الأسرار:

| الاسم | القيمة |
|------|--------|
| `OPENROUTER_API_KEY` | مفتاح OpenRouter الخاص بك |
| `FASTAPI_SECRET_KEY` | القيمة من .env |
| `OPENWEBUI_JWT_TOKEN` | القيمة من .env |
| `OPENWEBUI_API_KEY` | القيمة من .env |
| `VPS_HOST` | إذا كان لديك VPS |
| `VPS_USER` | إذا كان لديك VPS |
| `VPS_KEY` | إذا كان لديك VPS |

### 4️⃣ دفع التغييرات

```bash
git push
```

### 5️⃣ جعل المستودع عام

1. اذهب إلى: `https://github.com/wasalstor-web/AI-Agent-Platform/settings`
2. مرر للأسفل حتى **Danger Zone**
3. انقر **Change repository visibility**
4. اختر **Make public**
5. اكتب اسم المستودع: `wasalstor-web/AI-Agent-Platform`
6. انقر **I understand, make this repository public**

**✅ تم! المستودع الآن عام**

---

## 📚 وثائق مفصلة

إذا كنت تريد معلومات أكثر تفصيلاً، راجع:

### 1. **دليل جعل المستودع عام** 📖
[MAKE_REPOSITORY_PUBLIC_GUIDE.md](MAKE_REPOSITORY_PUBLIC_GUIDE.md)
- شرح كامل خطوة بخطوة
- طرق متعددة (واجهة الويب، CLI)
- نصائح وأفضل الممارسات

### 2. **قائمة التحقق الأمني** 🔒
[SECURITY_CHECKLIST_BEFORE_PUBLIC.md](SECURITY_CHECKLIST_BEFORE_PUBLIC.md)
- قائمة تحقق شاملة
- كيفية إزالة الملفات الحساسة من تاريخ Git
- طرق متقدمة للتنظيف الأمني

### 3. **سكريبت الأمان** 🛠️
[security-cleanup.sh](security-cleanup.sh)
- فحص تلقائي للأمان
- إزالة الملفات الحساسة
- تقرير أمني شامل

---

## ❓ أسئلة شائعة

### س: هل يمكنني التراجع بعد جعل المستودع عام؟
**ج:** نعم، يمكنك تغييره مرة أخرى إلى خاص في أي وقت من Settings > Danger Zone

### س: ماذا عن البيانات التي كانت في التاريخ؟
**ج:** إذا أردت حذفها من التاريخ، استخدم `git-filter-repo` كما هو موضح في SECURITY_CHECKLIST_BEFORE_PUBLIC.md

### س: هل سيؤثر هذا على GitHub Actions؟
**ج:** لا، طالما أضفت جميع الأسرار إلى GitHub Secrets، ستعمل Workflows بشكل طبيعي

### س: متى يجب أن أغير المفاتيح؟
**ج:** فوراً بعد جعل المستودع عام، غيّر جميع API keys و tokens التي كانت في الملفات

---

## 🎯 ملخص الأوامر

```bash
# 1. تشغيل فحص الأمان
./security-cleanup.sh

# 2. إزالة الملفات من Git (إذا لم يفعلها السكريبت)
git rm --cached .env
git rm --cached .env.openwebui
git commit -m "Remove sensitive files from tracking"
git push

# 3. (اختياري) تنظيف التاريخ
pip install git-filter-repo
git filter-repo --path .env --invert-paths
git filter-repo --path .env.openwebui --invert-paths
git push --force --all

# 4. التحقق
git status
git ls-files | grep .env
```

---

## 📞 بحاجة لمساعدة؟

إذا واجهت أي مشاكل:

1. **راجع الوثائق المفصلة** في الملفات أعلاه
2. **افتح Issue** في المستودع
3. **راجع GitHub Docs**: [Setting repository visibility](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility)

---

## ⏱️ الوقت المتوقع

- **الطريقة السريعة** (بدون تنظيف التاريخ): 5-10 دقائق
- **الطريقة الكاملة** (مع تنظيف التاريخ): 15-20 دقيقة

---

## ✅ جاهز للبدء؟

ابدأ بتشغيل سكريبت الأمان:

```bash
./security-cleanup.sh
```

ثم اتبع التعليمات التي سيعرضها السكريبت.

---

</div>

<div align="center">

**🔒 الأمان أولاً | Security First 🔒**

**لا تتسرع - خذ وقتك لضمان حماية بياناتك**

**Don't rush - take your time to ensure your data is protected**

</div>

---

<div dir="ltr">

## Quick Steps Summary (English)

### Prerequisites (5 minutes)

1. **Run security cleanup**:
   ```bash
   ./security-cleanup.sh
   ```

2. **Save sensitive values** from `.env` to GitHub Secrets

3. **Add Secrets** at Settings > Secrets and variables > Actions:
   - OPENROUTER_API_KEY
   - FASTAPI_SECRET_KEY
   - OPENWEBUI_JWT_TOKEN
   - OPENWEBUI_API_KEY

4. **Push changes**:
   ```bash
   git push
   ```

5. **Make repository public**:
   - Go to Settings > Danger Zone
   - Click "Change repository visibility"
   - Select "Make public"
   - Confirm by typing repository name

### Detailed Documentation

- 📖 [Complete Guide](MAKE_REPOSITORY_PUBLIC_GUIDE.md)
- 🔒 [Security Checklist](SECURITY_CHECKLIST_BEFORE_PUBLIC.md)
- 🛠️ [Security Script](security-cleanup.sh)

</div>
