# Autonomous Deployment Guide
# دليل النشر الذاتي

**نظام النشر الذاتي الكامل لمنصة وكلاء الذكاء الصناعي**  
**Full Autonomous Deployment System for AI-Agent-Platform**

---

## 📋 نظرة عامة / Overview

This autonomous deployment system is designed to automatically:
- ✅ Discover and configure all AI models
- ✅ Detect and initialize all AI agents
- ✅ Setup the complete runtime environment
- ✅ Deploy Open WebUI with model integration
- ✅ Generate comprehensive deployment documentation
- ✅ Perform health checks on all services

نظام النشر الذاتي مصمم ليقوم تلقائيًا بـ:
- ✅ اكتشاف وتكوين جميع نماذج الذكاء الصناعي
- ✅ كشف وتهيئة جميع الوكلاء
- ✅ إعداد بيئة التشغيل الكاملة
- ✅ نشر Open WebUI مع تكامل النماذج
- ✅ توليد وثائق النشر الشاملة
- ✅ إجراء فحوصات الصحة لجميع الخدمات

---

## 🚀 Quick Start / البدء السريع

### الطريقة الأولى: النشر الذاتي الكامل / Method 1: Full Autonomous Deployment

```bash
# Clone the repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# Run autonomous deployment
bash autonomous-deploy.sh
```

### الطريقة الثانية: مع إدارة الوكلاء / Method 2: With Agent Manager

```bash
# Run autonomous deployment first
bash autonomous-deploy.sh

# Then run agent manager in auto mode with warm-up
bash ai-agent-manager.sh --auto --warm
```

### الطريقة الثالثة: خطوة بخطوة / Method 3: Step by Step

```bash
# 1. Smart deployment
bash deploy-smart.sh

# 2. Agent manager setup
bash ai-agent-manager.sh --auto

# 3. Finalization
bash directive_finalize.sh
```

---

## 🧠 System Components / مكونات النظام

### 1. Autonomous Deploy Script (autonomous-deploy.sh)

**Purpose:** المنسق الرئيسي للنشر الذاتي  
**Main deployment orchestrator**

**Features:**
- Automatic project structure analysis
- Model discovery from configuration files
- Agent detection from dlplus/agents
- Environment setup and dependency installation
- Service health monitoring
- Deployment report generation

**Usage:**
```bash
bash autonomous-deploy.sh
```

**Output:**
- Deployment log: `/tmp/autonomous-deploy-[timestamp].log`
- Deployment report: `DEPLOY.md`

### 2. AI Agent Manager (ai-agent-manager.sh)

**Purpose:** إدارة الوكلاء والخدمات  
**Agent and service management**

**Features:**
- Installation status checking
- Smart dependency installation
- Service management (start/stop/restart)
- Model warm-up functionality
- Health monitoring

**Usage:**
```bash
# Interactive mode
bash ai-agent-manager.sh

# Automatic mode
bash ai-agent-manager.sh --auto

# With model warm-up
bash ai-agent-manager.sh --auto --warm

# Show help
bash ai-agent-manager.sh --help
```

### 3. Deploy Smart (deploy-smart.sh)

**Purpose:** نشر ذكي مع تكوين النطاق  
**Smart deployment with domain configuration**

**Features:**
- Domain and email configuration
- SSL certificate setup
- Nginx configuration

**Usage:**
```bash
bash deploy-smart.sh
# Follow prompts for domain and email
```

### 4. Directive Finalize (directive_finalize.sh)

**Purpose:** توجيه إداري لإنهاء المشروع  
**Administrative directive for project finalization**

**Features:**
- Bilingual administrative messages
- Automatic finalization execution
- Resource cleanup

**Usage:**
```bash
bash directive_finalize.sh
```

---

## 🤖 Discovered Models / النماذج المكتشفة

The autonomous deployment automatically discovers models from:

1. **dlplus/config/models_config.py**
2. **OPENWEBUI_INTEGRATION.md**

### Currently Detected Models:

| Model ID | Name | Provider | Type |
|----------|------|----------|------|
| arabert | AraBERT | AUB | Arabic NLP |
| camelbert | CAMeLBERT | CAMeL-Lab | Arabic NLP |
| qwen_arabic | Qwen 2.5 Arabic | Alibaba | Multilingual |
| llama-3-8b | LLaMA 3 8B | Meta | General Purpose |
| deepseek | DeepSeek Coder | DeepSeek | Code Generation |
| mistral | Mistral 7B | Mistral AI | Multilingual |
| qwen-2.5-arabic | Qwen 2.5 Arabic | Alibaba | Arabic Specialized |

---

## 🧠 Discovered Agents / الوكلاء المكتشفين

The autonomous deployment automatically discovers agents from:

1. **dlplus/agents/** directory

### Currently Detected Agents:

| Agent | File | Purpose |
|-------|------|---------|
| base_agent | base_agent.py | Base agent functionality |
| code_generator_agent | code_generator_agent.py | Code generation |
| web_retrieval_agent | web_retrieval_agent.py | Web information retrieval |

---

## 🌐 Service Endpoints / نقاط الخدمة

After deployment, the following services should be available:

| Service | Port | URL | Status Check |
|---------|------|-----|--------------|
| Gateway API | 8000 | http://localhost:8000 | `curl http://localhost:8000/health` |
| Open WebUI | 8080 | http://localhost:8080 | `curl http://localhost:8080` |
| Ollama | 11434 | http://localhost:11434 | `curl http://localhost:11434` |
| Qdrant | 6333 | http://localhost:6333 | `curl http://localhost:6333` |

### Web Interfaces:

- **Main Page:** https://wasalstor-web.github.io/AI-Agent-Platform/
- **OpenWebUI:** http://localhost:8080
- **API Documentation:** http://localhost:8000/docs

---

## 🔐 Authentication / المصادقة

### JWT Token
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8
```

### API Key
```
sk-3720ccd539704717ba9af3453500fe3c
```

**Usage Example:**
```bash
# Using JWT Token
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" http://localhost:8000/api/endpoint

# Using API Key
curl -H "X-API-Key: YOUR_API_KEY" http://localhost:8080/webhook/chat
```

**⚠️ Security Note:** These credentials are stored in `.env` file and should NOT be committed to the repository.

---

## 📊 Deployment Workflow / سير عمل النشر

```
┌─────────────────────────────────────────────────────────┐
│                Autonomous Deployment                     │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  Step 1: Project Structure Analysis                      │
│  - Detect directories (models/, agents/, scripts/)       │
│  - Find deployment scripts                               │
│  - Verify permissions                                    │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  Step 2: Model Discovery                                 │
│  - Parse models_config.py                                │
│  - Extract from OPENWEBUI_INTEGRATION.md                 │
│  - Build model registry                                  │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  Step 3: Agent Discovery                                 │
│  - Scan dlplus/agents directory                          │
│  - Detect agent files (*_agent.py)                       │
│  - Register available agents                             │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  Step 4: Environment Setup                               │
│  - Load .env configuration                               │
│  - Install Python dependencies                           │
│  - Setup service directories                             │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  Step 5: Health Checks                                   │
│  - Check Gateway (port 8000)                             │
│  - Check OpenWebUI (port 8080)                           │
│  - Check Ollama (port 11434)                             │
│  - Check Qdrant (port 6333)                              │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  Step 6: Documentation Generation                        │
│  - Generate DEPLOY.md                                    │
│  - Create deployment log                                 │
│  - Output final status                                   │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
                    ✅ DEPLOYMENT COMPLETE
```

---

## 🔧 Configuration / التكوين

### Environment Variables (.env)

Key configuration variables:

```bash
# System Information
SYSTEM_NAME="DL+ Unified Arabic Intelligence System"
SYSTEM_VERSION="1.0.0"

# FastAPI Configuration
FASTAPI_HOST=0.0.0.0
FASTAPI_PORT=8000
FASTAPI_SECRET_KEY=sk-3720ccd539704717ba9af3453500fe3c

# OpenWebUI Configuration
OPENWEBUI_ENABLED=true
OPENWEBUI_PORT=3000
OPENWEBUI_HOST=0.0.0.0
OPENWEBUI_JWT_TOKEN=<your-jwt-token>
OPENWEBUI_API_KEY=<your-api-key>

# Webhook Configuration
WEBHOOK_BASE_URL=https://wasalstor-web.github.io/AI-Agent-Platform

# AI Models Configuration
MODELS_ENABLED=true
DEFAULT_MODEL=llama3
MODELS_PATH=./models

# Logging
LOG_LEVEL=INFO
LOG_FILE=./logs/dlplus.log
```

---

## 🛠️ Troubleshooting / استكشاف الأخطاء

### Problem: Services Not Responding

**الحل / Solution:**

```bash
# Check if services are running
ps aux | grep -E "(ollama|openwebui|fastapi)"

# Check ports
lsof -i :8000,8080,11434,6333

# Restart deployment
bash autonomous-deploy.sh
```

### Problem: Models Not Found

**الحل / Solution:**

```bash
# Check if Ollama is installed
which ollama

# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull models
ollama pull llama3
ollama pull qwen2.5
```

### Problem: Import Errors

**الحل / Solution:**

```bash
# Reinstall dependencies
pip install -r requirements.txt --force-reinstall

# Check Python version
python3 --version  # Should be 3.8+
```

### Problem: Permission Denied

**الحل / Solution:**

```bash
# Make scripts executable
chmod +x *.sh

# Fix directory permissions
chmod -R 755 dlplus/
```

---

## 📖 Documentation References / المراجع

- [Main README](README.md) - Project overview
- [DEPLOY.md](DEPLOY.md) - Generated deployment report
- [OPENWEBUI_INTEGRATION.md](OPENWEBUI_INTEGRATION.md) - OpenWebUI integration
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Implementation details
- [FINALIZATION.md](FINALIZATION.md) - Finalization guide

---

## 🧪 Testing / الاختبار

### Test Autonomous Deployment

```bash
# Run deployment
bash autonomous-deploy.sh

# Check generated files
ls -la DEPLOY.md
cat DEPLOY.md

# Check logs
tail -f /tmp/autonomous-deploy-*.log
```

### Test Agent Manager

```bash
# Test help
bash ai-agent-manager.sh --help

# Test auto mode
bash ai-agent-manager.sh --auto

# Test with warm-up
bash ai-agent-manager.sh --auto --warm
```

### Test Service Health

```bash
# Check all services
for port in 8000 8080 11434 6333; do
    echo "Testing port $port..."
    curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:$port
done
```

---

## 🎯 Usage Examples / أمثلة الاستخدام

### Example 1: First Time Deployment

```bash
# Clone and deploy
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
bash autonomous-deploy.sh

# Expected output:
# ✅ AI-Agent-Platform Deployed Successfully
# Models Detected: [arabert camelbert qwen_arabic ...]
# Agents Loaded: [base_agent code_generator_agent ...]
# WebUI: http://localhost:8080
```

### Example 2: CI/CD Integration

```yaml
# .github/workflows/deploy.yml
name: Autonomous Deployment

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Run Autonomous Deploy
        run: bash autonomous-deploy.sh
      
      - name: Upload Deployment Report
        uses: actions/upload-artifact@v2
        with:
          name: deployment-report
          path: DEPLOY.md
```

### Example 3: Docker Integration

```bash
# Run in Docker
docker run -v $(pwd):/app -w /app ubuntu:22.04 bash autonomous-deploy.sh
```

---

## 🔄 Update and Maintenance / التحديث والصيانة

### Regular Updates

```bash
# Pull latest changes
git pull origin main

# Re-run deployment
bash autonomous-deploy.sh

# Check for new models/agents
bash ai-agent-manager.sh --auto
```

### Model Updates

```bash
# Update Ollama models
ollama pull llama3
ollama pull qwen2.5

# Warm up new models
bash ai-agent-manager.sh --warm
```

---

## 📞 Support / الدعم

### For Issues and Questions:

- **GitHub Issues:** https://github.com/wasalstor-web/AI-Agent-Platform/issues
- **Documentation:** https://wasalstor-web.github.io/AI-Agent-Platform/
- **Main Page:** https://wasalstor-web.github.io/AI-Agent-Platform/

---

## 📄 License / الترخيص

This project is part of the AI-Agent-Platform ecosystem.

**المؤسس / Founder:** خليف 'ذيبان' العنزي  
**الموقع / Location:** القصيم – بريدة – المملكة العربية السعودية

---

## ✅ Summary / الملخص

The autonomous deployment system provides:

✅ **Zero-configuration deployment** - No manual setup required  
✅ **Automatic discovery** - Models and agents detected automatically  
✅ **Comprehensive health checks** - All services monitored  
✅ **Detailed documentation** - Complete deployment reports  
✅ **Bilingual support** - Arabic and English throughout  
✅ **Error handling** - Robust failure recovery  
✅ **Extensible design** - Easy to add new models/agents

**Status:** ✅ Production Ready  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0
