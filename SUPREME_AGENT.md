# Supreme Agent - الوكيل الأعلى المتكامل

## 🎯 Overview / نظرة عامة

Supreme Agent is a comprehensive, bilingual (Arabic/English) AI agent platform that combines multiple AI capabilities into a single, easy-to-use system.

الوكيل الأعلى هو منصة شاملة ثنائية اللغة (عربي/إنجليزي) للذكاء الاصطناعي تجمع قدرات متعددة في نظام واحد سهل الاستخدام.

## ✨ Features / المميزات

### 🤖 AI Capabilities
- **Intelligent Chat**: Natural conversations in Arabic and English
- **Command Execution**: Execute any task or command
- **File Analysis**: Comprehensive code and file analysis
- **Code Generation**: Generate code in 20+ programming languages
- **Multiple Models**: Support for 6 AI models

### 💻 Technical Features
- **REST API**: 6 endpoints with full CRUD operations
- **Modern Web UI**: Responsive interface with dark/light themes
- **Docker Support**: Full containerization
- **OpenWebUI Integration**: Seamless integration
- **One-Command Install**: Quick and easy setup
- **Cross-Platform**: Works on Linux, macOS, Windows (WSL)

## 🚀 Quick Start

### Installation

```bash
# One-command installation
./scripts/quick-start.sh
```

### Usage

**Command Line:**
```bash
# Chat
supreme-agent chat "مرحباً! كيف حالك؟"

# Execute command
supreme-agent execute "Create a Python web scraper"

# Analyze file
supreme-agent analyze-file script.py

# Generate code
supreme-agent generate-code "REST API for users" --lang python

# Check health
supreme-agent health

# List models
supreme-agent models
```

**API:**
```bash
curl -X POST http://localhost:5000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello!"}'
```

**Web Interface:**
```bash
# Open in browser
open http://localhost:8080
```

## 📁 Project Structure

```
AI-Agent-Platform/
├── models/
│   └── Modelfile                    # Custom supreme-executor model
├── scripts/
│   ├── supreme_agent.py             # Core agent class
│   ├── install-supreme-agent.sh     # Installation script
│   ├── quick-start.sh               # One-command setup
│   ├── integrate-openwebui.sh       # OpenWebUI integration
│   ├── update.sh                    # Update utility
│   └── backup.sh                    # Backup utility
├── api/
│   └── server.py                    # REST API server
├── web/
│   ├── index.html                   # Web interface
│   ├── style.css                    # Responsive styles
│   └── app.js                       # Frontend logic
├── config/
│   └── settings.json                # Configuration
├── docs/
│   ├── API.md                       # API documentation
│   └── MODELS.md                    # Models guide
├── tests/
│   ├── test_agent.py                # Agent tests
│   └── test_api.py                  # API tests
├── Dockerfile                       # Docker container
├── docker-compose.yml               # Service orchestration
└── README.md                        # Main documentation
```

## 🤝 Supported AI Models

1. **supreme-executor** ⭐ - Custom bilingual model (recommended)
2. **llama3** - General-purpose foundation model
3. **aya** - Multilingual specialist (excellent Arabic)
4. **mistral** - Fast and efficient
5. **deepseek-coder** - Programming specialist
6. **qwen2** - Advanced long-context model

See [docs/MODELS.md](docs/MODELS.md) for detailed comparison.

## 🌐 API Endpoints

- `GET /api/health` - System health check
- `POST /api/chat` - Intelligent conversation
- `POST /api/execute` - Command execution
- `POST /api/analyze` - File analysis
- `POST /api/generate-code` - Code generation
- `GET /api/models` - List available models

See [docs/API.md](docs/API.md) for complete documentation.

## 🐳 Docker Deployment

```bash
# Build and run
docker-compose up -d

# With OpenWebUI
docker-compose --profile with-openwebui up -d

# Access:
# - API: http://localhost:5000
# - Web: http://localhost:8080
# - OpenWebUI: http://localhost:3000
```

## 🛠️ Maintenance

### Update System
```bash
./scripts/update.sh
```

### Backup Data
```bash
./scripts/backup.sh
```

### Check Status
```bash
supreme-agent health
curl http://localhost:5000/api/health
```

## 📚 Documentation

- **[README.md](README.md)** - Main documentation
- **[docs/API.md](docs/API.md)** - API reference
- **[docs/MODELS.md](docs/MODELS.md)** - Models guide
- **[OPENWEBUI.md](OPENWEBUI.md)** - OpenWebUI integration

## 🧪 Testing

```bash
# Test agent
python3 tests/test_agent.py

# Test API (requires running server)
python3 api/server.py &
python3 tests/test_api.py
```

## 🔧 Configuration

Edit `config/settings.json` to customize:
- Default model
- API settings
- Web interface preferences
- Ollama configuration

## 📝 Examples

### Python Client
```python
from scripts.supreme_agent import SupremeAgent

agent = SupremeAgent()
response = agent.chat("مرحباً")
print(response)
```

### API Call
```python
import requests

response = requests.post('http://localhost:5000/api/chat', 
    json={'message': 'Hello!'})
print(response.json()['response'])
```

## 🤝 Contributing

This project is part of the AI-Agent-Platform. Contributions are welcome!

## 📄 License

© 2025 wasalstor-web

## 🆘 Support

For issues or questions:
- GitHub Issues: https://github.com/wasalstor-web/AI-Agent-Platform/issues
- Documentation: See docs/

---

**Supreme Agent** - الوكيل الأعلى المتكامل  
Built with ❤️ for the AI community
