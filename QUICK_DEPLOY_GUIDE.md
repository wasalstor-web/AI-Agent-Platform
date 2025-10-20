# Quick Deploy OpenWebUI - Instant Deployment Guide
# دليل النشر الفوري لـ OpenWebUI

## 🚀 Overview | نظرة عامة

This guide provides instant deployment of OpenWebUI with DL+ Backend in a secure, production-ready manner.

هذا الدليل يوفر نشراً فورياً لـ OpenWebUI مع DL+ Backend بطريقة آمنة وجاهزة للإنتاج.

## ⚡ Quick Start | البدء السريع

### 1. Prerequisites | المتطلبات الأساسية

- Docker installed | Docker مثبت
- Python 3.8+ installed | Python 3.8+ مثبت
- OpenSSL for key generation | OpenSSL لتوليد المفاتيح

### 2. Configuration | التكوين

**Step 1: Create configuration file | الخطوة 1: إنشاء ملف التكوين**

```bash
# Copy the example configuration
cp .env.instant-deploy.example .env.instant-deploy
```

**Step 2: Generate secure keys | الخطوة 2: توليد مفاتيح آمنة**

```bash
# Generate API Key
echo "DLPLUS_API_KEY=sk-$(openssl rand -hex 32)" >> .env.instant-deploy

# Generate Secret Key
echo "WEBUI_SECRET_KEY=$(openssl rand -hex 32)" >> .env.instant-deploy

# Generate JWT Token (or use your existing token)
# For demo purposes, you can generate a simple token:
echo "DLPLUS_JWT_TOKEN=$(openssl rand -hex 64)" >> .env.instant-deploy
```

**Step 3: Edit configuration | الخطوة 3: تعديل التكوين**

Edit `.env.instant-deploy` with your preferred settings:

```bash
nano .env.instant-deploy
# or
vim .env.instant-deploy
```

### 3. Run Deployment | تشغيل النشر

```bash
./quick-deploy-openwebui.sh
```

The script will:
1. ✅ Load your secure configuration
2. ✅ Start DL+ Backend (if available)
3. ✅ Pull OpenWebUI Docker image
4. ✅ Clean up old containers
5. ✅ Deploy OpenWebUI with your configuration
6. ✅ Create an access dashboard

## 📋 Configuration Options | خيارات التكوين

### Environment Variables | متغيرات البيئة

| Variable | Description | Default |
|----------|-------------|---------|
| `DLPLUS_API_KEY` | API key for DL+ Backend | *Required* |
| `DLPLUS_JWT_TOKEN` | JWT token for authentication | *Required* |
| `WEBUI_SECRET_KEY` | Secret key for OpenWebUI | *Required* |
| `DLPLUS_PORT` | DL+ Backend port | `8000` |
| `OPENWEBUI_PORT` | OpenWebUI port | `3000` |
| `OPENWEBUI_VERSION` | Docker image version | `main` |
| `ENABLE_SIGNUP` | Allow user signups | `true` |
| `ENABLE_API_KEY` | Enable API key support | `true` |
| `OPENAI_API_BASE_URL` | API base URL | `http://host.docker.internal:8000/api` |

## 🔒 Security Best Practices | أفضل ممارسات الأمان

### ✅ DO | افعل

- ✅ Generate unique, random keys for each deployment
- ✅ Keep `.env.instant-deploy` file secure and private
- ✅ Use strong, complex keys (32+ characters)
- ✅ Rotate keys regularly in production
- ✅ Restrict file permissions: `chmod 600 .env.instant-deploy`

### ❌ DON'T | لا تفعل

- ❌ **NEVER** commit `.env.instant-deploy` to git
- ❌ Don't share your configuration file
- ❌ Don't use default or example keys in production
- ❌ Don't expose your keys in logs or screenshots

## 🌐 Access Points | نقاط الوصول

After deployment, you can access:

### OpenWebUI
- **URL:** `http://localhost:3000`
- **First user becomes admin**
- **Create account and start chatting**

### DL+ Backend API
- **URL:** `http://localhost:8000`
- **API Docs:** `http://localhost:8000/api/docs`
- **Health Check:** `http://localhost:8000/api/health`

### Dashboard
- **File:** `~/openwebui-dashboard.html`
- Open in browser for quick access to all services

## 🛠️ Management Commands | أوامر الإدارة

### View Logs | عرض السجلات
```bash
# OpenWebUI logs
docker logs -f open-webui

# DL+ Backend logs
tail -f /tmp/dlplus.log
```

### Container Management | إدارة الحاوية
```bash
# Restart
docker restart open-webui

# Stop
docker stop open-webui

# Start
docker start open-webui

# Remove
docker stop open-webui && docker rm open-webui

# Check status
docker ps | grep open-webui
```

### Update OpenWebUI | تحديث OpenWebUI
```bash
# Pull latest image
docker pull ghcr.io/open-webui/open-webui:main

# Restart with new image
docker stop open-webui
docker rm open-webui
./quick-deploy-openwebui.sh
```

## 🤖 Available AI Models | النماذج المتاحة

The platform integrates 6 AI models:

1. **🇸🇦 AraBERT** - Arabic language processing
2. **🇨🇳 Qwen 2.5** - Arabic text generation
3. **🦙 LLaMA 3** - General purpose AI
4. **💻 DeepSeek** - Code generation
5. **⚡ Mistral** - Multilingual support
6. **🐫 CAMeLBERT** - Named entity recognition

## 🔧 Troubleshooting | استكشاف الأخطاء

### Issue: Port already in use | المنفذ مستخدم بالفعل

```bash
# Find process using port 3000
sudo lsof -i :3000

# Kill the process
sudo kill -9 <PID>

# Or use different port in .env.instant-deploy
OPENWEBUI_PORT=3001
```

### Issue: Docker not running | Docker لا يعمل

```bash
# Start Docker service
sudo systemctl start docker

# Enable Docker on boot
sudo systemctl enable docker
```

### Issue: DL+ Backend not starting | DL+ Backend لا يبدأ

```bash
# Check logs
tail -f /tmp/dlplus.log

# Try starting manually
./start-dlplus.sh

# Check if port is available
netstat -tuln | grep 8000
```

### Issue: Configuration not loaded | التكوين لم يُحمل

```bash
# Verify file exists
ls -la .env.instant-deploy

# Check permissions
chmod 600 .env.instant-deploy

# Verify variables are set
source .env.instant-deploy
echo $DLPLUS_API_KEY
```

## 📊 Architecture | البنية المعمارية

```
┌─────────────────────────────────────────────────────────────┐
│                     Quick Deploy Script                     │
│                   quick-deploy-openwebui.sh                 │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ├──────────────────────────────────────────────┐
                 │                                              │
        ┌────────▼────────┐                          ┌─────────▼────────┐
        │  DL+ Backend    │                          │    OpenWebUI     │
        │  (Port 8000)    │◄─────────────────────────│   (Port 3000)    │
        │                 │    API Integration        │                  │
        │  FastAPI Server │                          │  Docker Container│
        └─────────────────┘                          └──────────────────┘
                 │
                 │
        ┌────────▼────────┐
        │   AI Models     │
        │  - AraBERT      │
        │  - Qwen         │
        │  - LLaMA 3      │
        │  - DeepSeek     │
        │  - Mistral      │
        │  - CAMeLBERT    │
        └─────────────────┘
```

## 🎯 Use Cases | حالات الاستخدام

### Development | التطوير
- Quick local testing of AI models
- Rapid prototyping of AI applications
- Testing different model configurations

### Production | الإنتاج
- Deploy on VPS or cloud server
- Set up custom domain and SSL
- Configure reverse proxy (Nginx)

### Demo | العرض التوضيحي
- Showcase AI capabilities
- Present to clients or stakeholders
- Interactive demonstrations

## 🔄 Comparison with Other Scripts | المقارنة مع السكريبتات الأخرى

| Feature | `quick-deploy-openwebui.sh` | `setup-openwebui.sh` | `start-dlplus.sh` |
|---------|---------------------------|---------------------|-------------------|
| OpenWebUI Deployment | ✅ | ✅ | ❌ |
| DL+ Backend | ✅ | ❌ | ✅ |
| Integrated Setup | ✅ | ❌ | ❌ |
| Secure Key Management | ✅ | ⚠️ | ⚠️ |
| Dashboard Creation | ✅ | ❌ | ❌ |
| One-Command Deploy | ✅ | ❌ | ❌ |

## 📚 Additional Resources | موارد إضافية

- **[OpenWebUI Documentation](OPENWEBUI.md)**
- **[DL+ System Documentation](DLPLUS_README.md)**
- **[Deployment Guide](DEPLOYMENT.md)**
- **[API Reference](http://localhost:8000/api/docs)** (after deployment)

## 🆘 Support | الدعم

If you encounter issues:

1. Check the troubleshooting section above
2. Review logs: `docker logs open-webui` and `tail -f /tmp/dlplus.log`
3. Verify configuration in `.env.instant-deploy`
4. Check that all prerequisites are installed
5. Open an issue on GitHub with:
   - Error messages (without sensitive data)
   - System information
   - Steps to reproduce

## 📝 License | الترخيص

AI-Agent-Platform © 2025

---

**Security Note:** This deployment script follows security best practices by using environment variables for sensitive data. Never commit actual credentials to version control.

**ملاحظة أمنية:** يتبع سكريبت النشر هذا أفضل ممارسات الأمان باستخدام متغيرات البيئة للبيانات الحساسة. لا تقم أبداً برفع بيانات الاعتماد الفعلية إلى نظام التحكم في الإصدارات.
