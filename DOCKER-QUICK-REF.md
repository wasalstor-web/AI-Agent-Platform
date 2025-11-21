# Docker Compose - بطاقة مرجعية سريعة
# Docker Compose Quick Reference Card

## 🚀 البدء السريع | Quick Start

```bash
# طريقة 1: السكريبت التفاعلي | Method 1: Interactive Script
./docker-start.sh

# طريقة 2: بدء مباشر | Method 2: Direct Start  
./docker-start.sh start basic

# طريقة 3: Docker Compose مباشرة | Method 3: Docker Compose Direct
docker compose up -d
```

## 📍 الوصول | Access

| الخدمة | Service | الرابط | URL |
|--------|---------|--------|-----|
| DL+ API | DL+ API | http://localhost:8000 | Root |
| التوثيق | Docs | http://localhost:8000/docs | Interactive API Docs |
| الصحة | Health | http://localhost:8000/api/health | Health Check |
| الحالة | Status | http://localhost:8000/api/status | System Status |
| OpenWebUI | OpenWebUI | http://localhost:3000 | Chat Interface |

## 🔧 الأوامر الأساسية | Basic Commands

```bash
# بدء | Start
docker compose up -d

# إيقاف | Stop
docker compose down

# حالة | Status
docker compose ps

# سجلات | Logs
docker compose logs -f

# إعادة بناء | Rebuild
docker compose build --no-cache

# إعادة تشغيل | Restart
docker compose restart
```

## 🐛 استكشاف الأخطاء | Troubleshooting

```bash
# عرض السجلات | View Logs
docker compose logs dlplus --tail=50

# إعادة بناء وتشغيل | Rebuild and Start
docker compose down
docker compose build --no-cache
docker compose up -d

# تنظيف كامل | Full Cleanup
docker compose down -v
docker system prune -a
```

## 🔒 الأمان | Security

```bash
# توليد مفتاح سري | Generate Secret Key
openssl rand -hex 32

# تعديل المتغيرات البيئية | Edit Environment
cp .env.docker .env
nano .env
```

## 📊 المراقبة | Monitoring

```bash
# موارد النظام | System Resources
docker stats ai-agent-dlplus

# صحة الخدمة | Service Health
curl http://localhost:8000/api/health

# حالة النظام | System Status
curl http://localhost:8000/api/status
```

## 📦 الخدمات | Services

### DL+ Intelligence System
- **المنفذ | Port**: 8000
- **الصورة | Image**: ai-agent-platform-dlplus (custom built)
- **الصحة | Health**: Auto health check enabled

### OpenWebUI (اختياري | Optional)
- **المنفذ | Port**: 3000
- **الصورة | Image**: ghcr.io/open-webui/open-webui:latest
- **البدء | Start**: `docker compose --profile openwebui up -d`

## 🌐 النشر | Deployment

### محلي | Local
```bash
./docker-start.sh start basic
```

### VPS/خادم | VPS/Server
```bash
ssh user@your-server.com
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
./docker-start.sh start full
```

## 📚 التوثيق | Documentation

- **الدليل الشامل | Full Guide**: [DOCKER-COMPOSE-GUIDE.md](DOCKER-COMPOSE-GUIDE.md)
- **README الرئيسي | Main README**: [README.md](README.md)
- **OpenWebUI**: [OPENWEBUI.md](OPENWEBUI.md)

## ⚡ نصائح سريعة | Quick Tips

1. استخدم `./docker-start.sh` للتفاعل السهل
   Use `./docker-start.sh` for easy interaction

2. أضف `--profile openwebui` لتشغيل OpenWebUI
   Add `--profile openwebui` to run OpenWebUI

3. راقب السجلات بـ `docker compose logs -f`
   Monitor logs with `docker compose logs -f`

4. نظف الموارد بـ `docker system prune`
   Clean up resources with `docker system prune`

---

**المشروع | Project**: AI Agent Platform
**الإصدار | Version**: 1.0.0
**آخر تحديث | Last Updated**: 2025-11-21
