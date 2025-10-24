# تشغيل منصة وكيل الذكاء الاصطناعي محلياً
# Running AI Agent Platform Locally

## نظرة عامة | Overview

هذا الدليل يوضح كيفية تشغيل منصة وكيل الذكاء الاصطناعي على جهازك المحلي.

This guide explains how to run the AI Agent Platform on your local machine.

---

## المتطلبات | Prerequisites

### المتطلبات الأساسية | Basic Requirements

- **Python 3.9+** - يجب أن يكون Python 3.9 أو أعلى مثبتاً على جهازك
- **pip** - مدير حزم Python
- **Git** - (اختياري) لاستنساخ المستودع

### المتطلبات الإضافية | Additional Requirements

- متصفح ويب حديث (Chrome, Firefox, Safari, Edge)
- اتصال بالإنترنت لتحميل المكتبات

---

## خطوات التشغيل | Installation Steps

### الطريقة الأولى: التشغيل التلقائي | Method 1: Automatic Startup

#### 1. استنساخ المستودع | Clone the Repository

```bash
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
```

أو تحميل الملف المضغوط:
```bash
wget https://github.com/wasalstor-web/ai-agent-platform/archive/refs/heads/main.zip
unzip main.zip
cd AI-Agent-Platform-main
```

#### 2. تشغيل السكريبت | Run the Startup Script

```bash
./start-local.sh
```

هذا السكريبت سيقوم بـ:
- إنشاء بيئة افتراضية Python
- تثبيت جميع المتطلبات
- تشغيل خادم API (Flask)
- تشغيل خادم واجهة الويب
- عرض روابط الوصول

This script will:
- Create a Python virtual environment
- Install all requirements
- Start the API server (Flask)
- Start the web interface server
- Display access URLs

#### 3. الوصول للمنصة | Access the Platform

بعد التشغيل الناجح، افتح متصفحك وانتقل إلى:

After successful startup, open your browser and navigate to:

**الصفحة الرئيسية | Home Page:**
```
http://localhost:8080
```

**صفحة الإجراءات | Actions Page:**
```
http://localhost:8080/actions.html
```

**API Documentation:**
```
http://localhost:5000/api/health
```

---

### الطريقة الثانية: التشغيل اليدوي | Method 2: Manual Startup

#### 1. إنشاء بيئة افتراضية | Create Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate  # على Linux/Mac
# أو على Windows:
# venv\Scripts\activate
```

#### 2. تثبيت المتطلبات | Install Requirements

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

#### 3. تشغيل خادم API | Start API Server

في نافذة طرفية جديدة:
```bash
cd api
python3 server.py
```

#### 4. تشغيل خادم الويب | Start Web Server

في نافذة طرفية أخرى:
```bash
python3 -m http.server 8080
```

#### 5. الوصول للمنصة | Access the Platform

افتح متصفحك على:
```
http://localhost:8080
```

---

## الصفحات المتاحة | Available Pages

### 1. الصفحة الرئيسية | Home Page
**الرابط | URL:** `http://localhost:8080/index.html`

**الميزات | Features:**
- نظرة عامة على المشروع
- الميزات الرئيسية
- سير عمل النظام
- واجهة الدردشة التفاعلية
- تكامل OpenWebUI

### 2. صفحة الإجراءات | Actions Page
**الرابط | URL:** `http://localhost:8080/actions.html`

**الميزات | Features:**
- إحصائيات النظام المباشرة
- تنفيذ الإجراءات المختلفة:
  - البحث على الويب
  - توليد الأكواد
  - عمليات الملفات
  - تنفيذ الأوامر
  - معالجة اللغة العربية
  - تحليل البيانات
- لوحة تنفيذ مخصصة
- سجلات النشاط المباشرة

---

## نقاط نهاية API | API Endpoints

### Health Check
```bash
curl http://localhost:5000/api/health
```

### Get Status
```bash
curl http://localhost:5000/api/status
```

### Process Command
```bash
curl -X POST http://localhost:5000/api/process \
  -H "Content-Type: application/json" \
  -d '{
    "command": "مرحبا، كيف حالك؟",
    "context": {
      "model": "gpt-3.5-turbo",
      "language": "ar"
    }
  }'
```

### List Models
```bash
curl http://localhost:5000/api/models
```

---

## البيانات التجريبية | Demo Data

المنصة تعمل حالياً ببيانات تجريبية (Demo) لتوضيح الوظائف:

The platform currently works with demo data to demonstrate functionality:

- ✅ واجهة المستخدم التفاعلية | Interactive UI
- ✅ تبديل اللغة (عربي/إنجليزي) | Language switching (Arabic/English)
- ✅ عرض الإجراءات المختلفة | Display different actions
- ✅ إحصائيات مباشرة | Live statistics
- ✅ سجلات النشاط | Activity logs
- ⏳ تكامل AI حقيقي (يتطلب مفتاح API) | Real AI integration (requires API key)

---

## إيقاف الخوادم | Stopping the Servers

### إذا استخدمت السكريبت التلقائي:
اضغط `Ctrl+C` في نافذة الطرفية

### إذا استخدمت التشغيل اليدوي:
اضغط `Ctrl+C` في كل نافذة طرفية

---

## استكشاف الأخطاء | Troubleshooting

### المشكلة: Port already in use
**الحل:**
```bash
# تغيير المنفذ في ملف server.py
# أو إيقاف العملية التي تستخدم المنفذ:
lsof -ti:5000 | xargs kill -9
lsof -ti:8080 | xargs kill -9
```

### المشكلة: Module not found
**الحل:**
```bash
pip install -r requirements.txt --force-reinstall
```

### المشكلة: Permission denied
**الحل:**
```bash
chmod +x start-local.sh
```

---

## التطوير المتقدم | Advanced Development

### تشغيل مع DL+ System
```bash
cd dlplus
python3 main.py
```

### تشغيل الاختبارات | Run Tests
```bash
pytest tests/
```

### تشغيل مع Hot Reload
```bash
# FastAPI
uvicorn dlplus.main:app --reload

# Flask
FLASK_ENV=development python3 api/server.py
```

---

## الموارد الإضافية | Additional Resources

- **التوثيق الكامل:** [README.md](README.md)
- **دليل DL+:** [DLPLUS_README.md](DLPLUS_README.md)
- **دليل النشر:** [QUICK_DEPLOY_GUIDE.md](QUICK_DEPLOY_GUIDE.md)
- **المستودع على GitHub:** [https://github.com/wasalstor-web/AI-Agent-Platform](https://github.com/wasalstor-web/AI-Agent-Platform)

---

## الدعم | Support

للأسئلة والمساعدة:
- افتح Issue على GitHub
- راجع الوثائق في مجلد `docs/`

For questions and support:
- Open an issue on GitHub
- Review documentation in `docs/` folder

---

## الترخيص | License

AI-Agent-Platform © 2025

---

**صُنع بـ ❤️ للمجتمع العربي والعالمي**

**Made with ❤️ for the Arabic and Global Community**
