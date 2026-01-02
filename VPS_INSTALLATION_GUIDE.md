# 🚀 دليل التثبيت الكامل على VPS - بيئة مثالية
# Complete VPS Installation Guide - Perfect Environment

**المطور**: خليف 'ذيبان' العنزي  
**الموقع**: القصيم - بريدة - المملكة العربية السعودية

---

## 📋 ملخص المشاكل الموجودة | Current Issues Summary

### ⚠️ المشاكل الرئيسية (يجب إصلاحها):

1. **🔴 توكنات مكشوفة في الكود**:
   - `KHALID_TOKEN` في dashboard.html و command-center.php
   - `QweAsdZxc@555_SECURE` في agent-webhook.php
   - **الحل**: نقلها لـ `.env` (سيتم تثبيتها تلقائياً)

2. **🟡 CORS مفتوح بالكامل**:
   - يسمح لجميع النطاقات
   - **الحل**: تقييد للنطاقات المسموحة فقط

3. **🟡 TODO معلقة**:
   - بعض الوظائف غير مكتملة
   - **الحل**: يمكن العمل عليها لاحقاً

**الخلاصة**: المشاكل بسيطة ويمكن إصلاحها بسهولة! ✅

---

## 🎯 المتطلبات الكاملة للتثبيت على VPS

### 📦 1. متطلبات النظام الأساسية

```bash
# نظام التشغيل
- Ubuntu 20.04+ أو Debian 11+
- 2 GB RAM على الأقل (4 GB مستحسن)
- 20 GB مساحة تخزين (50 GB مستحسن)
- معالج 2 cores على الأقل
```

### 🛠️ 2. البرمجيات الأساسية

#### أ) Python وبيئة التطوير
```bash
python3 (3.8+)
python3-pip
python3-venv
python3-dev
build-essential
libssl-dev
libffi-dev
```

#### ب) خادم الويب
```bash
nginx (أو Apache)
```

#### ج) قواعد البيانات (اختياري)
```bash
mysql-server (أو MariaDB)
redis-server
```

#### د) أدوات النظام
```bash
git
curl
wget
openssl
certbot (للـ SSL)
ufw (للجدار الناري)
```

### 🐳 3. Docker و Docker Compose (لـ OpenWebUI)

```bash
docker
docker-compose
```

### 🦙 4. Ollama (للنماذج المحلية - اختياري)

```bash
ollama
```

### 📚 5. مكتبات Python المطلوبة

من `requirements.txt`:
- FastAPI
- Uvicorn
- Pydantic
- aiohttp
- httpx
- beautifulsoup4
- pyyaml
- python-dotenv
- وغيرها...

### 🔐 6. إعدادات الأمان

- SSL Certificate (Let's Encrypt)
- Firewall Rules
- Environment Variables (.env)
- API Keys

---

## 🚀 سكربت التثبيت الكامل

### الطريقة السريعة (مستحسنة):

```bash
# استنساخ المشروع
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# تشغيل سكربت التثبيت الكامل
bash install-complete-vps.sh
```

### التثبيت اليدوي (خطوة بخطوة):

#### الخطوة 1: تحديث النظام
```bash
sudo apt update
sudo apt upgrade -y
```

#### الخطوة 2: تثبيت البرمجيات الأساسية
```bash
sudo apt install -y \
    python3 python3-pip python3-venv python3-dev \
    build-essential libssl-dev libffi-dev \
    git curl wget openssl \
    nginx \
    mysql-server redis-server \
    ufw certbot python3-certbot-nginx
```

#### الخطوة 3: تثبيت Docker
```bash
# إزالة الإصدارات القديمة
sudo apt remove -y docker docker-engine docker.io containerd runc

# تثبيت Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# إضافة المستخدم لمجموعة docker
sudo usermod -aG docker $USER

# تثبيت Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### الخطوة 4: تثبيت Ollama (اختياري)
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

#### الخطوة 5: إعداد المشروع
```bash
# استنساخ المشروع
cd /var/www
sudo git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
sudo chown -R $USER:$USER AI-Agent-Platform
cd AI-Agent-Platform

# إنشاء البيئة الافتراضية
python3 -m venv venv
source venv/bin/activate

# تثبيت المتطلبات
pip install --upgrade pip
pip install -r requirements.txt
```

#### الخطوة 6: إعداد ملف .env
```bash
# نسخ ملف المثال
cp .env.example .env

# توليد مفاتيح آمنة
FASTAPI_KEY=$(openssl rand -hex 32)
HOSTINGER_KEY=$(openssl rand -hex 32)
WEBUI_KEY=$(openssl rand -hex 32)
KHALID_TOKEN=$(openssl rand -hex 32)
AGENT_TOKEN=$(openssl rand -hex 32)

# تحديث ملف .env
cat >> .env << EOF
FASTAPI_SECRET_KEY=$FASTAPI_KEY
HOSTINGER_API_KEY=$HOSTINGER_KEY
WEBUI_SECRET_KEY=$WEBUI_KEY
KHALID_TOKEN=$KHALID_TOKEN
AGENT_TOKEN=$AGENT_TOKEN
EOF
```

#### الخطوة 7: إعداد Nginx
```bash
sudo nano /etc/nginx/sites-available/ai-agent-platform
```

إضافة التكوين:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

تفعيل الموقع:
```bash
sudo ln -s /etc/nginx/sites-available/ai-agent-platform /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### الخطوة 8: إعداد SSL
```bash
sudo certbot --nginx -d your-domain.com
```

#### الخطوة 9: إعداد الجدار الناري
```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8000/tcp
sudo ufw enable
```

#### الخطوة 10: إنشاء خدمة systemd
```bash
sudo nano /etc/systemd/system/ai-agent-platform.service
```

إضافة:
```ini
[Unit]
Description=AI Agent Platform FastAPI Service
After=network.target

[Service]
Type=simple
User=YOUR_USER
Group=www-data
WorkingDirectory=/var/www/AI-Agent-Platform
Environment="PATH=/var/www/AI-Agent-Platform/venv/bin"
ExecStart=/var/www/AI-Agent-Platform/venv/bin/uvicorn dlplus.main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

تفعيل الخدمة:
```bash
sudo systemctl daemon-reload
sudo systemctl enable ai-agent-platform
sudo systemctl start ai-agent-platform
```

---

## 📦 قائمة الحزم الكاملة

### حزم النظام الأساسية:
```bash
python3 python3-pip python3-venv python3-dev
build-essential libssl-dev libffi-dev
git curl wget openssl
nginx
mysql-server redis-server
ufw certbot python3-certbot-nginx
```

### Docker:
```bash
docker docker-compose
```

### Ollama (اختياري):
```bash
ollama
```

### مكتبات Python (من requirements.txt):
```bash
fastapi>=0.110.0
uvicorn[standard]>=0.24.0
pydantic>=2.0.0
python-multipart>=0.0.6
pyyaml>=6.0
aiofiles>=23.0.0
httpx>=0.25.0
aiohttp>=3.9.0
python-jose[cryptography]>=3.3.0
passlib[bcrypt]>=1.7.4
python-json-logger>=2.0.7
beautifulsoup4>=4.12.0
lxml>=4.9.0
duckduckgo-search>=4.0.0
deep-translator>=1.11.0
googletrans>=4.0.0rc1
nltk>=3.8.0
textblob>=0.17.1
pyarabic>=0.6.2
html5lib>=1.1
```

---

## ✅ التحقق من التثبيت

### فحص الخدمات:
```bash
# فحص FastAPI
curl http://localhost:8000/api/health

# فحص Nginx
sudo systemctl status nginx

# فحص Docker
docker ps

# فحص Ollama (إذا مثبت)
curl http://localhost:11434/api/tags
```

### فحص الملفات المهمة:
```bash
# ملف الإعدادات
cat /var/www/AI-Agent-Platform/.env

# السجلات
tail -f /var/log/ai-agent-platform/app.log

# حالة الخدمة
sudo systemctl status ai-agent-platform
```

---

## 🔧 أوامر الصيانة

### إعادة تشغيل الخدمات:
```bash
sudo systemctl restart ai-agent-platform
sudo systemctl restart nginx
```

### عرض السجلات:
```bash
sudo journalctl -u ai-agent-platform -f
sudo tail -f /var/log/nginx/error.log
```

### تحديث المشروع:
```bash
cd /var/www/AI-Agent-Platform
git pull origin main
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart ai-agent-platform
```

---

## 🎯 النتيجة النهائية

بعد التثبيت الكامل، ستحصل على:

✅ **FastAPI Server** على المنفذ 8000  
✅ **Nginx Reverse Proxy** مع SSL  
✅ **Docker & Docker Compose** جاهز  
✅ **Ollama** (إذا مثبت) على المنفذ 11434  
✅ **MySQL & Redis** جاهزين  
✅ **Environment Variables** آمنة في `.env`  
✅ **Systemd Service** يعمل تلقائياً  
✅ **Firewall** محمي  
✅ **SSL Certificate** نشط  

---

## 📞 الدعم

إذا واجهت أي مشاكل:
1. راجع السجلات: `sudo journalctl -u ai-agent-platform -f`
2. تحقق من حالة الخدمات: `sudo systemctl status ai-agent-platform`
3. راجع ملف `.env` للتأكد من الإعدادات

---

**تم إعداد الدليل بواسطة**: خليف 'ذيبان' العنزي  
**التاريخ**: 2025-01-XX

