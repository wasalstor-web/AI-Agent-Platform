# Docker Compose Guide - دليل Docker Compose
# AI Agent Platform - منصة وكيل الذكاء الاصطناعي

## 📋 نظرة عامة | Overview

هذا الدليل يوضح كيفية استخدام Docker Compose لتشغيل منصة وكيل الذكاء الاصطناعي.

This guide explains how to use Docker Compose to run the AI Agent Platform.

## ✅ المتطلبات | Prerequisites

- Docker (الإصدار 20.10+ | Version 20.10+)
- Docker Compose (الإصدار 2.0+ | Version 2.0+)
- 2GB RAM كحد أدنى | Minimum 2GB RAM
- 10GB مساحة تخزين | 10GB storage

## 🚀 البدء السريع | Quick Start

### الطريقة 1: استخدام سكريبت البدء السريع | Method 1: Using Quick Start Script

```bash
# جعل السكريبت قابلاً للتنفيذ | Make the script executable
chmod +x docker-start.sh

# تشغيل الوضع التفاعلي | Run in interactive mode
./docker-start.sh

# أو التشغيل المباشر | Or direct start
./docker-start.sh start basic
```

### الطريقة 2: استخدام Docker Compose مباشرة | Method 2: Using Docker Compose Directly

```bash
# بدء الخدمات الأساسية (DL+ فقط) | Start basic services (DL+ only)
docker compose up -d dlplus

# بدء جميع الخدمات (مع OpenWebUI) | Start all services (with OpenWebUI)
docker compose --profile full up -d

# عرض الحالة | Show status
docker compose ps

# عرض السجلات | View logs
docker compose logs -f

# إيقاف الخدمات | Stop services
docker compose down
```

## 📦 الخدمات المتاحة | Available Services

### 1. DL+ Intelligence System

نظام الذكاء الاصطناعي الأساسي للمنصة | Core AI intelligence system

**المنافذ | Ports:**
- `8000`: FastAPI Server

**نقاط النهاية | Endpoints:**
- `http://localhost:8000/` - الصفحة الرئيسية | Root
- `http://localhost:8000/api/health` - فحص الصحة | Health check
- `http://localhost:8000/api/status` - حالة النظام | System status
- `http://localhost:8000/api/process` - معالجة الطلبات | Process requests
- `http://localhost:8000/docs` - التوثيق التفاعلي | Interactive docs

**التشغيل | Starting:**
```bash
docker compose up -d dlplus
```

### 2. OpenWebUI (اختياري | Optional)

واجهة ويب تفاعلية للدردشة مع النماذج | Interactive web interface for chat

**المنافذ | Ports:**
- `3000`: Web Interface (Port 8080 داخل الحاوية | inside container)

**الوصول | Access:**
- `http://localhost:3000`

**التشغيل | Starting:**
```bash
# مع OpenWebUI فقط | With OpenWebUI only
docker compose --profile openwebui up -d

# جميع الخدمات | All services
docker compose --profile full up -d
```

## ⚙️ التكوين | Configuration

### ملف البيئة | Environment File

انسخ ملف البيئة وقم بتعديله | Copy and edit the environment file:

```bash
cp .env.docker .env
nano .env
```

**المتغيرات الأساسية | Essential Variables:**

```bash
# FastAPI Settings
FASTAPI_HOST=0.0.0.0
FASTAPI_PORT=8000
FASTAPI_SECRET_KEY=your-secret-key-here

# OpenRouter API (optional)
OPENROUTER_API_KEY=your-openrouter-key-here

# OpenWebUI Settings
OLLAMA_API_BASE_URL=http://host.docker.internal:11434
WEBUI_SECRET_KEY=another-secret-key-here
```

**توليد مفاتيح سرية | Generate Secret Keys:**

```bash
# استخدم OpenSSL لتوليد مفتاح سري | Use OpenSSL to generate a secret key
openssl rand -hex 32
```

### تخصيص المنافذ | Customizing Ports

لتغيير المنافذ، قم بتعديل ملف `docker-compose.yml`:

To change ports, edit the `docker-compose.yml` file:

```yaml
services:
  dlplus:
    ports:
      - "8000:8000"  # غير 8000 إلى المنفذ المطلوب | Change 8000 to desired port
```

## 🔧 أوامر Docker Compose | Docker Compose Commands

### أوامر أساسية | Basic Commands

```bash
# بناء الصور | Build images
docker compose build

# بناء بدون تخزين مؤقت | Build without cache
docker compose build --no-cache

# بدء الخدمات | Start services
docker compose up -d

# إيقاف الخدمات | Stop services
docker compose down

# إيقاف وحذف البيانات | Stop and remove volumes
docker compose down -v

# إعادة التشغيل | Restart
docker compose restart
```

### أوامر المراقبة | Monitoring Commands

```bash
# عرض الحالة | Show status
docker compose ps

# عرض السجلات | View logs
docker compose logs

# متابعة السجلات مباشرة | Follow logs in real-time
docker compose logs -f

# عرض سجلات خدمة معينة | View logs of specific service
docker compose logs dlplus

# آخر 50 سطر | Last 50 lines
docker compose logs --tail=50
```

### أوامر الصيانة | Maintenance Commands

```bash
# تحديث الصور | Pull latest images
docker compose pull

# عرض استخدام الموارد | Show resource usage
docker compose stats

# تنفيذ أمر داخل الحاوية | Execute command in container
docker compose exec dlplus bash

# عرض التكوين | Show configuration
docker compose config
```

## 🐛 استكشاف الأخطاء | Troubleshooting

### المشكلة: الخدمة لا تبدأ | Service Won't Start

```bash
# تحقق من السجلات | Check logs
docker compose logs dlplus

# تحقق من حالة الحاوية | Check container status
docker compose ps

# أعد بناء الصورة | Rebuild the image
docker compose build --no-cache dlplus
docker compose up -d dlplus
```

### المشكلة: منفذ مستخدم | Port Already in Use

```bash
# إيقاف الخدمات القديمة | Stop old services
docker compose down

# أو غير المنفذ في docker-compose.yml | Or change port in docker-compose.yml
# من | From: "8000:8000"
# إلى | To: "8080:8000"
```

### المشكلة: مشاكل في الشبكة | Network Issues

```bash
# حذف الشبكة وإعادة إنشائها | Remove and recreate network
docker compose down
docker network prune
docker compose up -d
```

### المشكلة: نفاد المساحة | Out of Disk Space

```bash
# تنظيف الصور غير المستخدمة | Clean unused images
docker system prune -a

# حذف البيانات القديمة | Remove old volumes
docker volume prune
```

## 📊 الاختبار | Testing

### اختبار واجهة API | Testing API

```bash
# اختبار الصفحة الرئيسية | Test root endpoint
curl http://localhost:8000/

# اختبار الصحة | Test health check
curl http://localhost:8000/api/health

# اختبار الحالة | Test status
curl http://localhost:8000/api/status

# اختبار المعالجة | Test processing
curl -X POST http://localhost:8000/api/process \
  -H "Content-Type: application/json" \
  -d '{"command": "مرحبا", "context": {}}'
```

### اختبار OpenWebUI | Testing OpenWebUI

```bash
# افتح في المتصفح | Open in browser
xdg-open http://localhost:3000

# أو استخدم curl | Or use curl
curl http://localhost:3000
```

## 🔒 الأمان | Security

### أفضل الممارسات | Best Practices

1. **تغيير المفاتيح السرية | Change Secret Keys**
   ```bash
   # لا تستخدم المفاتيح الافتراضية | Don't use default keys
   FASTAPI_SECRET_KEY=$(openssl rand -hex 32)
   WEBUI_SECRET_KEY=$(openssl rand -hex 32)
   ```

2. **تقييد الوصول | Restrict Access**
   ```bash
   # استخدم جدار ناري | Use firewall
   sudo ufw allow 8000/tcp
   sudo ufw enable
   ```

3. **تحديث منتظم | Regular Updates**
   ```bash
   # حدث الصور | Update images
   docker compose pull
   docker compose up -d
   ```

4. **مراقبة السجلات | Monitor Logs**
   ```bash
   # راقب الأنشطة المشبوهة | Watch for suspicious activity
   docker compose logs -f | grep ERROR
   ```

## 📈 الأداء | Performance

### تحسين الأداء | Performance Optimization

1. **تخصيص الموارد | Resource Allocation**
   
   أضف إلى `docker-compose.yml`:
   ```yaml
   services:
     dlplus:
       deploy:
         resources:
           limits:
             cpus: '2'
             memory: 2G
           reservations:
             cpus: '1'
             memory: 1G
   ```

2. **التخزين المؤقت | Caching**
   
   استخدم volumes للبيانات المتكررة | Use volumes for persistent data

3. **المراقبة | Monitoring**
   ```bash
   # راقب استخدام الموارد | Monitor resource usage
   docker stats ai-agent-dlplus
   ```

## 🌐 النشر | Deployment

### النشر على VPS | Deploying to VPS

```bash
# 1. اتصل بالخادم | Connect to server
ssh user@your-server.com

# 2. استنسخ المستودع | Clone repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# 3. أعد المتغيرات البيئية | Setup environment
cp .env.docker .env
nano .env  # عدل المتغيرات | Edit variables

# 4. شغل الخدمات | Start services
./docker-start.sh start full

# 5. أعد Nginx (اختياري) | Setup Nginx (optional)
sudo apt install nginx
sudo nano /etc/nginx/sites-available/ai-agent
```

### تكوين Nginx | Nginx Configuration

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

## 📝 أمثلة الاستخدام | Usage Examples

### مثال 1: تشغيل سريع | Quick Start Example

```bash
# استنسخ المشروع | Clone project
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# شغل | Start
./docker-start.sh start basic

# اختبر | Test
curl http://localhost:8000/api/health
```

### مثال 2: تشغيل كامل مع OpenWebUI | Full Stack with OpenWebUI

```bash
# شغل جميع الخدمات | Start all services
./docker-start.sh start full

# تحقق من الحالة | Check status
docker compose ps

# افتح المتصفح | Open browser
# DL+ API: http://localhost:8000
# OpenWebUI: http://localhost:3000
```

### مثال 3: التطوير | Development

```bash
# شغل مع إعادة التحميل التلقائي | Start with auto-reload
docker compose up dlplus

# عدل الكود | Edit code
nano dlplus/simple_server.py

# الخدمة ستعيد التحميل تلقائياً | Service will auto-reload
```

## 📚 مراجع إضافية | Additional References

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [OpenWebUI Documentation](https://github.com/open-webui/open-webui)

## 🤝 المساهمة | Contributing

للمساهمة في تحسين Docker Compose setup:

To contribute to improving the Docker Compose setup:

1. Fork المستودع | Fork the repository
2. أنشئ فرع للميزة | Create a feature branch
3. قم بالتعديلات | Make your changes
4. اختبر | Test thoroughly
5. أرسل Pull Request

## 📞 الدعم | Support

للحصول على المساعدة:

For help:

- افتح Issue في GitHub | Open a GitHub Issue
- راجع السجلات | Check logs: `docker compose logs`
- تابع التوثيق | Review documentation

---

**AI Agent Platform** © 2025

**تم إنشاؤه بواسطة | Created by:** خليف 'ذيبان' العنزي

**آخر تحديث | Last Updated:** 2025-11-21
