# Automated OpenWebUI Setup with DL+ Agents Integration
# إعداد OpenWebUI التلقائي مع دمج وكلاء DL+

**المؤسس:** خليف 'ذيبان' العنزي  
**الموقع:** القصيم – بريدة – المملكة العربية السعودية

---

## 🚀 Quick Start - Zero Manual Intervention

This automated setup script installs and configures everything needed for a complete AI Agent Platform with OpenWebUI integration - **NO MANUAL STEPS REQUIRED**.

### One-Command Installation

```bash
sudo bash auto-setup-openwebui.sh
```

That's it! The script will:

✅ Install Docker and Docker Compose  
✅ Install Ollama AI model server  
✅ Pull all AI models (LLaMA 3, Qwen, Mistral, DeepSeek, Phi-3)  
✅ Setup OpenWebUI with all API keys  
✅ Integrate DL+ agents (WebRetrievalAgent, CodeGeneratorAgent)  
✅ Start all services automatically  
✅ Configure systemd for auto-start on boot  

---

## 📋 What Gets Installed

### 1. **Core Services**
- **Docker** - Container runtime
- **Docker Compose** - Multi-container orchestration
- **Ollama** - AI model server (port 11434)
- **OpenWebUI** - Web interface (port 3000)

### 2. **DL+ Intelligence System**
- **FastAPI Server** - API gateway (port 8000)
- **Integration Server** - Webhook handler (port 8080)
- **Agent Adapter** - DL+ agent integration layer

### 3. **AI Models**
- **LLaMA 3 8B** - Meta's general purpose model
- **Qwen 2.5 7B** - Alibaba's multilingual model
- **Mistral 7B** - Mistral AI's efficient model
- **DeepSeek Coder 6.7B** - Specialized code generation
- **Phi-3 Mini** - Microsoft's compact model

### 4. **DL+ Agents**
- **WebRetrievalAgent** - Web search and information retrieval
- **CodeGeneratorAgent** - Multi-language code generation
- **BaseAgent** - Foundation for custom agents

### 5. **API Keys & Authentication**
- JWT Token authentication
- API Key authentication
- Secure secret key generation
- All credentials configured automatically

---

## 🔧 System Requirements

### Minimum Requirements
- **OS:** Ubuntu 20.04+ / Debian 11+ / CentOS 8+
- **CPU:** 4 cores
- **RAM:** 8 GB
- **Storage:** 50 GB free space
- **Network:** Internet connection for downloading models

### Recommended Requirements
- **CPU:** 8+ cores
- **RAM:** 16+ GB
- **Storage:** 100+ GB SSD
- **GPU:** NVIDIA GPU with CUDA support (optional, for better performance)

---

## 📦 Installation Process

### Step-by-Step Breakdown

The automated script performs these steps:

1. **System Dependencies** - Updates packages, installs essential tools
2. **Docker Installation** - Installs Docker CE and configures daemon
3. **Docker Compose** - Installs Docker Compose plugin
4. **Ollama Installation** - Installs and starts Ollama service
5. **Model Pulling** - Downloads all AI models (this may take 10-30 minutes)
6. **OpenWebUI Setup** - Creates Docker container with configuration
7. **DL+ Integration** - Sets up Python virtual environment and dependencies
8. **Agent Creation** - Creates OpenWebUI adapter for DL+ agents
9. **Service Configuration** - Creates startup scripts and systemd services
10. **Verification** - Tests all services and endpoints
11. **Summary Display** - Shows access URLs and usage examples

### Installation Time

- **Fast Network (100+ Mbps):** 15-20 minutes
- **Medium Network (10-50 Mbps):** 30-45 minutes
- **Slow Network (<10 Mbps):** 60+ minutes

Most time is spent downloading AI models (10-30 GB total).

---

## 🌐 Access Points

After installation, access these URLs:

| Service | URL | Description |
|---------|-----|-------------|
| **OpenWebUI** | http://localhost:3000 | Main web interface |
| **DL+ System** | http://localhost:8000 | Intelligence core API |
| **Integration API** | http://localhost:8080 | Webhook endpoints |
| **OpenWebUI Docs** | http://localhost:8080/api/docs | API documentation |
| **DL+ Docs** | http://localhost:8000/api/docs | DL+ API docs |

---

## 🔐 Authentication

All API keys are automatically configured:

- **JWT Token:** eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
- **API Key:** sk-3720ccd539704717ba9af3453500fe3c
- **Secret Key:** Auto-generated 64-character hex

These are configured in `.env` file and environment variables.

---

## 🤖 Using DL+ Agents

### Web Search Agent

```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{"message": "search for artificial intelligence", "model": "llama-3-8b"}'
```

### Code Generation Agent

```bash
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{"message": "write Python code to calculate factorial", "model": "deepseek-coder"}'
```

### List Available Agents

```bash
curl http://localhost:8080/api/agents
```

### List Available Models

```bash
curl http://localhost:8080/api/models
```

---

## 🔄 Service Management

### Using Systemd (Automatic)

```bash
# Start all services
sudo systemctl start ai-agent-platform

# Stop all services
sudo systemctl stop ai-agent-platform

# Restart services
sudo systemctl restart ai-agent-platform

# Check status
sudo systemctl status ai-agent-platform

# Enable auto-start on boot
sudo systemctl enable ai-agent-platform

# Disable auto-start
sudo systemctl disable ai-agent-platform
```

### Using Manual Script

```bash
# Start all services
./start-all-services.sh

# Check service status
curl http://localhost:8080/webhook/status
curl http://localhost:8000/api/health

# View logs
tail -f logs/dlplus.log
tail -f logs/integration.log
```

### Individual Services

```bash
# Ollama
sudo systemctl start ollama
sudo systemctl status ollama

# OpenWebUI
cd /opt/ai-agent-platform/openwebui
docker compose up -d
docker compose logs -f

# DL+ System (manual)
source venv/bin/activate
python dlplus/main.py

# Integration Server (manual)
source venv/bin/activate
python openwebui-integration.py
```

---

## 📊 Monitoring & Logs

### Log Locations

- **DL+ System:** `logs/dlplus.log`
- **Integration Server:** `logs/integration.log`
- **OpenWebUI:** `docker compose -f /opt/ai-agent-platform/openwebui/docker-compose.yml logs`
- **Ollama:** `journalctl -u ollama -f`

### Health Checks

```bash
# Check all services
curl http://localhost:8080/webhook/status
curl http://localhost:8000/api/health
curl http://localhost:3000

# Check Ollama
curl http://localhost:11434/api/tags

# Check models
ollama list
```

---

## 🔧 Troubleshooting

### Services Not Starting

```bash
# Check Docker
sudo systemctl status docker
sudo systemctl start docker

# Check Ollama
sudo systemctl status ollama
sudo systemctl start ollama

# Check port conflicts
sudo lsof -i :3000
sudo lsof -i :8000
sudo lsof -i :8080
sudo lsof -i :11434
```

### Models Not Available

```bash
# Pull models manually
ollama pull llama3:8b
ollama pull qwen2.5:7b
ollama pull mistral:7b
ollama pull deepseek-coder:6.7b
ollama pull phi3:mini

# List installed models
ollama list
```

### Agent Integration Issues

```bash
# Check Python environment
source venv/bin/activate
python -c "from dlplus.integration.openwebui_adapter import OpenWebUIAdapter; print('OK')"

# Reinstall dependencies
pip install -r requirements.txt
```

### Permission Issues

```bash
# Fix Docker permissions
sudo usermod -aG docker $USER
newgrp docker

# Fix file permissions
sudo chown -R $USER:$USER /opt/ai-agent-platform
```

---

## 🔄 Updating

### Update AI Models

```bash
# Update all models
ollama pull llama3:8b
ollama pull qwen2.5:7b
ollama pull mistral:7b
ollama pull deepseek-coder:6.7b
ollama pull phi3:mini
```

### Update OpenWebUI

```bash
cd /opt/ai-agent-platform/openwebui
docker compose pull
docker compose up -d
```

### Update DL+ System

```bash
cd /path/to/AI-Agent-Platform
git pull
source venv/bin/activate
pip install -r requirements.txt --upgrade
sudo systemctl restart ai-agent-platform
```

---

## 🗑️ Uninstallation

To completely remove the AI Agent Platform:

```bash
# Stop services
sudo systemctl stop ai-agent-platform
sudo systemctl disable ai-agent-platform

# Remove systemd service
sudo rm /etc/systemd/system/ai-agent-platform.service
sudo systemctl daemon-reload

# Remove OpenWebUI
cd /opt/ai-agent-platform/openwebui
docker compose down -v

# Remove Ollama
sudo systemctl stop ollama
sudo systemctl disable ollama
sudo rm /usr/local/bin/ollama
sudo rm -rf ~/.ollama

# Remove Docker (optional)
sudo apt-get remove docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker

# Remove installation directory
sudo rm -rf /opt/ai-agent-platform

# Remove project files
cd /path/to/AI-Agent-Platform
rm -rf venv logs
```

---

## 🆘 Support & Documentation

### Documentation Links

- **OpenWebUI Documentation:** [OPENWEBUI_INTEGRATION.md](OPENWEBUI_INTEGRATION.md)
- **DL+ Documentation:** [DLPLUS_README.md](DLPLUS_README.md)
- **Deployment Guide:** [DEPLOYMENT.md](DEPLOYMENT.md)
- **Quick Start:** [QUICK-START.md](QUICK-START.md)

### Getting Help

- **GitHub Issues:** https://github.com/wasalstor-web/AI-Agent-Platform/issues
- **Online Documentation:** https://wasalstor-web.github.io/AI-Agent-Platform/

---

## 📜 License

AI-Agent-Platform © 2025 - خليف 'ذيبان' العنزي

---

## 🎯 Features Summary

✅ **Zero Configuration** - Fully automated setup  
✅ **All API Keys** - Pre-configured authentication  
✅ **6 AI Models** - LLaMA, Qwen, Mistral, DeepSeek, Phi-3  
✅ **DL+ Agents** - Web search & code generation  
✅ **Auto Start** - Systemd integration  
✅ **Complete Logs** - Comprehensive logging  
✅ **Health Checks** - Built-in monitoring  
✅ **Arabic Support** - Native Arabic language support  
✅ **API Docs** - Interactive Swagger documentation  
✅ **Production Ready** - Suitable for production deployment  

---

**تم التثبيت بنجاح! / Installation Successful!** 🎉
