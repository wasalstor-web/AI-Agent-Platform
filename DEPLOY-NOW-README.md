# DEPLOY-NOW.sh - Quick Deployment Guide
# دليل النشر السريع باستخدام DEPLOY-NOW.sh

## 🚀 Overview / نظرة عامة

`DEPLOY-NOW.sh` is a quick deployment script for the AI Agent Platform that provides instant access to APIs, web interfaces, and AI models. It connects to Hostinger servers on Domain 2 (mbst.space) and supports premium request handling.

`DEPLOY-NOW.sh` هو سكريبت نشر سريع لمنصة الوكيل الذكي يوفر وصولاً فورياً إلى واجهات برمجة التطبيقات والواجهات الويب ونماذج الذكاء الاصطناعي. يتصل بخوادم Hostinger على الدومين الثاني (mbst.space) ويدعم معالجة الطلبات المميزة.

## ✨ Features / المميزات

### 🌐 Three Web Interfaces / ثلاث واجهات ويب

1. **Flask API Server** (Port 5000)
   - Health check endpoint
   - API status monitoring
   - Command processing
   - Model listing

2. **DL+ Intelligence System** (Port 8000)
   - Advanced AI system with FastAPI
   - Interactive API documentation
   - Arabic language processing
   - Context analysis

3. **Web Dashboard** (Port 8080)
   - User interface for AI Agent Platform
   - Interactive chat interface
   - Model selection
   - Request history

### 📋 Eight AI Models / ثمانية نماذج ذكاء اصطناعي

1. **GPT-3.5 Turbo** - OpenAI (General Purpose)
2. **GPT-4** - OpenAI (Advanced General Purpose)
3. **Claude 3** - Anthropic (General Purpose)
4. **LLaMA 3** - Meta (Open Source General)
5. **Qwen Arabic** - Alibaba (Arabic Language Model)
6. **AraBERT** - AUB (Arabic Language Model)
7. **Mistral** - Mistral AI (General Purpose)
8. **DeepSeek Coder** - DeepSeek (Code Generation)

### 🧪 API Endpoints Testing / اختبار نقاط API

The script automatically tests all API endpoints to ensure they are working correctly:
- Flask API health check
- Flask API status
- Flask API models listing
- DL+ system health check
- DL+ system status

## 📖 Usage / الاستخدام

### Basic Commands / الأوامر الأساسية

```bash
# Full deployment (all features)
# النشر الكامل (جميع المميزات)
bash DEPLOY-NOW.sh

# API-only mode (commit 670b146)
# وضع الوصول للـ API فقط
bash DEPLOY-NOW.sh --api

# With premium features
# مع المميزات المتقدمة
bash DEPLOY-NOW.sh --premium

# Show help
# عرض المساعدة
bash DEPLOY-NOW.sh --help
```

### Quick Start / البدء السريع

```bash
# 1. Clone the repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# 2. Checkout the deployment branch
git checkout copilot/add-deployment-scripts

# 3. Run the deployment script
bash DEPLOY-NOW.sh --api
```

## 🔧 Configuration / الإعدادات

### Environment Variables / متغيرات البيئة

```bash
# Hostinger Domain 2 (default: mbst.space)
export HOSTINGER_DOMAIN_2="your-domain.com"

# Hostinger API Key (for remote deployment)
export HOSTINGER_API_KEY="your-api-key-here"

# Custom ports (optional)
export API_PORT=5000
export DLPLUS_PORT=8000
export WEB_PORT=8080
```

### Domain 2 Configuration / تكوين الدومين الثاني

The script connects to **mbst.space** (Domain 2) by default. To use a different domain:

```bash
HOSTINGER_DOMAIN_2="yourdomain.com" bash DEPLOY-NOW.sh
```

## 📊 What Gets Deployed / ما يتم نشره

### Services Started / الخدمات التي تبدأ

1. **Flask API Server**
   - PID file: `/tmp/deploy-now-api.pid`
   - Log file: `/tmp/flask-api.log`
   - URL: `http://localhost:5000`

2. **DL+ Intelligence System**
   - PID file: `/tmp/deploy-now-dlplus.pid`
   - Log file: `/tmp/dlplus.log`
   - URL: `http://localhost:8000`

3. **Web Dashboard**
   - PID file: `/tmp/deploy-now-web.pid`
   - Log file: `/tmp/web-server.log`
   - URL: `http://localhost:8080/index.html`

## 🛑 Stopping Services / إيقاف الخدمات

### Stop All Services / إيقاف جميع الخدمات

```bash
# Method 1: Using PID files
kill $(cat /tmp/deploy-now-*.pid 2>/dev/null)

# Method 2: Press Ctrl+C if running in foreground
# Ctrl+C إذا كان يعمل في المقدمة
```

### Stop Individual Services / إيقاف خدمات فردية

```bash
# Stop Flask API
kill $(cat /tmp/deploy-now-api.pid)

# Stop DL+ System
kill $(cat /tmp/deploy-now-dlplus.pid)

# Stop Web Dashboard
kill $(cat /tmp/deploy-now-web.pid)
```

## 🔍 Monitoring / المراقبة

### View Logs / عرض السجلات

```bash
# Flask API logs
tail -f /tmp/flask-api.log

# DL+ System logs
tail -f /tmp/dlplus.log

# Web Server logs
tail -f /tmp/web-server.log
```

### Check Service Status / فحص حالة الخدمات

```bash
# Check if services are running
ps aux | grep -E "python3.*(server.py|simple_server.py|http.server)"

# Check ports
lsof -i :5000  # Flask API
lsof -i :8000  # DL+ System
lsof -i :8080  # Web Dashboard
```

## 🧪 Testing Endpoints / اختبار النقاط

### Flask API Endpoints

```bash
# Health check
curl http://localhost:5000/api/health

# API status
curl http://localhost:5000/api/status

# List models
curl http://localhost:5000/api/models

# Process command
curl -X POST http://localhost:5000/api/process \
  -H "Content-Type: application/json" \
  -d '{"command":"Hello","context":{"model":"gpt-3.5-turbo"}}'
```

### DL+ System Endpoints

```bash
# Health check
curl http://localhost:8000/api/health

# System status
curl http://localhost:8000/api/status

# Process request
curl -X POST http://localhost:8000/api/process \
  -H "Content-Type: application/json" \
  -d '{"command":"Test request"}'

# Interactive docs
open http://localhost:8000/docs
```

## 💎 Premium Features / المميزات المتقدمة

When using the `--premium` flag, you get:

عند استخدام علم `--premium`، تحصل على:

- ✨ Enhanced API rate limits / حدود معززة لمعدل API
- ⚡ Priority request processing / معالجة الطلبات ذات الأولوية
- 📊 Advanced analytics and logging / تحليلات وسجلات متقدمة
- 🎯 Custom model fine-tuning support / دعم الضبط الدقيق للنماذج المخصصة

```bash
bash DEPLOY-NOW.sh --api --premium
```

## 🔐 Security / الأمان

### Best Practices / أفضل الممارسات

1. **API Keys**: Never commit API keys to the repository
   - Use environment variables
   - Store in `.env` file (add to `.gitignore`)

2. **Firewall**: Configure firewall rules for production
   ```bash
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   ```

3. **HTTPS**: Use SSL/TLS certificates for production deployment
   - Let's Encrypt for free certificates
   - Configure Nginx as reverse proxy

## 📚 API Documentation / توثيق API

### Interactive Documentation / التوثيق التفاعلي

- **DL+ System**: `http://localhost:8000/docs`
- **Alternative (ReDoc)**: `http://localhost:8000/redoc`

### API Reference / مرجع API

See the full API reference in:
- `/api/server.py` - Flask API endpoints
- `/dlplus/simple_server.py` - DL+ system endpoints

## 🐛 Troubleshooting / حل المشاكل

### Common Issues / المشاكل الشائعة

#### Port Already in Use / المنفذ مستخدم بالفعل

```bash
# Find and kill process using the port
lsof -ti:5000 | xargs kill -9
```

#### Missing Dependencies / المكتبات المفقودة

```bash
# Install required packages
pip3 install flask flask-cors fastapi uvicorn
```

#### Permission Denied / تم رفض الإذن

```bash
# Make script executable
chmod +x DEPLOY-NOW.sh
```

#### Service Won't Start / الخدمة لا تبدأ

```bash
# Check logs for errors
cat /tmp/flask-api.log
cat /tmp/dlplus.log
cat /tmp/web-server.log
```

## 🌐 Hostinger Deployment / النشر على Hostinger

### Domain 2 (mbst.space)

The script is configured to work with Hostinger's Domain 2 (mbst.space). To deploy:

1. Set up your Hostinger API key:
   ```bash
   export HOSTINGER_API_KEY="your-api-key"
   ```

2. Run the deployment:
   ```bash
   bash DEPLOY-NOW.sh
   ```

3. The script will:
   - Test connection to mbst.space
   - Deploy services to Hostinger
   - Configure domain routing

## 📝 Commit Reference / مرجع الإصدار

**commit 670b146**: للوصول لخادم API والواجهات والنماذج فقط

This commit introduced the `--api` flag for quick API access:

```bash
bash DEPLOY-NOW.sh --api
```

Provides:
- 🌐 Access to 3 web interfaces
- 📋 View 8 AI models
- 🧪 Test API endpoints
- 🚀 Start local API server

## 🤝 Contributing / المساهمة

To contribute to this project:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `bash DEPLOY-NOW.sh --api`
5. Submit a pull request

## 📄 License / الترخيص

See the main project README for license information.

## 👤 Author / المؤلف

**خليف "ذيبان" العنزي**
- Location: القصيم – بريدة – المملكة العربية السعودية

## 🔗 Links / الروابط

- Repository: https://github.com/wasalstor-web/AI-Agent-Platform
- Domain 2: mbst.space
- Documentation: See README.md

---

## 🆘 Support / الدعم

For issues or questions:
1. Check the troubleshooting section above
2. Review log files in `/tmp/`
3. Open an issue on GitHub
4. Consult the main project documentation

---

**Last Updated**: 2025-11-06
**Version**: 1.0.0
