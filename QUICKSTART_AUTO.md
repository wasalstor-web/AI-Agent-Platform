# Quick Start Guide - Automated OpenWebUI Setup
# دليل البدء السريع - إعداد OpenWebUI التلقائي

**المؤسس:** خليف 'ذيبان' العنزي  
**الموقع:** القصيم – بريدة – المملكة العربية السعودية

---

## 🚀 Zero-Configuration Installation

### Single Command Setup

```bash
sudo bash auto-setup-openwebui.sh
```

**That's it!** No configuration files to edit, no manual steps required.

---

## ⏱️ Installation Time

| Network Speed | Estimated Time |
|--------------|----------------|
| Fast (100+ Mbps) | 15-20 minutes |
| Medium (10-50 Mbps) | 30-45 minutes |
| Slow (<10 Mbps) | 60+ minutes |

Most time is spent downloading AI models (10-30 GB).

---

## ✅ What Gets Installed

### Services
- ✅ Docker & Docker Compose
- ✅ Ollama (AI Model Server)
- ✅ OpenWebUI (Web Interface)
- ✅ DL+ Intelligence System
- ✅ Agent Integration Layer

### AI Models
- ✅ LLaMA 3 8B (Meta)
- ✅ Qwen 2.5 7B (Alibaba)
- ✅ Mistral 7B (Mistral AI)
- ✅ DeepSeek Coder 6.7B (DeepSeek)
- ✅ Phi-3 Mini (Microsoft)

### DL+ Agents
- ✅ WebRetrievalAgent (Web search)
- ✅ CodeGeneratorAgent (Code generation)
- ✅ BaseAgent (Custom agent foundation)

### Configuration
- ✅ All API keys configured
- ✅ JWT authentication enabled
- ✅ Systemd service created
- ✅ Auto-start on boot configured

---

## 🌐 Access After Installation

### Main Services

| Service | URL | Purpose |
|---------|-----|---------|
| **OpenWebUI** | http://localhost:3000 | Chat interface |
| **DL+ API** | http://localhost:8000 | Intelligence core |
| **Integration API** | http://localhost:8080 | Webhook handler |

### Documentation

| Documentation | URL |
|--------------|-----|
| OpenWebUI API Docs | http://localhost:8080/api/docs |
| DL+ API Docs | http://localhost:8000/api/docs |

---

## 🎯 Quick Tests

### Test Chat Endpoint

```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello!", "model": "llama-3-8b"}'
```

### List Available Models

```bash
curl http://localhost:8080/api/models | jq
```

### List DL+ Agents

```bash
curl http://localhost:8080/api/agents | jq
```

### Test Web Search Agent

```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{"message": "search for AI", "model": "llama-3-8b"}'
```

### Test Code Generation Agent

```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{"message": "write Python code to sort a list", "model": "deepseek-coder"}'
```

---

## 🔄 Service Management

### Start All Services

```bash
# Using systemd (recommended)
sudo systemctl start ai-agent-platform

# Or using script
./start-all-services.sh
```

### Stop All Services

```bash
sudo systemctl stop ai-agent-platform
```

### Check Status

```bash
sudo systemctl status ai-agent-platform
```

### Enable Auto-Start on Boot

```bash
sudo systemctl enable ai-agent-platform
```

### View Logs

```bash
# DL+ System logs
tail -f logs/dlplus.log

# Integration server logs
tail -f logs/integration.log

# OpenWebUI logs
cd /opt/ai-agent-platform/openwebui
docker compose logs -f
```

---

## 🎓 Using OpenWebUI

### First Time Setup

1. **Open Browser:** Navigate to http://localhost:3000
2. **Create Account:** First user becomes admin automatically
3. **Select Model:** Choose from available models
4. **Start Chatting:** Begin using AI models

### Using DL+ Agents in Chat

#### Web Search
Simply include "search" in your message:
```
search for quantum computing
```

#### Code Generation
Include "code" or "write" in your message:
```
write Python code to calculate factorial
```

#### General Chat
Any other message will use general conversation:
```
Hello, how can you help me?
```

### Agent Detection Keywords

| Agent | English Keywords | Arabic Keywords |
|-------|-----------------|-----------------|
| **WebRetrievalAgent** | search, find, lookup, what is | بحث, ابحث, اعثر, ما هو |
| **CodeGeneratorAgent** | code, write, program, function | كود, برمجة, برنامج, اكتب |

---

## 🛠️ Troubleshooting

### Issue: Services won't start

```bash
# Check Docker
sudo systemctl status docker
sudo systemctl start docker

# Check Ollama
sudo systemctl status ollama
sudo systemctl start ollama
```

### Issue: Port already in use

```bash
# Check what's using the port
sudo lsof -i :3000  # OpenWebUI
sudo lsof -i :8000  # DL+
sudo lsof -i :8080  # Integration

# Kill the process or change port in .env
```

### Issue: Models not downloading

```bash
# Pull models manually
ollama pull llama3:8b
ollama pull qwen2.5:7b
ollama pull mistral:7b
ollama pull deepseek-coder:6.7b
ollama pull phi3:mini
```

### Issue: Agents not working

```bash
# Test agent imports
python3 << 'EOF'
import sys
sys.path.insert(0, './dlplus')
from agents.web_retrieval_agent import WebRetrievalAgent
from agents.code_generator_agent import CodeGeneratorAgent
print("Agents OK")
EOF
```

---

## 📚 Further Documentation

- **Complete Setup Guide:** [AUTO_SETUP_README.md](AUTO_SETUP_README.md)
- **OpenWebUI Integration:** [OPENWEBUI_INTEGRATION.md](OPENWEBUI_INTEGRATION.md)
- **DL+ System:** [DLPLUS_README.md](DLPLUS_README.md)
- **Deployment Guide:** [DEPLOYMENT.md](DEPLOYMENT.md)

---

## 💡 Tips

1. **First Run:** The first model download takes longest. Be patient!
2. **Storage:** Ensure you have at least 50GB free space
3. **RAM:** 8GB minimum, 16GB recommended
4. **GPU:** Optional but significantly improves performance
5. **Network:** Stable internet connection required for downloads

---

## ❓ Getting Help

- **GitHub Issues:** https://github.com/wasalstor-web/AI-Agent-Platform/issues
- **Documentation:** https://wasalstor-web.github.io/AI-Agent-Platform/
- **Test Installation:** Run `./test-integration.sh`

---

## 🎉 Success!

After installation, you should see:

```
✓ OpenWebUI running on http://localhost:3000
✓ DL+ System running on http://localhost:8000
✓ Integration API running on http://localhost:8080
✓ 5 AI models available
✓ 2 DL+ agents integrated
✓ Systemd service enabled
```

**تم التثبيت بنجاح! / Installation Complete!** 🚀
