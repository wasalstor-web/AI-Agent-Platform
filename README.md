# AI-Agent-Platform

An AI Agent Platform infrastructure project with automated finalization capabilities, OpenWebUI integration, and the **DL+ Unified Arabic Intelligence System**.

## 🧠 NEW: DL+ Arabic Intelligence System

**نظام DL+ للذكاء الصناعي العربي الموحد**

The platform now includes DL+, a complete Arabic-first AI system that integrates:
- 🧠 **GitHub Intelligence Core** - AI models and reasoning
- ⚙️ **Hostinger Integration** - Execution and deployment
- 💬 **OpenWebUI** - Interactive user interface
- 🔗 **FastAPI Bridge** - Seamless communication layer

**Quick Start DL+:**
```bash
./start-dlplus.sh
```

📖 **[Read the complete DL+ documentation](DLPLUS_README.md)**

---

## 🚀 Quick Start

**The platform is live and accessible at:**
**🌐 [https://wasalstor-web.github.io/AI-Agent-Platform/](https://wasalstor-web.github.io/AI-Agent-Platform/)**

For complete deployment information, see **[DEPLOYMENT.md](DEPLOYMENT.md)**.

## Overview

This project provides a comprehensive platform for building, deploying, and managing AI agents with:
- **DL+ Arabic Intelligence System** - Native Arabic AI with deep language understanding
- **Automated finalization capabilities** - Built-in project lifecycle management
- **OpenWebUI integration** - Interactive interface for large language models
- **Multi-agent orchestration** - Coordinate multiple AI agents seamlessly

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

## 🧠 DL+ Unified Arabic Intelligence System

### نظام DL+ للذكاء الصناعي العربي الموحد

DL+ is a comprehensive Arabic-first AI system that brings together intelligence, execution, and interaction in a unified platform.

### Key Components

**1. GitHub Intelligence Core** (`dlplus/core/`)
- `intelligence_core.py` - Main AI engine coordinating all models
- `arabic_processor.py` - Advanced Arabic language processing with classical Arabic support
- `context_analyzer.py` - Context-aware conversation management

**2. API Layer** (`dlplus/api/`)
- `fastapi_connector.py` - Gateway between GitHub and Hostinger
- `internal_api.py` - Secure command execution API with whitelisting

**3. Configuration** (`dlplus/config/`)
- `settings.py` - System configuration
- `models_config.py` - AI model configurations (AraBERT, LLaMA 3, Qwen, etc.)
- `agents_config.py` - Agent definitions and capabilities

**4. Agents** (`dlplus/agents/`)
- `WebRetrievalAgent` - Web search and information retrieval
- `CodeGeneratorAgent` - Code generation in multiple languages
- `BaseAgent` - Abstract base class for custom agents

### Quick Start with DL+

```bash
# 1. Clone the repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# 2. Start DL+ system
./start-dlplus.sh

# The system will be available at http://localhost:8000
```

### API Endpoints

- `GET /` - System information
- `GET /api/health` - Health check
- `GET /api/status` - System status
- `POST /api/process` - Process commands in Arabic
- `POST /api/github/execute` - Execute commands from GitHub
- `GET /api/docs` - Interactive API documentation

### Example Usage

**Python:**
```python
import asyncio
from dlplus import DLPlusCore

async def main():
    core = DLPlusCore()
    await core.initialize()
    
    result = await core.process_command("اشرح لي ما هو الذكاء الصناعي")
    print(result['response'])

asyncio.run(main())
```

**cURL:**
```bash
curl -X POST http://localhost:8000/api/process \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{"command": "مرحباً"}'
```

### Documentation

- 📖 [Complete DL+ Documentation](dlplus/docs/DLPLUS_SYSTEM.md)
- 🚀 [Quick Start Guide](DLPLUS_README.md)
- 💡 [Examples](examples/)
- 🧪 [Tests](tests/)

### Supported AI Models

- **AraBERT** - Arabic language understanding
- **CAMeLBERT** - Arabic NLP and NER
- **Qwen 2.5 Arabic** - Arabic text generation and reasoning
- **LLaMA 3** - General reasoning and coding
- **DeepSeek** - Advanced code generation
- **Mistral** - Multilingual support

---

## Deployment Status

✅ **OpenWebUI has been successfully added and integrated**
✅ **Project is deployed and accessible via GitHub Pages**
✅ **DL+ Arabic Intelligence System implemented**
✅ **Temporary domain active:** https://wasalstor-web.github.io/AI-Agent-Platform/

📖 **For complete deployment information, see [DEPLOYMENT.md](DEPLOYMENT.md)**

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