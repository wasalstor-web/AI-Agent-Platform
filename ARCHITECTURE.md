# Architecture Overview - OpenWebUI + DL+ Integration
# نظرة عامة على البنية - دمج OpenWebUI مع DL+

**المؤسس:** خليف 'ذيبان' العنزي  
**الموقع:** القصيم – بريدة – المملكة العربية السعودية

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         User / المستخدم                          │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    OpenWebUI Web Interface                       │
│                      (Port 3000)                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ • Chat Interface                                         │   │
│  │ • Model Selection                                        │   │
│  │ • User Authentication                                    │   │
│  │ • Session Management                                     │   │
│  └─────────────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│              Integration Server (FastAPI)                        │
│                    (Port 8080)                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Webhook Endpoints:                                       │   │
│  │  • /webhook/chat    - Process chat messages             │   │
│  │  • /webhook/status  - System status                     │   │
│  │  • /api/models      - List AI models                    │   │
│  │  • /api/agents      - List DL+ agents                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                           │                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Authentication:                                          │   │
│  │  • JWT Token Verification                               │   │
│  │  • API Key Validation                                   │   │
│  └─────────────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│              OpenWebUI Adapter (DL+ Integration)                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Intelligent Message Routing:                            │   │
│  │                                                          │   │
│  │  ┌──────────────────────┐  ┌──────────────────────┐   │   │
│  │  │ Keyword Detection    │  │ Context Analysis     │   │   │
│  │  │ • search → Web Agent │  │ • Language detection │   │   │
│  │  │ • code → Code Agent  │  │ • Intent recognition │   │   │
│  │  └──────────────────────┘  └──────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────┘   │
└──────┬─────────────────┬────────────────────────────────────────┘
       │                 │
       │                 │
       ▼                 ▼
┌──────────────────┐  ┌──────────────────────────────────────────┐
│ WebRetrievalAgent│  │        CodeGeneratorAgent                │
│ ┌──────────────┐ │  │  ┌────────────────────────────────────┐ │
│ │ Capabilities:│ │  │  │ Capabilities:                       │ │
│ │ • Web search │ │  │  │ • Python code generation           │ │
│ │ • Info fetch │ │  │  │ • JavaScript code generation       │ │
│ │ • Content    │ │  │  │ • Java code generation             │ │
│ │   extraction │ │  │  │ • Multiple language support        │ │
│ └──────────────┘ │  │  │ • Test generation                  │ │
└──────────────────┘  │  └────────────────────────────────────┘ │
                      └──────────────────────────────────────────┘
                                    │
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                     DL+ Intelligence Core                        │
│                         (Port 8000)                              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ • Arabic Language Processing                            │   │
│  │ • Context Management                                    │   │
│  │ • Multi-Model Coordination                              │   │
│  │ • Response Generation                                   │   │
│  └─────────────────────────────────────────────────────────┘   │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Ollama AI Model Server                        │
│                       (Port 11434)                               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Available Models:                                        │   │
│  │  • llama3:8b          - General purpose (Meta)          │   │
│  │  • qwen2.5:7b         - Multilingual (Alibaba)          │   │
│  │  • mistral:7b         - Efficient (Mistral AI)          │   │
│  │  • deepseek-coder:6.7b - Code generation (DeepSeek)     │   │
│  │  • phi3:mini          - Compact (Microsoft)             │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Request Flow

### 1. User Sends Message

```
User → OpenWebUI → Integration Server (Port 8080)
```

### 2. Authentication

```
Integration Server checks:
  ├── JWT Token (Authorization header)
  └── API Key (X-API-Key header)
```

### 3. Agent Routing

```
OpenWebUI Adapter analyzes message:
  ├── Contains "search" → WebRetrievalAgent
  ├── Contains "code" → CodeGeneratorAgent
  └── Default → General conversation
```

### 4. Agent Execution

```
Selected Agent processes request:
  ├── WebRetrievalAgent → Searches web, formats results
  ├── CodeGeneratorAgent → Generates code in requested language
  └── General → DL+ Intelligence Core → Ollama models
```

### 5. Response Generation

```
Response flows back:
  Agent → Adapter → Integration Server → OpenWebUI → User
```

---

## 🔐 Security Layers

### 1. Authentication
- **JWT Token:** Bearer token authentication
- **API Key:** X-API-Key header validation
- **Secret Key:** Session encryption

### 2. Authorization
- **User Roles:** Admin/User permissions
- **Model Access:** Per-user model availability
- **Rate Limiting:** Request throttling

### 3. Data Protection
- **HTTPS:** Encrypted communication
- **Input Validation:** SQL injection prevention
- **Output Sanitization:** XSS prevention

---

## 📊 Component Details

### Integration Server (FastAPI)
```python
- Framework: FastAPI
- Port: 8080
- Features:
  • REST API endpoints
  • WebSocket support
  • OpenAPI documentation
  • CORS middleware
  • Authentication middleware
```

### OpenWebUI Adapter
```python
- Module: dlplus.integration.openwebui_adapter
- Purpose: Route messages to appropriate agents
- Features:
  • Keyword detection
  • Language detection
  • Context preservation
  • Multi-agent coordination
```

### DL+ Agents
```python
WebRetrievalAgent:
  - Purpose: Web search and information retrieval
  - Input: Search query
  - Output: Formatted search results
  
CodeGeneratorAgent:
  - Purpose: Multi-language code generation
  - Input: Code description + language
  - Output: Formatted code with syntax highlighting
```

### DL+ Core
```python
- Location: dlplus/core/
- Components:
  • intelligence_core.py - Main AI engine
  • arabic_processor.py - Arabic NLP
  • context_analyzer.py - Context management
```

### Ollama Server
```python
- Binary: ollama
- Models Directory: ~/.ollama/models
- API: REST API on port 11434
- Features:
  • Model loading/unloading
  • Inference execution
  • Model management
```

---

## 🚀 Deployment Architecture

### Development Environment
```
Local Machine:
  ├── OpenWebUI (Docker container)
  ├── Ollama (System service)
  ├── DL+ Core (Python process)
  └── Integration Server (Python process)
```

### Production Environment
```
VPS/Cloud Server:
  ├── OpenWebUI (Docker + Nginx reverse proxy)
  ├── Ollama (Systemd service)
  ├── DL+ Core (Systemd service)
  ├── Integration Server (Systemd service)
  └── SSL/TLS (Let's Encrypt)
```

### High-Availability Setup
```
Load Balancer:
  ├── OpenWebUI Cluster (Multiple containers)
  ├── Ollama Cluster (Multiple instances)
  ├── DL+ Core Cluster (Multiple processes)
  └── Database (PostgreSQL/Redis for state)
```

---

## 📈 Scalability

### Horizontal Scaling
- **OpenWebUI:** Multiple Docker containers behind load balancer
- **Ollama:** Separate instances for different models
- **DL+ Core:** Process pool for parallel requests
- **Integration:** Multiple FastAPI workers

### Vertical Scaling
- **CPU:** More cores for parallel model inference
- **RAM:** More memory for larger models
- **GPU:** NVIDIA GPUs for faster inference
- **Storage:** SSD for faster model loading

---

## 🔧 Configuration Files

### Docker Compose (OpenWebUI)
```yaml
Location: /opt/ai-agent-platform/openwebui/docker-compose.yml
Purpose: OpenWebUI container configuration
```

### Environment Variables
```bash
Location: .env
Contains:
  - API keys
  - Service ports
  - Model configuration
  - Security settings
```

### Systemd Services
```bash
Location: /etc/systemd/system/ai-agent-platform.service
Purpose: Auto-start all services on boot
```

---

## 🧪 Testing Endpoints

### Health Checks
```bash
curl http://localhost:3000              # OpenWebUI
curl http://localhost:8080/webhook/status  # Integration
curl http://localhost:8000/api/health    # DL+ Core
curl http://localhost:11434/api/tags     # Ollama
```

### Functional Tests
```bash
# List models
curl http://localhost:8080/api/models

# List agents
curl http://localhost:8080/api/agents

# Test chat
curl -X POST http://localhost:8080/webhook/chat \
  -H "X-API-Key: sk-3720ccd539704717ba9af3453500fe3c" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello", "model": "llama-3-8b"}'
```

---

## 📚 Related Documentation

- **[Auto Setup Guide](AUTO_SETUP_README.md)** - Complete installation guide
- **[Quick Start](QUICKSTART_AUTO.md)** - Get started quickly
- **[OpenWebUI Integration](OPENWEBUI_INTEGRATION.md)** - Integration details
- **[DL+ System](DLPLUS_README.md)** - DL+ documentation
- **[Test Script](test-integration.sh)** - Automated testing

---

**Architecture Version:** 1.0.0  
**Last Updated:** 2025-10-20  
**Status:** Production Ready ✅
