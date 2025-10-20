# 🧠 نظام DL+ - دليل الإعداد والتشغيل السريع

## DL+ System - Quick Setup and Launch Guide

---

## 🎯 نظرة سريعة

**DL+ (Deep Learning Plus)** هو نظام ذكاء صناعي عربي موحد يجمع بين:
- 🧠 **GitHub** - مركز الذكاء والنماذج
- ⚙️ **Hostinger** - بيئة التنفيذ والنشر
- 💬 **OpenWebUI** - الواجهة التفاعلية

---

## ⚡ التشغيل السريع

### الطريقة الأسهل (مستحسنة)

```bash
# 1. استنساخ المستودع
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# 2. تشغيل النظام
./start-dlplus.sh
```

هذا كل شيء! السكريبت سيقوم بـ:
- ✅ فحص المتطلبات
- ✅ إنشاء البيئة الافتراضية
- ✅ تثبيت الحزم المطلوبة
- ✅ إعداد ملف .env
- ✅ تشغيل النظام

---

## 📋 الإعداد اليدوي (خطوة بخطوة)

### 1. المتطلبات الأساسية

```bash
# تأكد من تثبيت Python 3.8+
python3 --version

# تثبيت pip
python3 -m pip --version
```

### 2. إعداد البيئة

```bash
# إنشاء بيئة افتراضية
python3 -m venv venv

# تفعيل البيئة
source venv/bin/activate  # Linux/Mac
# أو
venv\Scripts\activate     # Windows
```

### 3. تثبيت المتطلبات

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 4. إعداد التكوين

```bash
# نسخ ملف الإعدادات
cp .env.dlplus.example .env

# تحرير الإعدادات (استخدم محرر نصوص مفضل)
nano .env
# أو
vim .env
# أو
code .env
```

**الإعدادات المهمة:**

```env
# توليد مفتاح سري آمن
FASTAPI_SECRET_KEY=$(openssl rand -hex 32)

# إعدادات GitHub (اختياري للبداية)
GITHUB_TOKEN=your-token
GITHUB_REPO=wasalstor-web/AI-Agent-Platform

# إعدادات الخادم
FASTAPI_HOST=0.0.0.0
FASTAPI_PORT=8000
```

### 5. تشغيل النظام

```bash
python dlplus/main.py
```

---

## 🌐 الوصول إلى النظام

بعد التشغيل، سيكون النظام متاحاً على:

- **📍 الصفحة الرئيسية:** http://localhost:8000
- **📖 التوثيق التفاعلي:** http://localhost:8000/api/docs
- **🔍 الحالة:** http://localhost:8000/api/status
- **💚 الصحة:** http://localhost:8000/api/health

---

## 🧪 اختبار النظام

### اختبار سريع عبر cURL

```bash
# 1. فحص صحة النظام
curl http://localhost:8000/api/health

# 2. فحص الحالة
curl http://localhost:8000/api/status \
  -H "X-API-Key: your-secret-key"

# 3. معالجة أمر
curl -X POST http://localhost:8000/api/process \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{"command": "مرحباً، كيف حالك؟"}'
```

### اختبار عبر Python

```python
import httpx
import asyncio

async def test_dlplus():
    async with httpx.AsyncClient() as client:
        # فحص الصحة
        response = await client.get("http://localhost:8000/api/health")
        print("Health:", response.json())
        
        # معالجة أمر
        response = await client.post(
            "http://localhost:8000/api/process",
            headers={"X-API-Key": "your-secret-key"},
            json={"command": "اشرح لي ما هو نظام DL+"}
        )
        print("Response:", response.json())

asyncio.run(test_dlplus())
```

---

## 🎨 تشغيل OpenWebUI

### باستخدام السكريبت المضمن

```bash
./setup-openwebui.sh install
```

### يدوياً باستخدام Docker

```bash
docker run -d -p 3000:8080 \
  -e OLLAMA_API_BASE_URL=http://localhost:11434 \
  -v open-webui:/app/backend/data \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
```

الوصول إلى OpenWebUI: http://localhost:3000

---

## 📁 بنية المشروع

```
AI-Agent-Platform/
├── dlplus/                    # نظام DL+ الرئيسي
│   ├── core/                  # نواة الذكاء
│   │   ├── intelligence_core.py
│   │   ├── arabic_processor.py
│   │   └── context_analyzer.py
│   ├── api/                   # واجهات API
│   │   ├── fastapi_connector.py
│   │   └── internal_api.py
│   ├── config/                # الإعدادات
│   │   ├── settings.py
│   │   ├── models_config.py
│   │   └── agents_config.py
│   ├── docs/                  # الوثائق
│   │   └── DLPLUS_SYSTEM.md
│   └── main.py               # نقطة الدخول الرئيسية
├── start-dlplus.sh           # سكريبت التشغيل
├── requirements.txt          # المتطلبات
├── .env.dlplus.example      # مثال الإعدادات
└── README.md                # هذا الملف
```

---

## 🔧 الأوامر المفيدة

### إدارة النظام

```bash
# تشغيل النظام
./start-dlplus.sh

# تشغيل يدوي
python dlplus/main.py

# تشغيل في الخلفية
nohup python dlplus/main.py > dlplus.log 2>&1 &

# إيقاف النظام
pkill -f "python dlplus/main.py"
```

### الاختبارات

```bash
# تشغيل جميع الاختبارات
pytest

# مع تغطية الكود
pytest --cov=dlplus --cov-report=html

# اختبارات محددة
pytest tests/test_core.py -v
```

### الصيانة

```bash
# تحديث المتطلبات
pip install --upgrade -r requirements.txt

# تنظيف الملفات المؤقتة
find . -type d -name "__pycache__" -exec rm -r {} +
find . -type f -name "*.pyc" -delete

# تنظيف السجلات
rm -rf logs/*.log
```

---

## 🚀 النشر على Hostinger

### 1. الاتصال بالخادم

```bash
ssh user@your-hostinger-server
```

### 2. إعداد المشروع

```bash
# استنساخ المستودع
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# تشغيل النظام
./start-dlplus.sh
```

### 3. إعداد كخدمة (systemd)

إنشاء ملف `/etc/systemd/system/dlplus.service`:

```ini
[Unit]
Description=DL+ Arabic Intelligence System
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/path/to/AI-Agent-Platform
Environment="PATH=/path/to/AI-Agent-Platform/venv/bin"
ExecStart=/path/to/AI-Agent-Platform/venv/bin/python dlplus/main.py
Restart=always

[Install]
WantedBy=multi-user.target
```

تفعيل الخدمة:

```bash
sudo systemctl daemon-reload
sudo systemctl enable dlplus
sudo systemctl start dlplus
sudo systemctl status dlplus
```

---

## 🔒 الأمان

### توليد مفاتيح آمنة

```bash
# مفتاح FastAPI
openssl rand -hex 32

# مفتاح OpenWebUI
openssl rand -hex 32
```

### أفضل الممارسات

- ✅ لا تشارك ملف `.env` أبداً
- ✅ استخدم HTTPS في الإنتاج
- ✅ غيّر المفاتيح الافتراضية
- ✅ قيّد الوصول إلى API
- ✅ فعّل جدار الحماية
- ✅ راقب السجلات بانتظام

---

## 📚 الوثائق الكاملة

للحصول على وثائق شاملة، راجع:

- **📖 [وثائق النظام الكاملة](dlplus/docs/DLPLUS_SYSTEM.md)**
- **🚀 [دليل النشر](DEPLOYMENT.md)**
- **🎨 [دليل OpenWebUI](OPENWEBUI.md)**
- **⚡ [البدء السريع](QUICK-START.md)**

---

## 🐛 استكشاف الأخطاء

### المشكلة: خطأ في استيراد الوحدات

```bash
# الحل: تأكد من تفعيل البيئة الافتراضية
source venv/bin/activate
pip install -r requirements.txt
```

### المشكلة: المنفذ مستخدم بالفعل

```bash
# الحل: تغيير المنفذ في .env
FASTAPI_PORT=8001

# أو إيقاف العملية المستخدمة للمنفذ
lsof -ti:8000 | xargs kill -9
```

### المشكلة: خطأ في الاتصال بـ Ollama

```bash
# الحل: تأكد من تشغيل Ollama
ollama serve

# أو تعديل الإعدادات
OLLAMA_API_BASE_URL=http://your-ollama-server:11434
```

---

## 🤝 المساهمة

نرحب بمساهماتك! للمساهمة:

1. Fork المستودع
2. إنشاء فرع جديد (`git checkout -b feature/amazing`)
3. Commit التغييرات (`git commit -m 'إضافة ميزة رائعة'`)
4. Push إلى الفرع (`git push origin feature/amazing`)
5. فتح Pull Request

---

## 📞 الدعم

- **📧 GitHub Issues:** [فتح مشكلة](https://github.com/wasalstor-web/AI-Agent-Platform/issues)
- **📖 الوثائق:** راجع الملفات في `dlplus/docs/`
- **💬 المجتمع:** انضم إلى المناقشات

---

## 🌟 الميزات القادمة

- [ ] دعم نماذج AI إضافية
- [ ] واجهة ويب مخصصة
- [ ] تكامل مع Telegram
- [ ] دعم الصوت والصورة
- [ ] لوحة تحكم إدارية
- [ ] API لتطبيقات الجوال

---

## 👤 المؤلف

**خليف "ذيبان" العنزي**  
مؤسس منظومة DL+ للذكاء الصناعي العربي  
📍 القصيم – بريدة – المملكة العربية السعودية

---

## 📝 الترخيص

هذا المشروع مرخص تحت MIT License.

---

## 🎉 شكراً لاستخدامك DL+!

> *DL+ هو النظام العربي الصناعي الأول الذي يجمع بين الفهم العميق، اللغة الفصحى، والتنفيذ الذاتي المتكامل بين GitHub وHostinger.*

**ابدأ الآن:**
```bash
./start-dlplus.sh
```
