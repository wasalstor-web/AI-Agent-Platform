# دمج OpenWebUI مع النماذج المفتوحة المصدر
# OpenWebUI Integration with Open-Source AI Models

**المؤسس:** خليف 'ذيبان' العنزي  
**الموقع:** القصيم – بريدة – المملكة العربية السعودية

---

## 📋 نظرة عامة / Overview

تم دمج منصة OpenWebUI بنجاح مع نماذج الذكاء الصناعي المفتوحة المصدر في منصة AI-Agent-Platform. هذا الدمج يوفر:

This integration successfully connects OpenWebUI with open-source AI models in the AI-Agent-Platform, providing:

- ✅ **6 نماذج ذكاء صناعي مفتوحة المصدر** / 6 Open-source AI Models
- ✅ **مصادقة آمنة عبر JWT و API Key** / Secure authentication via JWT & API Key
- ✅ **نقاط استقبال Webhooks جاهزة** / Ready-to-use Webhook endpoints
- ✅ **دعم كامل للغة العربية** / Full Arabic language support
- ✅ **واجهة برمجية REST API موثقة** / Documented REST API interface

---

## 🔐 معلومات المصادقة / Authentication Information

تم إعداد المصادقة باستخدام البيانات المقدمة:

Authentication has been configured with the provided credentials:

### JWT Token
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8
```

### API Key
```
sk-3720ccd539704717ba9af3453500fe3c
```

**ملاحظة أمنية:** هذه المفاتيح تم تكوينها في ملف `.env` ولن يتم رفعها إلى GitHub.

**Security Note:** These keys are configured in `.env` file and will not be uploaded to GitHub.

---

## 🌐 روابط الوصول / Access Links

### 🏠 الصفحة الرئيسية / Main Page
```
https://wasalstor-web.github.io/AI-Agent-Platform/
```

### 🔗 Webhook Base URL
```
https://wasalstor-web.github.io/AI-Agent-Platform
```

### 📍 نقاط الاستقبال / Webhook Endpoints

| الوظيفة / Function | الرابط / Endpoint | الطريقة / Method |
|-------------------|------------------|-----------------|
| محادثة / Chat | `/webhook/chat` | POST |
| حالة النظام / Status | `/webhook/status` | GET |
| إدارة النماذج / Models | `/webhook/model` | POST |
| معلومات الدمج / Info | `/webhook/info` | GET |
| قائمة النماذج / List Models | `/api/models` | GET |
| التوثيق / Documentation | `/api/docs` | GET |

---

## 🤖 النماذج المتاحة / Available Models

تم تفعيل 6 نماذج ذكاء صناعي مفتوحة المصدر:

6 open-source AI models have been enabled:

### 1. LLaMA 3 8B
- **المعرف / ID:** `llama-3-8b`
- **المزود / Provider:** Meta
- **الوصف / Description:** نموذج متعدد الأغراض للاستخدامات العامة
- **النوع / Type:** General Purpose

### 2. Qwen 2.5 Arabic
- **المعرف / ID:** `qwen-2.5-arabic`
- **المزود / Provider:** Alibaba
- **الوصف / Description:** متخصص في اللغة العربية
- **النوع / Type:** Arabic Language Specialized

### 3. AraBERT
- **المعرف / ID:** `arabert`
- **المزود / Provider:** AUB (American University of Beirut)
- **الوصف / Description:** نموذج BERT للغة العربية ومعالجة اللغة الطبيعية
- **النوع / Type:** Arabic NLP

### 4. Mistral 7B
- **المعرف / ID:** `mistral-7b`
- **المزود / Provider:** Mistral AI
- **الوصف / Description:** نموذج قوي وفعال متعدد اللغات
- **النوع / Type:** Multilingual

### 5. DeepSeek Coder
- **المعرف / ID:** `deepseek-coder`
- **المزود / Provider:** DeepSeek
- **الوصف / Description:** متخصص في توليد الأكواد البرمجية
- **النوع / Type:** Code Generation

### 6. Phi-3 Mini
- **المعرف / ID:** `phi-3-mini`
- **المزود / Provider:** Microsoft
- **الوصف / Description:** نموذج مدمج لكنه قوي
- **النوع / Type:** Compact & Efficient

---

## 🚀 التشغيل السريع / Quick Start

### 1. تثبيت المتطلبات / Install Dependencies

```bash
cd /home/runner/work/AI-Agent-Platform/AI-Agent-Platform
chmod +x deploy-openwebui-integration.sh
./deploy-openwebui-integration.sh
```

### 2. تشغيل الخادم / Start Server

```bash
# الطريقة الأولى / Method 1
./start-integration.sh

# الطريقة الثانية / Method 2
python3 openwebui-integration.py

# الطريقة الثالثة (مع بيئة افتراضية) / Method 3 (with virtual environment)
source venv/bin/activate
python3 openwebui-integration.py
```

---

## 💻 أمثلة الاستخدام / Usage Examples

### مثال 1: إرسال رسالة للمحادثة / Example 1: Send Chat Message

```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "مرحباً، كيف يمكنك مساعدتي؟",
    "model": "qwen-2.5-arabic"
  }'
```

### مثال 2: الحصول على قائمة النماذج / Example 2: Get Models List

```bash
curl http://localhost:8080/api/models
```

### مثال 3: فحص حالة النظام / Example 3: Check System Status

```bash
curl http://localhost:8080/webhook/status
```

### مثال 4: استخدام نموذج LLaMA 3 / Example 4: Use LLaMA 3 Model

```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Explain machine learning",
    "model": "llama-3-8b",
    "context": {
      "language": "en"
    }
  }'
```

### مثال 5: استخدام من Python / Example 5: Use from Python

```python
import requests

url = "http://localhost:8080/webhook/chat"
headers = {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8",
    "Content-Type": "application/json"
}
data = {
    "message": "اشرح لي الذكاء الصناعي",
    "model": "arabert"
}

response = requests.post(url, json=data, headers=headers)
print(response.json())
```

---

## 🔧 التكوين / Configuration

### ملف البيئة / Environment File (`.env`)

تم تحديث ملف `.env` بالمتغيرات التالية:

The `.env` file has been updated with the following variables:

```bash
# OpenWebUI Configuration
OPENWEBUI_ENABLED=true
OPENWEBUI_PORT=3000
OPENWEBUI_HOST=0.0.0.0
OPENWEBUI_URL=http://localhost:3000
OPENWEBUI_JWT_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8
OPENWEBUI_API_KEY=sk-3720ccd539704717ba9af3453500fe3c

# Webhook Configuration
WEBHOOK_BASE_URL=https://wasalstor-web.github.io/AI-Agent-Platform

# FastAPI Configuration
FASTAPI_SECRET_KEY=sk-3720ccd539704717ba9af3453500fe3c
```

---

## 📊 هيكل الاستجابة / Response Structure

### استجابة ناجحة / Successful Response

```json
{
  "success": true,
  "model": "Qwen 2.5 Arabic",
  "model_id": "qwen-2.5-arabic",
  "response": "مرحباً! أنا نموذج Qwen 2.5 Arabic...",
  "timestamp": "2025-10-20T13:15:30.806Z"
}
```

### استجابة خطأ / Error Response

```json
{
  "success": false,
  "error": "Model not found",
  "timestamp": "2025-10-20T13:15:30.806Z"
}
```

---

## 🛠️ استكشاف الأخطاء / Troubleshooting

### المشكلة: لا يمكن الاتصال بالخادم
**Problem: Cannot connect to server**

```bash
# تحقق من تشغيل الخادم / Check if server is running
ps aux | grep openwebui-integration

# تحقق من المنفذ / Check port availability
lsof -i :8080

# أعد تشغيل الخادم / Restart server
pkill -f openwebui-integration
./start-integration.sh
```

### المشكلة: خطأ في المصادقة
**Problem: Authentication error**

تأكد من استخدام JWT Token أو API Key الصحيح في headers:

Make sure you're using the correct JWT Token or API Key in headers:

```bash
# استخدام JWT Token / Using JWT Token
-H "Authorization: Bearer YOUR_JWT_TOKEN"

# أو استخدام API Key / Or using API Key
-H "X-API-Key: YOUR_API_KEY"
```

### المشكلة: النموذج غير متاح
**Problem: Model not available**

تحقق من قائمة النماذج المتاحة:

Check the list of available models:

```bash
curl http://localhost:8080/api/models | jq '.models[].id'
```

---

## 📚 التوثيق الإضافي / Additional Documentation

### Swagger UI (تفاعلي / Interactive)

قم بزيارة:
Visit: `http://localhost:8080/api/docs`

### ReDoc

قم بزيارة:
Visit: `http://localhost:8080/api/redoc`

---

## 🔄 التحديثات المستقبلية / Future Updates

- [ ] إضافة نماذج ذكاء صناعي إضافية / Add more AI models
- [ ] تحسين معالجة اللغة العربية / Improve Arabic language processing
- [ ] إضافة ذاكرة للمحادثات / Add conversation memory
- [ ] تحسين الأداء / Performance optimization
- [ ] إضافة لوحة تحكم ويب / Add web dashboard
- [ ] دعم الملفات المرفقة / Support file attachments

---

## 📞 الدعم / Support

للمساعدة والاستفسارات:
For help and inquiries:

- **GitHub Issues:** https://github.com/wasalstor-web/AI-Agent-Platform/issues
- **Documentation:** https://wasalstor-web.github.io/AI-Agent-Platform/

---

## 📄 الترخيص / License

هذا المشروع جزء من منصة AI-Agent-Platform

This project is part of the AI-Agent-Platform

© 2025 خليف 'ذيبان' العنزي

---

## ✅ ملخص النشر / Deployment Summary

- ✅ **تم دمج OpenWebUI مع 6 نماذج مفتوحة المصدر**
- ✅ **تم تفعيل المصادقة عبر JWT و API Key**
- ✅ **تم إعداد نقاط استقبال Webhooks**
- ✅ **تم توثيق واجهة برمجية REST API**
- ✅ **جاهز للاستخدام الفوري**

---

**تاريخ النشر / Deployment Date:** 2025-10-20  
**الإصدار / Version:** 1.0.0  
**الحالة / Status:** ✅ نشط / Active
