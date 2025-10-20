# 🚀 دليل نشر نظام DL+ على Hostinger

## DL+ Deployment Guide for Hostinger

هذا الدليل يشرح كيفية نشر نظام DL+ الكامل على خادم Hostinger.

---

## 📋 المتطلبات الأساسية

### على الخادم (Hostinger)

- ✅ VPS أو خادم مخصص (Shared hosting غير كافٍ)
- ✅ نظام Linux (Ubuntu 20.04+ مستحسن)
- ✅ صلاحيات SSH
- ✅ Python 3.8 أو أحدث
- ✅ Git
- ✅ 2 GB RAM على الأقل
- ✅ 10 GB مساحة تخزين

### على جهازك المحلي

- Git
- SSH client
- محرر نصوص

---

## 📦 الخطوة 1: إعداد الخادم

### الاتصال بالخادم

```bash
ssh user@your-hostinger-server.com
```

### تحديث النظام

```bash
sudo apt update
sudo apt upgrade -y
```

### تثبيت المتطلبات الأساسية

```bash
# Python 3 و pip
sudo apt install -y python3 python3-pip python3-venv

# Git
sudo apt install -y git

# أدوات إضافية
sudo apt install -y build-essential libssl-dev libffi-dev
```

### تحقق من الإصدارات

```bash
python3 --version  # يجب أن يكون 3.8+
git --version
```

---

## 📥 الخطوة 2: استنساخ المشروع

### اختيار موقع التثبيت

```bash
# الانتقال إلى المجلد الرئيسي
cd ~

# أو إنشاء مجلد مخصص
mkdir -p ~/applications
cd ~/applications
```

### استنساخ المستودع

```bash
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
```

---

## ⚙️ الخطوة 3: إعداد DL+

### إنشاء البيئة الافتراضية

```bash
python3 -m venv venv
source venv/bin/activate
```

### تثبيت المتطلبات

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### إعداد ملف الإعدادات

```bash
# نسخ ملف المثال
cp .env.dlplus.example .env

# تحرير الملف
nano .env
```

### إعدادات ضرورية في `.env`

```env
# إعدادات FastAPI
FASTAPI_HOST=0.0.0.0
FASTAPI_PORT=8000
FASTAPI_SECRET_KEY=$(openssl rand -hex 32)

# إعدادات GitHub (اختياري)
GITHUB_TOKEN=your-github-token
GITHUB_REPO=wasalstor-web/AI-Agent-Platform

# إعدادات OpenWebUI
OPENWEBUI_ENABLED=true
OPENWEBUI_PORT=3000
OPENWEBUI_HOST=0.0.0.0

# السجلات
LOG_LEVEL=INFO
LOG_FILE=./logs/dlplus.log
```

### توليد مفاتيح آمنة

```bash
# توليد مفتاح FastAPI
openssl rand -hex 32

# توليد مفتاح OpenWebUI
openssl rand -hex 32
```

ضع المفاتيح في ملف `.env`:
```env
FASTAPI_SECRET_KEY=المفتاح_الذي_تم_توليده
WEBUI_SECRET_KEY=المفتاح_الآخر_الذي_تم_توليده
```

---

## 🧪 الخطوة 4: اختبار التثبيت

### تشغيل اختبار سريع

```bash
# تفعيل البيئة الافتراضية
source venv/bin/activate

# تشغيل الاختبارات
pytest tests/ -v

# تشغيل النظام للاختبار
python dlplus/main.py
```

إذا ظهرت رسالة مشابهة:
```
🧠 DL+ Unified Arabic Intelligence System
نظام DL+ للذكاء الصناعي العربي الموحد
═══════════════════════════════════════
✅ DL+ System initialized successfully!
🚀 Starting FastAPI server on 0.0.0.0:8000
```

معنى ذلك أن النظام يعمل! اضغط `Ctrl+C` لإيقافه.

---

## 🔄 الخطوة 5: إعداد كخدمة Systemd

### إنشاء ملف الخدمة

```bash
sudo nano /etc/systemd/system/dlplus.service
```

### محتوى ملف الخدمة

```ini
[Unit]
Description=DL+ Arabic Intelligence System
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
Group=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/AI-Agent-Platform
Environment="PATH=/home/YOUR_USERNAME/AI-Agent-Platform/venv/bin"
ExecStart=/home/YOUR_USERNAME/AI-Agent-Platform/venv/bin/python dlplus/main.py
Restart=always
RestartSec=10

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=/home/YOUR_USERNAME/AI-Agent-Platform/logs

[Install]
WantedBy=multi-user.target
```

**⚠️ استبدل `YOUR_USERNAME` باسم المستخدم الفعلي!**

### تفعيل الخدمة

```bash
# إعادة تحميل systemd
sudo systemctl daemon-reload

# تفعيل الخدمة
sudo systemctl enable dlplus

# بدء الخدمة
sudo systemctl start dlplus

# فحص الحالة
sudo systemctl status dlplus
```

### أوامر إدارة الخدمة

```bash
# إيقاف الخدمة
sudo systemctl stop dlplus

# إعادة التشغيل
sudo systemctl restart dlplus

# عرض السجلات
sudo journalctl -u dlplus -f

# عرض آخر 100 سطر
sudo journalctl -u dlplus -n 100
```

---

## 🌐 الخطوة 6: إعداد Nginx كـ Reverse Proxy

### تثبيت Nginx

```bash
sudo apt install -y nginx
```

### إنشاء تكوين Nginx

```bash
sudo nano /etc/nginx/sites-available/dlplus
```

### محتوى ملف التكوين

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    # DL+ API
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # OpenWebUI (إذا كنت تستخدمه)
    location /openwebui/ {
        proxy_pass http://127.0.0.1:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### تفعيل التكوين

```bash
# ربط التكوين
sudo ln -s /etc/nginx/sites-available/dlplus /etc/nginx/sites-enabled/

# اختبار التكوين
sudo nginx -t

# إعادة تحميل Nginx
sudo systemctl reload nginx
```

---

## 🔒 الخطوة 7: تأمين النظام بـ SSL

### تثبيت Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

### الحصول على شهادة SSL

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

اتبع التعليمات التفاعلية:
- أدخل بريدك الإلكتروني
- اقبل شروط الخدمة
- اختر ما إذا كنت تريد إعادة التوجيه التلقائي لـ HTTPS

### التجديد التلقائي

```bash
# اختبار التجديد
sudo certbot renew --dry-run

# سيتم التجديد تلقائياً كل 90 يوم
```

---

## 🔥 الخطوة 8: إعداد جدار الحماية

### تفعيل UFW

```bash
sudo ufw enable
```

### السماح بالمنافذ الضرورية

```bash
# SSH
sudo ufw allow 22/tcp

# HTTP
sudo ufw allow 80/tcp

# HTTPS
sudo ufw allow 443/tcp

# فحص الحالة
sudo ufw status
```

---

## 📊 الخطوة 9: المراقبة والصيانة

### فحص السجلات

```bash
# سجلات DL+
tail -f ~/AI-Agent-Platform/logs/dlplus.log

# سجلات systemd
sudo journalctl -u dlplus -f

# سجلات Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### فحص الحالة

```bash
# حالة خدمة DL+
sudo systemctl status dlplus

# حالة Nginx
sudo systemctl status nginx

# استخدام الموارد
htop
```

### النسخ الاحتياطي

```bash
# إنشاء نسخة احتياطية
cd ~
tar -czf dlplus-backup-$(date +%Y%m%d).tar.gz AI-Agent-Platform/

# نقل النسخة الاحتياطية (اختياري)
scp dlplus-backup-*.tar.gz user@backup-server:/backups/
```

---

## 🔄 الخطوة 10: التحديثات

### تحديث النظام

```bash
cd ~/AI-Agent-Platform

# إيقاف الخدمة
sudo systemctl stop dlplus

# سحب التحديثات
git pull origin main

# تحديث المتطلبات
source venv/bin/activate
pip install --upgrade -r requirements.txt

# بدء الخدمة
sudo systemctl start dlplus

# فحص الحالة
sudo systemctl status dlplus
```

---

## ✅ التحقق من النشر

### اختبار API

```bash
# من خادم آخر أو جهازك المحلي
curl https://your-domain.com/api/health

# يجب أن تحصل على:
# {"status":"healthy","timestamp":"..."}
```

### اختبار معالجة الأوامر

```bash
curl -X POST https://your-domain.com/api/process \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{"command": "مرحباً"}'
```

### زيارة الواجهة

افتح متصفحك وانتقل إلى:
- `https://your-domain.com` - DL+ API
- `https://your-domain.com/api/docs` - التوثيق التفاعلي
- `https://your-domain.com/openwebui/` - OpenWebUI (إذا كان مثبتاً)

---

## 🐛 استكشاف الأخطاء

### المشكلة: الخدمة لا تبدأ

```bash
# فحص السجلات
sudo journalctl -u dlplus -n 50

# فحص الأذونات
ls -la ~/AI-Agent-Platform

# التحقق من ملف .env
cat ~/AI-Agent-Platform/.env
```

### المشكلة: خطأ في الاتصال بقاعدة البيانات

```bash
# التحقق من إعدادات .env
# تأكد من صحة معلومات الاتصال
```

### المشكلة: المنفذ مستخدم بالفعل

```bash
# إيجاد العملية المستخدمة للمنفذ
sudo lsof -i :8000

# إيقاف العملية
sudo kill -9 PID
```

### المشكلة: خطأ في SSL

```bash
# فحص صلاحية الشهادة
sudo certbot certificates

# تجديد الشهادة
sudo certbot renew
```

---

## 📝 أفضل الممارسات

### الأمان

- ✅ غيّر المفاتيح الافتراضية
- ✅ استخدم SSL دائماً في الإنتاج
- ✅ قيّد الوصول إلى SSH
- ✅ راقب السجلات بانتظام
- ✅ قم بالتحديثات الأمنية

### الأداء

- ✅ استخدم Nginx للتخزين المؤقت
- ✅ راقب استخدام الموارد
- ✅ قم بتحسين قاعدة البيانات
- ✅ استخدم CDN للملفات الثابتة

### الصيانة

- ✅ نسخ احتياطية منتظمة
- ✅ مراقبة مستمرة
- ✅ تحديثات منتظمة
- ✅ توثيق التغييرات

---

## 📞 الدعم

للحصول على المساعدة:
- 📖 [الوثائق الكاملة](dlplus/docs/DLPLUS_SYSTEM.md)
- 🐛 [فتح Issue](https://github.com/wasalstor-web/AI-Agent-Platform/issues)
- 💬 راجع السجلات في `logs/dlplus.log`

---

## 🎉 تهانينا!

نظام DL+ الآن يعمل على خادم Hostinger الخاص بك!

**الوصول إلى النظام:**
- API: `https://your-domain.com`
- Docs: `https://your-domain.com/api/docs`
- Status: `https://your-domain.com/api/status`

---

**المؤسس:** خليف "ذيبان" العنزي  
**الموقع:** القصيم – بريدة – المملكة العربية السعودية
