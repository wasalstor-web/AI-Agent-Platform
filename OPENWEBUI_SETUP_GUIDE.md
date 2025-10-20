# OpenWebUI Integration - Quick Setup Guide
# دليل الإعداد السريع لدمج OpenWebUI

**المؤسس:** خليف 'ذيبان' العنزي  
**الموقع:** القصيم – بريدة – المملكة العربية السعودية

---

## 🚀 الإعداد السريع في 3 خطوات

### Quick Setup in 3 Steps

---

## الخطوة 1: النشر / Step 1: Deployment

### الطريقة الأولى: النشر التلقائي (موصى به)
### Method 1: Automatic Deployment (Recommended)

```bash
# استنساخ المستودع / Clone repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# تشغيل سكريبت النشر / Run deployment script
chmod +x deploy-openwebui-integration.sh
./deploy-openwebui-integration.sh
```

### الطريقة الثانية: النشر اليدوي
### Method 2: Manual Deployment

```bash
# 1. إنشاء البيئة الافتراضية / Create virtual environment
python3 -m venv venv
source venv/bin/activate

# 2. تثبيت المتطلبات / Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# 3. إعداد ملف البيئة / Setup environment file
cp .env.example .env
# تحرير .env وإضافة المفاتيح / Edit .env and add keys

# 4. تشغيل الخادم / Start server
python3 openwebui-integration.py
```

---

## الخطوة 2: التحقق / Step 2: Verification

### التحقق من تشغيل الخادم
### Verify Server is Running

```bash
# فحص الحالة / Check status
curl http://localhost:8080/webhook/status

# الحصول على قائمة النماذج / Get models list
curl http://localhost:8080/api/models
```

**النتيجة المتوقعة / Expected Output:**
```json
{
  "status": "operational",
  "integration": "openwebui",
  "models_enabled": 6
}
```

---

## الخطوة 3: الاختبار / Step 3: Testing

### تشغيل مجموعة الاختبارات الكاملة
### Run Full Test Suite

```bash
# تشغيل الاختبارات / Run tests
chmod +x test-openwebui.sh
./test-openwebui.sh
```

### اختبار سريع
### Quick Test

```bash
# اختبار مع JWT Token
curl -X POST http://localhost:8080/webhook/chat \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "مرحباً",
    "model": "qwen-2.5-arabic"
  }'

# اختبار مع API Key
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello",
    "model": "llama-3-8b"
  }'
```

---

## 📋 قائمة التحقق الكاملة / Complete Checklist

### المكونات / Components

- [x] **Deployment Scripts** - سكريبتات النشر
  - `deploy-openwebui-integration.sh` - النشر الآلي
  - `start-integration.sh` - تشغيل الخادم

- [x] **Environment Configuration** - إعدادات البيئة
  - `.env` - ملف الإعدادات
  - `.env.example` - مثال الإعدادات
  - `.env.dlplus.example` - إعدادات DL+

- [x] **Interactive Web Interface** - الواجهة التفاعلية
  - `openwebui-demo.html` - صفحة العرض التوضيحي
  - `index.html` - الصفحة الرئيسية

- [x] **Testing Scripts** - سكريبتات الاختبار
  - `test-openwebui.sh` - سكريبت الاختبار الشامل
  - `test-openwebui-integration.py` - مجموعة الاختبارات البرمجية

- [x] **Models Configuration** - إعدادات النماذج
  - 6 نماذج ذكاء صناعي مفتوحة المصدر
  - `MODELS_CONFIG.md` - توثيق النماذج

- [x] **Setup Documentation** - توثيق الإعداد
  - `OPENWEBUI_INTEGRATION.md` - دليل الدمج الكامل
  - `OPENWEBUI_SETUP_GUIDE.md` - هذا الدليل
  - `MODELS_CONFIG.md` - إعدادات النماذج

---

## 🤖 النماذج المتاحة / Available Models

### 1. LLaMA 3 8B (Meta)
```bash
# اختبار / Test
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: YOUR_KEY" \
  -d '{"message": "Hello", "model": "llama-3-8b"}'
```

### 2. Qwen 2.5 Arabic (Alibaba)
```bash
# اختبار / Test
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: YOUR_KEY" \
  -d '{"message": "مرحباً", "model": "qwen-2.5-arabic"}'
```

### 3. AraBERT (AUB)
```bash
# اختبار / Test
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: YOUR_KEY" \
  -d '{"message": "تحليل النص", "model": "arabert"}'
```

### 4. Mistral 7B (Mistral AI)
```bash
# اختبار / Test
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: YOUR_KEY" \
  -d '{"message": "Multilingual test", "model": "mistral-7b"}'
```

### 5. DeepSeek Coder (DeepSeek)
```bash
# اختبار / Test
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: YOUR_KEY" \
  -d '{"message": "Write Python code", "model": "deepseek-coder"}'
```

### 6. Phi-3 Mini (Microsoft)
```bash
# اختبار / Test
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: YOUR_KEY" \
  -d '{"message": "Quick question", "model": "phi-3-mini"}'
```

---

## 🔐 الأمان / Security

### توليد مفاتيح جديدة / Generate New Keys

```bash
# توليد JWT Secret / Generate JWT Secret
openssl rand -hex 32

# توليد API Key / Generate API Key
openssl rand -hex 16
```

### تحديث ملف .env / Update .env File

```bash
# OpenWebUI Configuration
OPENWEBUI_ENABLED=true
OPENWEBUI_PORT=3000
OPENWEBUI_HOST=0.0.0.0
OPENWEBUI_JWT_TOKEN=your-generated-jwt-token
OPENWEBUI_API_KEY=sk-your-generated-api-key

# Webhook Configuration
WEBHOOK_BASE_URL=https://your-domain.com
```

---

## 🌐 الوصول / Access

### الوصول المحلي / Local Access
```
http://localhost:8080/
```

### نقاط الاستقبال / Endpoints
- **API Documentation:** `http://localhost:8080/api/docs`
- **Models List:** `http://localhost:8080/api/models`
- **Webhook Status:** `http://localhost:8080/webhook/status`
- **Webhook Chat:** `http://localhost:8080/webhook/chat` (POST)

### الصفحة المباشرة / Live Page
```
https://wasalstor-web.github.io/AI-Agent-Platform/
```

---

## 🔧 استكشاف الأخطاء / Troubleshooting

### المشكلة: الخادم لا يعمل
**Problem: Server not working**

```bash
# تحقق من المنفذ / Check port
lsof -i :8080

# أعد تشغيل / Restart
pkill -f openwebui-integration
./deploy-openwebui-integration.sh
```

### المشكلة: خطأ في المصادقة
**Problem: Authentication error**

```bash
# تحقق من ملف .env / Check .env file
cat .env | grep OPENWEBUI

# تحديث المفاتيح / Update keys
nano .env
```

### المشكلة: الاختبارات تفشل
**Problem: Tests failing**

```bash
# عرض السجلات / View logs
cat test-results-openwebui.json

# إعادة الاختبار / Re-run tests
./test-openwebui.sh http://localhost:8080
```

---

## 📊 الأداء / Performance

### الذاكرة المطلوبة / Memory Requirements
- **Minimum:** 8 GB RAM
- **Recommended:** 16 GB RAM
- **Optimal:** 32 GB RAM

### وقت الاستجابة / Response Time
- **Phi-3 Mini:** < 1 second
- **AraBERT:** < 2 seconds
- **Qwen/Mistral:** 2-5 seconds
- **LLaMA 3:** 3-7 seconds
- **DeepSeek:** 2-5 seconds

---

## 📚 المراجع / References

### التوثيق الكامل / Full Documentation
- [OpenWebUI Integration Guide](OPENWEBUI_INTEGRATION.md)
- [Models Configuration](MODELS_CONFIG.md)
- [DL+ System Guide](DLPLUS_README.md)
- [Main README](README.md)

### أمثلة الاستخدام / Usage Examples
```bash
# عرض جميع الأمثلة / View all examples
ls -la examples/

# تشغيل مثال / Run example
python3 examples/openwebui_example.py
```

---

## 🎯 الخطوات التالية / Next Steps

1. **تخصيص النماذج / Customize Models**
   - تعديل `openwebui-integration.py`
   - إضافة نماذج جديدة
   - تحسين الاستجابات

2. **النشر على الإنتاج / Deploy to Production**
   - إعداد Nginx
   - تفعيل SSL
   - إعداد systemd service

3. **المراقبة / Monitoring**
   - إعداد السجلات
   - مراقبة الأداء
   - تتبع الأخطاء

---

## ✅ التحقق النهائي / Final Verification

```bash
# تشغيل جميع الاختبارات / Run all tests
./test-openwebui.sh

# التحقق من الخدمة / Verify service
curl http://localhost:8080/webhook/status

# عرض التوثيق / View documentation
open http://localhost:8080/api/docs
```

---

## 📞 الدعم / Support

**GitHub Issues:**  
https://github.com/wasalstor-web/AI-Agent-Platform/issues

**Documentation:**  
https://wasalstor-web.github.io/AI-Agent-Platform/

**API Documentation:**  
http://localhost:8080/api/docs

---

## 📝 الترخيص / License

هذا المشروع جزء من منصة AI-Agent-Platform  
This project is part of the AI-Agent-Platform

© 2025 خليف 'ذيبان' العنزي

---

**تاريخ الإنشاء / Created:** 2025-10-20  
**الإصدار / Version:** 1.0.0  
**الحالة / Status:** ✅ جاهز للاستخدام / Ready for Use
