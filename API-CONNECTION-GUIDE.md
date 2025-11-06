# 🌐 دليل الاتصال بخادم API | API Connection Guide

> **دليل سريع للوصول لخادم API والواجهات والنماذج**
>
> **Quick guide for accessing API server, interfaces, and models**

---

## 🚀 البدء السريع | Quick Start

### الطريقة الأسهل | Easiest Way

```bash
# استخدم DEPLOY-NOW مع خيار --api
# Use DEPLOY-NOW with --api option
bash DEPLOY-NOW.sh --api
```

أو | Or:

```bash
# استخدم السكريبت المخصص مباشرة
# Use the dedicated script directly
bash connect-api-server.sh
```

---

## 📋 ماذا يوفر؟ | What Does It Provide?

### 1. الوصول للواجهات | Access to Interfaces

يوفر الوصول لـ | Provides access to:

- **الواجهة الرئيسية** | Main Interface (`index.html`)
- **عرض OpenWebUI** | OpenWebUI Demo (`openwebui-demo.html`)
- **لوحة التحكم** | Dashboard Template (`openwebui-dashboard-template.html`)

### 2. عرض النماذج | View Models

يعرض جميع النماذج المتاحة | Shows all available models:

- ✅ GPT-3.5 Turbo (OpenAI)
- ✅ GPT-4 (OpenAI)
- ✅ Claude 3 (Anthropic)
- ✅ LLaMA 3 (Meta)
- ✅ Qwen Arabic (Alibaba)
- ✅ AraBERT (AUB)
- ✅ Mistral (Mistral AI)
- ✅ DeepSeek Coder (DeepSeek)

### 3. اختبار API | Test API

يتيح لك اختبار الـ API مباشرة | Allows you to test the API directly:

- إرسال طلبات بالعربية | Send Arabic requests
- إرسال طلبات بالإنجليزية | Send English requests
- اختبار النماذج المختلفة | Test different models

---

## 🎯 خيارات الاستخدام | Usage Options

### الخيار 1: من خلال DEPLOY-NOW.sh

```bash
# تشغيل تفاعلي | Interactive mode
bash DEPLOY-NOW.sh

# ثم اختر | Then choose:
# 4) خادم API والواجهات | API Server & Interfaces
```

أو مباشرة | Or directly:

```bash
bash DEPLOY-NOW.sh --api
```

### الخيار 2: السكريبت المخصص

```bash
# الاتصال بخادم محلي | Connect to local server
bash connect-api-server.sh

# الاتصال بخادم بعيد | Connect to remote server
bash connect-api-server.sh http://your-server:5000
```

---

## 📊 واجهة السكريبت | Script Interface

عند تشغيل السكريبت، ستحصل على قائمة تفاعلية | When running the script, you get an interactive menu:

```
🎯 قائمة الواجهات | Interface Menu

1) الوصول للواجهات    | Access Web Interfaces
   فتح الواجهات التفاعلية

2) عرض النماذج         | View Models
   عرض جميع النماذج المتاحة

3) اختبار API         | Test API
   إرسال طلب تجريبي

4) تشغيل خادم API     | Start API Server
   تشغيل خادم API محلياً

5) خروج                | Exit
```

---

## 🔧 تشغيل خادم API محلياً | Starting API Server Locally

### الطريقة 1: من خلال connect-api-server.sh

```bash
bash connect-api-server.sh
# اختر الخيار 4 | Choose option 4
```

### الطريقة 2: مباشرة

```bash
cd api
python3 server.py
```

سيعمل الخادم على | Server will run on:
```
http://0.0.0.0:5000
```

---

## 🌐 نقاط النهاية المتاحة | Available Endpoints

### 1. فحص الصحة | Health Check
```bash
GET http://localhost:5000/api/health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-11-06T04:00:00",
  "service": "AI Agent Platform API"
}
```

### 2. حالة API | API Status
```bash
GET http://localhost:5000/api/status
```

**Response:**
```json
{
  "status": "operational",
  "models": [...],
  "timestamp": "2025-11-06T04:00:00"
}
```

### 3. قائمة النماذج | List Models
```bash
GET http://localhost:5000/api/models
```

**Response:**
```json
{
  "models": [
    {
      "id": "gpt-3.5-turbo",
      "name": "GPT-3.5 Turbo",
      "provider": "OpenAI",
      "type": "general"
    },
    ...
  ]
}
```

### 4. معالجة الأوامر | Process Commands
```bash
POST http://localhost:5000/api/process
Content-Type: application/json

{
  "command": "مرحباً",
  "context": {
    "model": "qwen-arabic",
    "language": "ar"
  }
}
```

**Response:**
```json
{
  "success": true,
  "response": "مرحباً! أنا qwen-arabic وأنا هنا لمساعدتك...",
  "model": "qwen-arabic",
  "timestamp": "2025-11-06T04:00:00"
}
```

---

## 🔍 اختبار سريع | Quick Test

### اختبار الاتصال | Test Connection

```bash
curl http://localhost:5000/api/health
```

### اختبار بالعربية | Test in Arabic

```bash
curl -X POST http://localhost:5000/api/process \
  -H "Content-Type: application/json" \
  -d '{
    "command": "مرحباً",
    "context": {
      "model": "qwen-arabic",
      "language": "ar"
    }
  }'
```

### اختبار بالإنجليزية | Test in English

```bash
curl -X POST http://localhost:5000/api/process \
  -H "Content-Type: application/json" \
  -d '{
    "command": "Hello",
    "context": {
      "model": "gpt-3.5-turbo",
      "language": "en"
    }
  }'
```

---

## 🔒 الأمان | Security

### المتطلبات الأساسية | Basic Requirements

- ✅ الخادم يعمل على `0.0.0.0` لقبول الاتصالات الخارجية
- ✅ استخدم HTTPS في بيئة الإنتاج
- ✅ أضف مصادقة (Authentication) للإنتاج
- ✅ استخدم CORS بحذر

---

## ❓ حل المشاكل | Troubleshooting

### المشكلة: لا يمكن الاتصال بالخادم

```bash
# تحقق من أن الخادم يعمل | Check if server is running
curl http://localhost:5000/api/health

# تحقق من المنفذ | Check if port is open
netstat -tuln | grep 5000

# تحقق من الجدار الناري | Check firewall
sudo ufw status
```

### المشكلة: الخادم لا يبدأ

```bash
# تحقق من تثبيت المتطلبات | Check requirements installed
pip3 install -r requirements.txt

# تحقق من Python | Check Python version
python3 --version

# شغّل مع debug | Run with debug
cd api && python3 server.py
```

### المشكلة: الواجهات لا تفتح

```bash
# افتح يدوياً | Open manually
firefox index.html
# أو | or
google-chrome index.html
# أو | or
open index.html  # macOS
```

---

## 📚 المزيد من التوثيق | More Documentation

- 📖 [README.md](README.md) - الدليل الكامل
- 🚀 [START-HERE.md](START-HERE.md) - البدء السريع
- 🌐 [DEPLOYMENT.md](DEPLOYMENT.md) - دليل النشر
- 📋 [DOCUMENTATION-INDEX.md](DOCUMENTATION-INDEX.md) - فهرس شامل

---

## 💡 نصائح | Tips

### للمطورين | For Developers

- استخدم `--api` للتطوير السريع
- راقب السجلات في وحدة التحكم
- استخدم Postman أو curl لاختبار الـ API

### للمستخدمين | For Users

- استخدم الواجهات التفاعلية لسهولة الاستخدام
- جرب النماذج المختلفة لإيجاد الأفضل
- احفظ عنوان URL للخادم للوصول السريع

---

<div align="center">

**صُنع بـ ❤️ للمجتمع العربي والعالمي**

**Made with ❤️ for the Arabic and Global Community**

</div>
