# Quick Reference Guide
# دليل المرجع السريع

**AI-Agent-Platform Deployment Quick Reference**

---

## 🚀 One-Command Deployment

### Full Autonomous Deployment
```bash
bash autonomous-deploy.sh
```

### Smart Execution (All Steps)
```bash
bash smart-autonomous-execution.sh
```

---

## 📋 Manual Step-by-Step

### Step 1: Autonomous Deployment
```bash
bash autonomous-deploy.sh
```
**What it does:**
- Discovers models and agents
- Sets up environment
- Installs dependencies
- Runs health checks
- Generates DEPLOY.md

### Step 2: Agent Manager (Auto Mode)
```bash
bash ai-agent-manager.sh --auto --warm
```
**What it does:**
- Checks installation
- Manages services
- Warms up models
- Monitors health

### Step 3: Finalization
```bash
bash directive_finalize.sh
```
**What it does:**
- Runs finalization script
- Cleans up resources
- Confirms completion

---

## 🔧 Common Commands

### Check Status
```bash
# Check all services
bash check-status.sh

# Manual health check
curl http://localhost:8080
curl http://localhost:8000
curl http://localhost:11434
```

### View Documentation
```bash
# Deployment report
cat DEPLOY.md

# Full autonomous deployment guide
cat AUTONOMOUS_DEPLOYMENT.md

# Quick reference (this file)
cat QUICK_REFERENCE.md
```

### View Logs
```bash
# DL+ system logs
tail -f logs/dlplus.log

# Latest deployment log
ls -lt /tmp/autonomous-deploy-*.log | head -1 | xargs tail -f

# Latest execution log
ls -lt /tmp/smart-execution-*.log | head -1 | xargs tail -f
```

---

## 🤖 Model Commands

### List Models
```bash
ollama list
```

### Pull Models
```bash
ollama pull llama3
ollama pull qwen2.5
ollama pull mistral
```

### Test Model
```bash
ollama run llama3 "Hello, how are you?"
```

---

## 🧠 Agent Commands

### List Agents
```bash
ls -la dlplus/agents/
```

### Interactive Agent Manager
```bash
bash ai-agent-manager.sh
```

### Auto Mode
```bash
bash ai-agent-manager.sh --auto
```

### With Warm-up
```bash
bash ai-agent-manager.sh --auto --warm
```

---

## 🌐 Access URLs

| Service | URL | Description |
|---------|-----|-------------|
| Main Page | https://wasalstor-web.github.io/AI-Agent-Platform/ | GitHub Pages site |
| OpenWebUI | http://localhost:8080 | Web interface |
| Gateway API | http://localhost:8000 | API gateway |
| Ollama | http://localhost:11434 | Model service |
| Qdrant | http://localhost:6333 | Vector database |

---

## 🔐 Authentication

### JWT Token
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8
```

### API Key
```
sk-3720ccd539704717ba9af3453500fe3c
```

### Usage Examples
```bash
# Using JWT Token
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  http://localhost:8000/api/endpoint

# Using API Key
curl -H "X-API-Key: YOUR_API_KEY" \
  http://localhost:8080/webhook/chat
```

---

## 🛠️ Troubleshooting

### Services Not Responding
```bash
# Check processes
ps aux | grep -E "(ollama|openwebui|fastapi)"

# Check ports
lsof -i :8000,8080,11434,6333

# Restart
bash autonomous-deploy.sh
```

### Models Not Found
```bash
# Check Ollama
which ollama

# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull models
ollama pull llama3
```

### Import Errors
```bash
# Reinstall dependencies
pip install -r requirements.txt --force-reinstall
```

### Permission Errors
```bash
# Fix script permissions
chmod +x *.sh

# Fix directory permissions
chmod -R 755 dlplus/
```

---

## 📖 Documentation Files

| File | Description |
|------|-------------|
| `README.md` | Main project overview |
| `DEPLOY.md` | Generated deployment report |
| `AUTONOMOUS_DEPLOYMENT.md` | Complete deployment guide |
| `QUICK_REFERENCE.md` | This file - quick commands |
| `OPENWEBUI_INTEGRATION.md` | OpenWebUI integration guide |
| `IMPLEMENTATION_SUMMARY.md` | Implementation details |
| `FINALIZATION.md` | Finalization guide |

---

## 🎯 Quick Workflows

### First Time Setup
```bash
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
bash autonomous-deploy.sh
```

### Update and Redeploy
```bash
git pull origin main
bash autonomous-deploy.sh
```

### Development Workflow
```bash
# Make changes
vim your-file.py

# Test locally
python3 your-file.py

# Redeploy
bash autonomous-deploy.sh
```

### Production Deployment
```bash
# Full smart execution
bash smart-autonomous-execution.sh

# Verify
curl http://localhost:8080
cat DEPLOY.md
```

---

## 📊 System Information

### Discovered Models
- arabert (AraBERT - Arabic NLP)
- camelbert (CAMeLBERT - Arabic NLP)
- qwen_arabic (Qwen 2.5 Arabic - Multilingual)
- llama-3-8b (LLaMA 3 - General Purpose)
- deepseek (DeepSeek Coder - Code Generation)
- mistral (Mistral 7B - Multilingual)
- qwen-2.5-arabic (Qwen 2.5 - Arabic Specialized)

### Discovered Agents
- base_agent (Base agent functionality)
- code_generator_agent (Code generation)
- web_retrieval_agent (Web information retrieval)

---

## 🔄 Maintenance

### Daily
```bash
# Check health
bash check-status.sh
```

### Weekly
```bash
# Update models
ollama pull llama3
ollama pull qwen2.5

# Update code
git pull origin main
```

### Monthly
```bash
# Full redeploy
bash autonomous-deploy.sh

# Review logs
tail -100 logs/dlplus.log
```

---

## 📞 Support

- **GitHub Issues:** https://github.com/wasalstor-web/AI-Agent-Platform/issues
- **Documentation:** https://wasalstor-web.github.io/AI-Agent-Platform/
- **Repository:** https://github.com/wasalstor-web/AI-Agent-Platform

---

## ✅ Quick Checklist

After deployment, verify:
- [ ] `autonomous-deploy.sh` completed successfully
- [ ] `DEPLOY.md` was generated
- [ ] Models discovered (check DEPLOY.md)
- [ ] Agents discovered (check DEPLOY.md)
- [ ] Services responding (run health checks)
- [ ] OpenWebUI accessible at http://localhost:8080
- [ ] API Gateway accessible at http://localhost:8000

---

**Last Updated:** 2025-10-22  
**Version:** 1.0.0  
**Status:** ✅ Production Ready
