# دليل الوصول السريع - OpenWebUI Integration Quick Access Guide

**المؤسس:** خليف 'ذيبان' العنزي  
**الموقع:** القصيم – بريدة – المملكة العربية السعودية  
**التاريخ:** 2025-10-20

---

## 🌐 الروابط الرئيسية / Main Links

### الصفحة الرئيسية / Main Page
```
https://wasalstor-web.github.io/AI-Agent-Platform/
```

### صفحة العرض التوضيحي / Demo Page
```
https://wasalstor-web.github.io/AI-Agent-Platform/openwebui-demo.html
```

### Webhook Base URL
```
https://wasalstor-web.github.io/AI-Agent-Platform
```

---

## 🔗 نقاط الاستقبال / Webhook Endpoints

### 1. إرسال رسالة / Send Message
**الرابط / URL:**
```
POST https://wasalstor-web.github.io/AI-Agent-Platform/webhook/chat
```

**مثال / Example:**
```bash
curl -X POST https://wasalstor-web.github.io/AI-Agent-Platform/webhook/chat \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{"message": "مرحباً", "model": "qwen-2.5-arabic"}'
```

### 2. حالة النظام / System Status
**الرابط / URL:**
```
GET https://wasalstor-web.github.io/AI-Agent-Platform/webhook/status
```

### 3. قائمة النماذج / Models List
**الرابط / URL:**
```
GET https://wasalstor-web.github.io/AI-Agent-Platform/api/models
```

### 4. معلومات الدمج / Integration Info
**الرابط / URL:**
```
GET https://wasalstor-web.github.io/AI-Agent-Platform/webhook/info
```

---

## 🔐 بيانات المصادقة / Authentication Credentials

### JWT Token
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8
```

استخدامه / Usage:
```bash
-H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### API Key
```
sk-3720ccd539704717ba9af3453500fe3c
```

استخدامه / Usage:
```bash
-H "X-API-Key: YOUR_API_KEY"
```

---

## 🤖 النماذج المتاحة / Available Models

| الاسم / Name | المعرف / ID | المزود / Provider |
|-------------|------------|------------------|
| LLaMA 3 8B | `llama-3-8b` | Meta |
| Qwen 2.5 Arabic | `qwen-2.5-arabic` | Alibaba |
| AraBERT | `arabert` | AUB |
| Mistral 7B | `mistral-7b` | Mistral AI |
| DeepSeek Coder | `deepseek-coder` | DeepSeek |
| Phi-3 Mini | `phi-3-mini` | Microsoft |

---

## 🚀 التشغيل المحلي / Local Deployment

### 1. النشر السريع / Quick Deploy
```bash
cd /path/to/AI-Agent-Platform
chmod +x deploy-openwebui-integration.sh
./deploy-openwebui-integration.sh
```

### 2. التشغيل المباشر / Direct Run
```bash
python3 openwebui-integration.py
```

### 3. مع البيئة الافتراضية / With Virtual Environment
```bash
source venv/bin/activate
python3 openwebui-integration.py
```

---

## 💻 أمثلة الاستخدام / Usage Examples

### مثال 1: رسالة عربية / Arabic Message
```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "message": "ما هو الذكاء الصناعي؟",
    "model": "qwen-2.5-arabic"
  }'
```

### مثال 2: رسالة إنجليزية / English Message
```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Explain machine learning",
    "model": "llama-3-8b"
  }'
```

### مثال 3: استخدام من Python / Python Usage
```python
import requests

url = "http://localhost:8080/webhook/chat"
headers = {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "Content-Type": "application/json"
}
data = {
    "message": "مرحباً",
    "model": "arabert"
}

response = requests.post(url, json=data, headers=headers)
print(response.json())
```

### مثال 4: استخدام من JavaScript / JavaScript Usage
```javascript
fetch('http://localhost:8080/webhook/chat', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    message: 'مرحباً',
    model: 'qwen-2.5-arabic'
  })
})
.then(response => response.json())
.then(data => console.log(data));
```

---

## 📊 هيكل الاستجابة / Response Format

### استجابة ناجحة / Success Response
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

## 🛠️ الأوامر المفيدة / Useful Commands

### فحص الخادم / Check Server
```bash
curl http://localhost:8080/
```

### قائمة النماذج / List Models
```bash
curl http://localhost:8080/api/models | jq
```

### حالة النظام / System Status
```bash
curl http://localhost:8080/webhook/status | jq
```

### معلومات الدمج / Integration Info
```bash
curl http://localhost:8080/webhook/info | jq
```

### التوثيق التفاعلي / Interactive Docs
افتح في المتصفح / Open in browser:
```
http://localhost:8080/api/docs
```

---

## 📁 ملفات المشروع / Project Files

| الملف / File | الوصف / Description |
|-------------|---------------------|
| `openwebui-integration.py` | السكريبت الرئيسي / Main script |
| `deploy-openwebui-integration.sh` | سكريبت النشر / Deployment script |
| `OPENWEBUI_INTEGRATION.md` | التوثيق الكامل / Full documentation |
| `openwebui-demo.html` | صفحة العرض / Demo page |
| `.env` | ملف الإعدادات / Configuration file |
| `start-integration.sh` | سكريبت التشغيل / Startup script |

---

## 🔧 استكشاف الأخطاء / Troubleshooting

### المشكلة: المنفذ 8080 مستخدم
**الحل / Solution:**
```bash
export PORT=8081
python3 openwebui-integration.py
```

### المشكلة: خطأ في المصادقة
**الحل / Solution:**
تأكد من استخدام JWT Token أو API Key الصحيح
Ensure correct JWT Token or API Key is used

### المشكلة: النموذج غير متاح
**الحل / Solution:**
```bash
# تحقق من القائمة / Check list
curl http://localhost:8080/api/models | jq '.models[].id'
```

---

## 📞 الدعم / Support

- **GitHub:** https://github.com/wasalstor-web/AI-Agent-Platform
- **التوثيق:** https://wasalstor-web.github.io/AI-Agent-Platform/
- **Issues:** https://github.com/wasalstor-web/AI-Agent-Platform/issues

---

## ✅ ملخص التنفيذ / Implementation Summary

- ✅ **6 نماذج ذكاء صناعي مفتوحة المصدر**
- ✅ **مصادقة آمنة عبر JWT و API Key**
- ✅ **نقاط استقبال Webhooks جاهزة**
- ✅ **دعم كامل للغة العربية**
- ✅ **واجهة برمجية موثقة**
- ✅ **جاهز للاستخدام الفوري**

---

**© 2025 خليف 'ذيبان' العنزي**  
**القصيم – بريدة – المملكة العربية السعودية**
