# AI-Agent-Platform

An AI Agent Platform infrastructure project with **Supreme Agent** - a comprehensive, bilingual AI assistant with advanced capabilities for chat, command execution, file analysis, and code generation.

## 🚀 Quick Start

### Online Demo
**🌐 [https://wasalstor-web.github.io/AI-Agent-Platform/](https://wasalstor-web.github.io/AI-Agent-Platform/)**

### One-Command Installation
```bash
./scripts/quick-start.sh
```

This will install Supreme Agent, start the API server, and launch the web interface.

For complete deployment information, see **[DEPLOYMENT.md](DEPLOYMENT.md)**.

## 🤖 Supreme Agent

Supreme Agent (الوكيل الأعلى) is an integrated AI system that combines multiple capabilities:

- 💬 **Intelligent Chat**: Natural bilingual (Arabic/English) conversations
- ⚡ **Command Execution**: Execute any task or command
- 📊 **File Analysis**: Comprehensive file and code analysis
- 💻 **Code Generation**: Generate code in any programming language
- 🎯 **Model Management**: Support for multiple AI models (llama3, aya, mistral, deepseek-coder, qwen2)
- 🌐 **Modern Web UI**: Beautiful, responsive interface with dark/light themes
- 🔗 **OpenWebUI Integration**: Seamless integration with OpenWebUI
- 🐳 **Docker Support**: Easy deployment with Docker and Docker Compose

### Quick Usage

```bash
# Chat with the agent
supreme-agent chat "مرحباً! كيف يمكنني مساعدتك؟"

# Execute a command
supreme-agent execute "Create a Python script for data processing"

# Analyze a file
supreme-agent analyze-file script.py

# Generate code
supreme-agent generate-code "A REST API for user management" --lang python

# Check system health
supreme-agent health

# List available models
supreme-agent models
```

### Web Interface

Open the modern web interface:
```bash
# Navigate to web directory
cd web

# Start web server
python3 -m http.server 8080

# Open http://localhost:8080 in your browser
```

The web interface includes:
- Interactive chat with quick actions
- Command execution panel
- File analysis with upload support
- Code generation with syntax highlighting
- Model management dashboard
- Conversation history with export
- Settings with theme and language toggle

### API Server

Start the API server:
```bash
python3 api/server.py
```

Access the API at:
- Main: http://localhost:5000
- Docs: http://localhost:5000/api/docs
- Health: http://localhost:5000/api/health

See [docs/API.md](docs/API.md) for complete API documentation.

### Docker Deployment

```bash
# Build and run with Docker Compose
docker-compose up -d

# With OpenWebUI
docker-compose --profile with-openwebui up -d

# Access services:
# - Supreme Agent API: http://localhost:5000
# - Web Interface: http://localhost:8080
# - OpenWebUI: http://localhost:3000
```

## Overview

This project provides a comprehensive platform for building, deploying, and managing AI agents with built-in project lifecycle management tools and OpenWebUI integration for running large language models.

## 🎯 Supreme Agent Features

### Core Capabilities

1. **Bilingual AI Assistant** (عربي/English)
   - Natural conversations in Arabic and English
   - Context-aware responses
   - Continuous learning from interactions

2. **Command Execution**
   - Execute complex tasks and commands
   - Generate scripts and automation tools
   - Problem-solving assistance

3. **File Analysis**
   - Comprehensive code analysis
   - Documentation review
   - Security scanning
   - Performance recommendations

4. **Code Generation**
   - Support for 20+ programming languages
   - Clean, documented, production-ready code
   - Best practices implementation
   - Error handling and validation

5. **Model Management**
   - Multiple AI model support
   - Custom model creation
   - Model comparison and selection
   - Performance optimization

### Supported Models

- **supreme-executor**: Custom bilingual model (Arabic/English) ⭐
- **llama3**: General-purpose foundation model
- **aya**: Multilingual specialist with excellent Arabic support
- **mistral**: Fast and efficient model
- **deepseek-coder**: Programming specialist
- **qwen2**: Advanced model with long context

See [docs/MODELS.md](docs/MODELS.md) for detailed model comparison and usage guide.

### Architecture

```
┌─────────────────────────────────────────────────┐
│                Supreme Agent                    │
│                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │   Web    │  │   API    │  │ CLI Tool │    │
│  │    UI    │  │  Server  │  │          │    │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘    │
│       │             │             │            │
│       └─────────────┴─────────────┘            │
│                     │                          │
│            ┌────────▼────────┐                 │
│            │  Supreme Agent  │                 │
│            │    Core Class   │                 │
│            └────────┬────────┘                 │
│                     │                          │
│            ┌────────▼────────┐                 │
│            │     Ollama      │                 │
│            │   (AI Models)   │                 │
│            └─────────────────┘                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Web Interface

The platform now includes a comprehensive HTML interface that provides:
- **Bilingual Support**: Full Arabic and English interface with real-time language switching
- **Interactive Documentation**: Visual representation of all features and workflows
- **Command Reference**: Easy-to-copy commands for all operations
- **Modern Design**: Responsive, mobile-friendly interface with gradient styling

### Accessing the Web Interface

#### Online (GitHub Pages)

The platform is hosted on GitHub Pages and can be accessed at:

**🌐 [https://wasalstor-web.github.io/AI-Agent-Platform/](https://wasalstor-web.github.io/AI-Agent-Platform/)**

The site is automatically deployed when changes are pushed to the main branch.

#### Local Access

You can also open `index.html` in your web browser locally:

```bash
# Open directly in browser
open index.html  # macOS
xdg-open index.html  # Linux
start index.html  # Windows

# Or serve it with a local server
python3 -m http.server 8080
# Then navigate to http://localhost:8080/index.html
```

The web interface includes:
- Project overview and features showcase
- Step-by-step finalization workflow visualization
- Command examples with copy-to-clipboard functionality
- Quick action buttons for GitHub repository and documentation
- Benefits and security information

## Deployment Status

✅ **Supreme Agent has been successfully integrated**
✅ **OpenWebUI has been successfully added and integrated**
✅ **Project is deployed and accessible via GitHub Pages**
✅ **Temporary domain active:** https://wasalstor-web.github.io/AI-Agent-Platform/

📖 **For complete deployment information, see [DEPLOYMENT.md](DEPLOYMENT.md)**

## Installation

### Prerequisites

- Ubuntu/Debian-based system (or macOS/Windows with WSL)
- Python 3.8 or higher
- 8GB+ RAM recommended
- 20GB+ free disk space
- Internet connection for model downloads

### Quick Installation

#### Method 1: One-Command Setup (Recommended)

```bash
./scripts/quick-start.sh
```

This script will:
1. Install Ollama
2. Download required AI models
3. Create the supreme-executor custom model
4. Install Python dependencies
5. Start the API server
6. Launch the web interface

#### Method 2: Step-by-Step Installation

```bash
# 1. Install Supreme Agent
./scripts/install-supreme-agent.sh

# 2. Start API Server
python3 api/server.py &

# 3. Start Web Interface
cd web && python3 -m http.server 8080 &

# 4. (Optional) Integrate with OpenWebUI
./scripts/integrate-openwebui.sh
```

#### Method 3: Docker Installation

```bash
# Build and run
docker-compose up -d

# Or with OpenWebUI
docker-compose --profile with-openwebui up -d
```

### Manual Installation

```bash
# 1. Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# 2. Start Ollama
ollama serve &

# 3. Pull models
ollama pull llama3
ollama pull aya
ollama pull mistral
ollama pull deepseek-coder
ollama pull qwen2

# 4. Create custom model
cd models
ollama create supreme-executor -f Modelfile

# 5. Install Python dependencies
pip3 install requests flask flask-cors

# 6. Create supreme-agent command
sudo ln -s $(pwd)/scripts/supreme_agent.py /usr/local/bin/supreme-agent
sudo chmod +x /usr/local/bin/supreme-agent

# 7. Start the API server
python3 api/server.py &

# 8. Start the web interface
cd web && python3 -m http.server 8080 &
```

### Verify Installation

```bash
# Check health
supreme-agent health

# Test chat
supreme-agent chat "Hello!"

# List models
supreme-agent models

# Check API
curl http://localhost:5000/api/health

# Open web interface
# Navigate to http://localhost:8080
```

## Documentation

### Core Documentation

- **[README.md](README.md)** - This file (main documentation)
- **[docs/API.md](docs/API.md)** - Complete API reference with examples
- **[docs/MODELS.md](docs/MODELS.md)** - AI models guide and comparison
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Deployment guide
- **[OPENWEBUI.md](OPENWEBUI.md)** - OpenWebUI integration guide

### Configuration Files

- **config/settings.json** - Main configuration
- **.env.example** - Environment variables template
- **models/Modelfile** - Custom model definition

### Scripts

- **scripts/install-supreme-agent.sh** - Installation script
- **scripts/quick-start.sh** - One-command setup
- **scripts/integrate-openwebui.sh** - OpenWebUI integration
- **setup-openwebui.sh** - OpenWebUI setup

## Project Finalization

The platform includes automated scripts for finalizing projects with proper resource cleanup and archival.

### Finalization Scripts

#### 1. Directive Script (`directive_finalize.sh`)

The main directive script that initiates the finalization process. This script:
- Displays administrative directives in both Arabic and English
- Calls the finalization script with appropriate parameters
- Provides clear status messages throughout the process

**Usage:**
```bash
./directive_finalize.sh
```

#### 2. Finalization Script (`finalize_project.sh`)

The core finalization script that handles:
- Project status validation
- Git repository checks
- Artifact archival
- Report generation
- Resource cleanup
- Final verification

**Usage:**
```bash
# Interactive mode (with confirmation prompt)
./finalize_project.sh

# Force mode (skip checks but proceed anyway)
./finalize_project.sh --force

# No confirmation mode (skip user prompt)
./finalize_project.sh --no-confirmation

# Combined mode (force + no confirmation)
./finalize_project.sh --force --no-confirmation
```

### Finalization Process

The finalization script performs the following steps:

1. **Project Status Check** - Validates project documentation and structure
2. **Git Repository Validation** - Checks repository status and uncommitted changes
3. **Artifact Archival** - Creates timestamped archives of project state
4. **Report Generation** - Generates comprehensive finalization report
5. **Resource Cleanup** - Removes temporary files and caches
6. **Final Verification** - Confirms all steps completed successfully

### Archive Contents

After finalization, an archive is created in `/tmp/ai-agent-platform-archive-[TIMESTAMP]` containing:
- `recent_commits.txt` - Last 10 git commits
- `final_status.txt` - Final git status
- `project_snapshot/` - Complete project snapshot
- `finalization_report.txt` - Detailed finalization report

### Options

- `--force` - Continue finalization even if warnings are detected
- `--no-confirmation` - Skip user confirmation prompt

## OpenWebUI Integration

The platform now includes full integration with OpenWebUI, a powerful open-source web interface for large language models (LLMs) like Ollama.

### Setup OpenWebUI Script (`setup-openwebui.sh`)

A comprehensive bilingual script for installing and managing OpenWebUI on your VPS:

**Features:**
- Automated Docker and Docker Compose installation
- OpenWebUI container deployment
- Optional Ollama installation
- Nginx reverse proxy configuration
- SSL certificate support
- Service management (start, stop, restart, logs)
- Interactive menu interface

**Quick Installation:**

```bash
# Interactive mode
./setup-openwebui.sh

# Or automated installation
./setup-openwebui.sh install

# Check status
./setup-openwebui.sh status

# View logs
./setup-openwebui.sh logs
```

**What is OpenWebUI?**

OpenWebUI is an extensible, feature-rich, and user-friendly web interface designed to operate entirely offline. It supports various LLM runners including Ollama and OpenAI-compatible APIs.

**Key Features:**
- 🎨 Intuitive web interface for chat interactions
- 🔌 Support for Ollama and OpenAI-compatible APIs
- 📱 Responsive design for mobile and desktop
- 🔐 User authentication and management
- 💬 Multiple chat sessions
- 📝 Markdown and code syntax highlighting
- 🌐 Multi-language support

**Access OpenWebUI:**

After installation, OpenWebUI will be available at:
- `http://your-vps-ip:3000`
- Or via your configured domain if Nginx is setup

**📖 Complete Documentation:**
For detailed information about OpenWebUI integration, installation, configuration, troubleshooting, and advanced usage, see [OPENWEBUI.md](OPENWEBUI.md)

## VPS Connection Check

The platform includes comprehensive VPS connection verification tools with OpenWebUI service checks.

### Deploy Script (`deploy.sh`)

A bilingual (Arabic/English) script for checking VPS connectivity:

**Features:**
- DNS resolution check
- SSH connection test
- HTTP/HTTPS connectivity verification
- Response time measurement
- Comprehensive port scanning (SSH, HTTP, HTTPS, OpenWebUI, Ollama, databases)
- OpenWebUI and Ollama service checks
- Colored output for better readability
- Configurable timeouts

**Usage:**

```bash
# Basic usage with command line arguments
./deploy.sh --host your-vps.com

# With custom SSH settings
./deploy.sh --host your-vps.com --user admin --port 2222

# Using environment variables
VPS_HOST=your-vps.com ./deploy.sh

# Configure via .env file
cp .env.example .env
# Edit .env with your VPS details
source .env
./deploy.sh

# Show help
./deploy.sh --help
```

**Configuration Options:**

- `--host, -h` : VPS hostname or IP address
- `--user, -u` : SSH username (default: root)
- `--port, -p` : SSH port (default: 22)
- `--timeout, -t` : Connection timeout in seconds (default: 5)

**Environment Variables:**

- `VPS_HOST` : Server hostname
- `VPS_USER` : SSH username
- `VPS_PORT` : SSH port
- `HTTP_PORT` : HTTP port (default: 80)
- `HTTPS_PORT` : HTTPS port (default: 443)
- `TIMEOUT` : Connection timeout
- `OPENWEBUI_PORT` : OpenWebUI port (default: 3000)
- `OPENWEBUI_VERSION` : OpenWebUI Docker image version (default: latest)
- `OLLAMA_API_BASE_URL` : Ollama API URL (default: http://localhost:11434)
- `WEBUI_SECRET_KEY` : Secret key for OpenWebUI (generate with: `openssl rand -hex 32`)

### Smart Deploy Script (`smart-deploy.sh`)

Interactive menu-driven deployment tool with Arabic interface. The first option now integrates with the comprehensive VPS connection check.

**Usage:**
```bash
./smart-deploy.sh
```

**Features:**
1. Check deployment status (VPS connection check)
2. Automated git pull deployment
3. SSL certificate setup
4. GitHub webhooks configuration
5. Nginx configuration
6. Backup system
7. Log monitoring
8. Performance checks
9. Security scanning
10. **OpenWebUI Management** (New!)
11. Rollback capability

### Connection Check Output

The VPS connection check provides detailed information:

```
✓ DNS Resolution: Shows IP address resolution
✓ SSH Connection: Tests SSH connectivity
✓ HTTP/HTTPS: Checks web server status
✓ Response Time: Measures ping and HTTP response times
✓ Port Scanning: Checks common service ports
```

**Output Example:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  فحص شامل لاتصال VPS / Comprehensive VPS Connection Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ DNS resolved: your-vps.com → 123.456.789.0
✓ SSH connection successful
✓ HTTP server is responding
✓ Average response time: 45ms
✓ Port 22 is open
✓ Port 3000 (OpenWebUI) is open
✓ OpenWebUI is running
✓ Ollama is running
```

## Security and Best Practices

Following the platform's security guidelines:
- ✅ No sensitive data committed to repository
- ✅ Proper error handling implemented
- ✅ Resource cleanup automated
- ✅ Comprehensive logging and reporting
- ✅ Clear user communication in multiple languages
- ✅ Secure VPS connection verification
- ✅ Environment variable support for sensitive configuration

**Security Notes:**
- Never commit `.env` file to the repository
- Use SSH keys for authentication instead of passwords
- Configure firewall rules to restrict SSH access
- Use non-standard SSH ports when possible
- Keep SSH and web server software up to date

## License

AI-Agent-Platform © 2025