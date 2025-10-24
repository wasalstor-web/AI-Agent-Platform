# تشغيل منصة وكيل الذكاء الاصطناعي - دليل الوصول
# AI Agent Platform - Access Guide

## ✅ تم الإنجاز | Completed

تم تشغيل منصة وكيل الذكاء الاصطناعي بنجاح على البيئة المحلية!

The AI Agent Platform has been successfully deployed on the local environment!

---

## 🌐 روابط الوصول | Access URLs

### 1. الصفحة الرئيسية | Home Page
```
http://localhost:8080
http://localhost:8080/index.html
```

**الميزات المتاحة | Available Features:**
- ✅ نظرة عامة على المشروع والميزات الرئيسية
- ✅ واجهة دردشة تفاعلية مع نماذج الذكاء الاصطناعي
- ✅ عرض سير عمل النظام
- ✅ تكامل OpenWebUI
- ✅ تبديل اللغة (عربي/إنجليزي)
- ✅ روابط سريعة للإجراءات والمستودع والتوثيق

### 2. صفحة الإجراءات | Actions Page
```
http://localhost:8080/actions.html
```

**الميزات المتاحة | Available Features:**
- ✅ إحصائيات النظام المباشرة (5 وكلاء نشطون، 127 مهام مكتملة، 98.5% نسبة النجاح، 99.9% وقت التشغيل)
- ✅ 6 إجراءات قابلة للتنفيذ:
  - 🔍 البحث على الويب
  - 💻 توليد الأكواد
  - 📁 عمليات الملفات
  - ⚙️ تنفيذ الأوامر
  - 🔤 معالجة اللغة العربية
  - 📊 تحليل البيانات
- ✅ لوحة تنفيذ مخصصة مع اختيار النموذج
- ✅ سجلات النشاط المباشرة

### 3. API Endpoints
```
Base URL: http://localhost:5000

Health Check:    http://localhost:5000/api/health
Status:          http://localhost:5000/api/status
Process:         http://localhost:5000/api/process (POST)
Models List:     http://localhost:5000/api/models
```

---

## 🚀 كيفية التشغيل | How to Run

### الطريقة الأولى: التشغيل التلقائي (موصى بها)
### Method 1: Automatic Startup (Recommended)

```bash
# 1. انتقل إلى مجلد المشروع
cd AI-Agent-Platform

# 2. قم بتشغيل سكريبت البدء
./start-local.sh
```

السكريبت سيقوم بـ:
- إنشاء بيئة افتراضية Python
- تثبيت جميع المتطلبات
- تشغيل خادم API على المنفذ 5000
- تشغيل خادم الويب على المنفذ 8080
- عرض جميع روابط الوصول

### الطريقة الثانية: التشغيل اليدوي
### Method 2: Manual Startup

```bash
# 1. تثبيت المتطلبات
pip install flask flask-cors

# 2. تشغيل خادم API (نافذة طرفية أولى)
cd api
python3 server.py

# 3. تشغيل خادم الويب (نافذة طرفية ثانية)
cd ..
python3 -m http.server 8080
```

---

## 📸 لقطات الشاشة | Screenshots

### الصفحة الرئيسية | Home Page
![Home Page](https://github.com/user-attachments/assets/696ab5b7-0baa-4406-81cb-54852c439d95)

**يظهر في الصفحة:**
- الهيدر مع عنوان المنصة
- نظرة عامة على المشروع
- 8 بطاقات للميزات الرئيسية
- سير عمل الإنهاء (6 خطوات)
- تكامل OpenWebUI
- واجهة الدردشة التفاعلية
- أزرار الإجراءات السريعة

### صفحة الإجراءات | Actions Page
![Actions Page](https://github.com/user-attachments/assets/d8f1ce6f-8505-45a2-92ef-d3e9328ecfcf)

**يظهر في الصفحة:**
- إحصائيات النظام (4 بطاقات)
- 6 بطاقات للإجراءات المتاحة
- لوحة التنفيذ المخصصة
- سجلات النشاط المباشرة

---

## 🧪 اختبار الوظائف | Testing Features

### 1. اختبار API الصحي | Test API Health
```bash
curl http://localhost:5000/api/health
```

**النتيجة المتوقعة:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-24T19:56:27.194256",
  "service": "AI Agent Platform API"
}
```

### 2. اختبار حالة النظام | Test System Status
```bash
curl http://localhost:5000/api/status
```

**النتيجة المتوقعة:**
```json
{
  "status": "operational",
  "models": [
    "gpt-3.5-turbo",
    "gpt-4",
    "claude-3",
    "llama-3",
    "qwen-arabic",
    "arabert",
    "mistral",
    "deepseek"
  ],
  "timestamp": "2025-10-24T19:57:06.988939"
}
```

### 3. اختبار معالجة الأوامر | Test Command Processing
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

**النتيجة المتوقعة:**
```json
{
  "success": true,
  "response": "مرحباً! أنا gpt-3.5-turbo وأنا هنا لمساعدتك. كيف يمكنني مساعدتك اليوم؟",
  "model": "gpt-3.5-turbo",
  "timestamp": "2025-10-24T19:57:15.216472"
}
```

---

## 📋 البيانات التجريبية | Demo Data

المنصة حالياً تعمل ببيانات تجريبية لتوضيح الوظائف:

The platform currently works with demo data to demonstrate functionality:

### الإحصائيات المعروضة | Displayed Statistics
- **وكلاء نشطون:** 5
- **مهام مكتملة:** 127
- **نسبة النجاح:** 98.5%
- **وقت التشغيل:** 99.9%

### النماذج المتاحة | Available Models
1. GPT-3.5 Turbo
2. GPT-4
3. Claude 3
4. LLaMA 3
5. Qwen Arabic
6. AraBERT
7. Mistral
8. DeepSeek Coder

### الإجراءات المتاحة | Available Actions
1. 🔍 **البحث على الويب** - نشط
2. 💻 **توليد الأكواد** - نشط
3. 📁 **عمليات الملفات** - نشط
4. ⚙️ **تنفيذ الأوامر** - محدود
5. 🔤 **معالجة اللغة العربية** - نشط
6. 📊 **تحليل البيانات** - نشط

---

## 🎯 الوظائف التفاعلية | Interactive Features

### في الصفحة الرئيسية:
1. **تبديل اللغة:** زر في أعلى اليسار للتبديل بين العربية والإنجليزية
2. **واجهة الدردشة:**
   - اختيار النموذج من قائمة منسدلة
   - زر الاتصال بالنموذج
   - مؤشر حالة الاتصال
   - صندوق إدخال الرسائل
   - زر الإرسال
3. **إعدادات API:** قابلة للتوسيع لإدخال نقطة نهاية API ومفتاح API
4. **أزرار الإجراءات السريعة:**
   - صفحة الإجراءات
   - المستودع على GitHub
   - تشغيل الإنهاء
   - تحميل التوثيق

### في صفحة الإجراءات:
1. **بطاقات الإجراءات:** كل بطاقة لها زر "تشغيل" يضيف سجل في قسم السجلات
2. **لوحة التنفيذ:**
   - اختيار نوع الإجراء
   - إدخال المدخلات
   - اختيار النموذج
   - زر تنفيذ الإجراء
3. **سجلات النشاط:** تحديث تلقائي مع رسائل جديدة كل 10 ثواني

---

## 🛑 إيقاف الخوادم | Stopping Servers

### إذا استخدمت start-local.sh:
اضغط `Ctrl+C` في نافذة الطرفية

### إذا استخدمت التشغيل اليدوي:
```bash
# إيقاف جميع الخوادم
pkill -f "python3 -m http.server 8080"
pkill -f "python3 server.py"
```

---

## 📚 ملفات المشروع الجديدة | New Project Files

تم إنشاء الملفات التالية:

The following files have been created:

1. **`actions.html`** - صفحة الإجراءات الكاملة (638 سطر)
2. **`start-local.sh`** - سكريبت التشغيل التلقائي (196 سطر)
3. **`LOCAL_DEPLOYMENT.md`** - دليل النشر المحلي الشامل
4. **`ACCESS_GUIDE.md`** - هذا الملف - دليل الوصول النهائي

تم تحديث:
- **`index.html`** - إضافة زر "صفحة الإجراءات"
- **`requirements.txt`** - إضافة Flask و Flask-CORS

---

## 🔗 المتطلبات الإضافية | Additional Requirements

للتكامل الكامل مع نماذج الذكاء الاصطناعي الحقيقية:

For full integration with real AI models:

1. **احصل على مفتاح API من OpenRouter:**
   - زيارة: https://openrouter.ai/
   - إنشاء حساب والحصول على API key

2. **قم بإعداد المتغيرات البيئية:**
   ```bash
   export OPENROUTER_API_KEY="your_api_key_here"
   ```

3. **قم بتحديث ملف api/server.py** لاستخدام OpenRouter API بدلاً من البيانات التجريبية

---

## 📞 الدعم والمساعدة | Support & Help

للحصول على المساعدة:
- راجع [README.md](README.md) للتوثيق الكامل
- راجع [DLPLUS_README.md](DLPLUS_README.md) لتفاصيل نظام DL+
- راجع [LOCAL_DEPLOYMENT.md](LOCAL_DEPLOYMENT.md) لخطوات التشغيل التفصيلية
- افتح Issue على: https://github.com/wasalstor-web/AI-Agent-Platform/issues

---

## ✨ الخلاصة | Summary

تم تشغيل منصة وكيل الذكاء الاصطناعي بنجاح مع:
- ✅ صفحة رئيسية تفاعلية مع دردشة AI
- ✅ صفحة إجراءات شاملة مع 6 إجراءات مختلفة
- ✅ خادم API يعمل بشكل كامل
- ✅ بيانات تجريبية لتوضيح جميع الوظائف
- ✅ دعم كامل للغتين العربية والإنجليزية
- ✅ واجهة مستخدم حديثة وسريعة الاستجابة

**روابط الوصول السريع:**
- الصفحة الرئيسية: http://localhost:8080
- صفحة الإجراءات: http://localhost:8080/actions.html
- API Health: http://localhost:5000/api/health

---

**صُنع بـ ❤️ للمجتمع العربي والعالمي**

**Made with ❤️ for the Arabic and Global Community**

© 2025 AI Agent Platform
