# OpenWebUI Integration Guide

## Overview

This document provides comprehensive information about the OpenWebUI integration in the AI-Agent-Platform project.

## What is OpenWebUI?

OpenWebUI (formerly Ollama WebUI) is an extensible, feature-rich, and user-friendly self-hosted web interface designed to operate entirely offline. It supports various LLM runners, including Ollama and OpenAI-compatible APIs.

### Key Features

- 🎨 **Intuitive Interface**: Clean, modern chat interface similar to ChatGPT
- 🔌 **Multiple Backend Support**: Works with Ollama, OpenAI API, and other compatible APIs
- 📱 **Responsive Design**: Works seamlessly on desktop, tablet, and mobile devices
- 🔐 **User Management**: Built-in authentication and multi-user support
- 💬 **Chat Features**: Multiple conversations, message editing, regeneration
- 📝 **Rich Content**: Markdown support, code syntax highlighting, LaTeX rendering
- 🌐 **Multilingual**: Interface available in multiple languages
- 🔒 **Privacy-Focused**: Can run completely offline
- 📦 **Model Management**: Download, update, and manage AI models
- 🎯 **Customizable**: Themes, settings, and configuration options

## Installation

### Prerequisites

- Ubuntu/Debian-based VPS or server
- Root or sudo access
- Minimum 2GB RAM recommended
- 10GB+ free disk space

### Quick Installation

```bash
# Clone the repository (if not already done)
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# Run the setup script
./setup-openwebui.sh
```

The script will:
1. Check for Docker and Docker Compose
2. Install them if not present
3. Set up OpenWebUI container
4. Optionally install Ollama
5. Configure Nginx reverse proxy (optional)

### Automated Installation

For non-interactive installation (useful for CI/CD or scripts):

```bash
./setup-openwebui.sh install
```

## Configuration

### Environment Variables

Configure OpenWebUI by setting environment variables in `.env` file:

```bash
# Copy example configuration
cp .env.example .env

# Edit the configuration
nano .env
```

Available configuration options:

| Variable | Default | Description |
|----------|---------|-------------|
| `OPENWEBUI_PORT` | 3000 | Port where OpenWebUI will be accessible |
| `OPENWEBUI_HOST` | 0.0.0.0 | Host interface to bind to |
| `OPENWEBUI_VERSION` | latest | Docker image version to use |
| `OLLAMA_API_BASE_URL` | http://localhost:11434 | Ollama API endpoint |
| `WEBUI_SECRET_KEY` | (generated) | Secret key for sessions (generate with `openssl rand -hex 32`) |

### Docker Compose Configuration

The setup script creates a `docker-compose.yml` file in `/opt/openwebui/`:

```yaml
version: '3.8'

services:
  openwebui:
    image: ghcr.io/open-webui/open-webui:latest
    container_name: openwebui
    restart: unless-stopped
    ports:
      - "3000:8080"
    volumes:
      - openwebui_data:/app/backend/data
    environment:
      - OLLAMA_API_BASE_URL=http://localhost:11434
      - WEBUI_SECRET_KEY=your-secret-key
      - WEBUI_AUTH=true
    networks:
      - openwebui_network
```

## Usage

### Accessing OpenWebUI

After installation, access OpenWebUI at:

**Local Access:**
```
http://localhost:3000
```

**Remote Access:**
```
http://your-vps-ip:3000
```

**Domain Access (with Nginx):**
```
http://ai.yourdomain.com
https://ai.yourdomain.com  # with SSL
```

### First-Time Setup

1. **Create Admin Account**
   - Navigate to OpenWebUI URL
   - Click "Sign Up"
   - Enter email and password
   - First user becomes admin automatically

2. **Configure Models**
   - Go to Settings → Models
   - If using Ollama, models will appear automatically
   - For OpenAI API, add your API key

3. **Start Chatting**
   - Select a model from dropdown
   - Type your message
   - Press Enter or click Send

## Management

### Using the Setup Script

The `setup-openwebui.sh` script provides a management interface:

```bash
./setup-openwebui.sh
```

Menu options:
1. **Install OpenWebUI** - Full installation process
2. **Show Status** - Display current status
3. **Show Logs** - View real-time logs
4. **Restart** - Restart the service
5. **Stop Service** - Stop OpenWebUI
6. **Configure Nginx** - Setup reverse proxy
7. **Install Ollama** - Install Ollama locally
8. **Exit**

### Command Line Management

Direct commands for common operations:

```bash
# Check status
./setup-openwebui.sh status

# View logs
./setup-openwebui.sh logs

# Restart service
./setup-openwebui.sh restart

# Stop service
./setup-openwebui.sh stop
```

### Manual Docker Management

For advanced users who prefer direct Docker commands:

```bash
# Navigate to OpenWebUI directory
cd /opt/openwebui

# View status
docker compose ps

# View logs
docker compose logs -f

# Restart
docker compose restart

# Stop
docker compose down

# Start
docker compose up -d

# Update to latest version
docker compose pull
docker compose up -d
```

## Integration with Smart Deploy

OpenWebUI is integrated into the Smart Deploy menu:

```bash
./smart-deploy.sh
```

Select option **10) إدارة OpenWebUI** to access OpenWebUI management.

## Nginx Reverse Proxy

### Benefits

- Access via domain name instead of IP:PORT
- SSL/HTTPS support
- Better security with proper headers
- Professional appearance

### Setup

1. **Automatic Setup (Recommended)**
   ```bash
   ./setup-openwebui.sh
   # Select option 6: Configure Nginx
   ```

2. **Manual Setup**

   Create Nginx configuration:
   ```bash
   sudo nano /etc/nginx/sites-available/openwebui
   ```

   Add configuration:
   ```nginx
   server {
       listen 80;
       server_name ai.yourdomain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           
           # WebSocket support
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           
           # Timeouts
           proxy_connect_timeout 60s;
           proxy_send_timeout 60s;
           proxy_read_timeout 60s;
       }
   }
   ```

   Enable and reload:
   ```bash
   sudo ln -s /etc/nginx/sites-available/openwebui /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### SSL Certificate

Setup SSL with Certbot:

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d ai.yourdomain.com
```

## Ollama Integration

### What is Ollama?

Ollama is a lightweight, easy-to-use tool for running large language models locally. It supports models like Llama 2, Mistral, Codellama, and many others.

### Installing Ollama

**Option 1: During OpenWebUI Setup**
- The setup script will ask if you want to install Ollama
- Select "Yes" when prompted

**Option 2: Manual Installation**
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

**Option 3: Via Setup Script**
```bash
./setup-openwebui.sh
# Select option 7: Install Ollama
```

### Managing Models

After installing Ollama, download models:

```bash
# List available models
ollama list

# Pull a model
ollama pull llama2
ollama pull mistral
ollama pull codellama

# Run a model (test)
ollama run llama2

# Remove a model
ollama rm llama2
```

### Popular Models

| Model | Size | Use Case |
|-------|------|----------|
| llama2 | 3.8GB | General purpose, good balance |
| llama2:13b | 7.4GB | Better quality, needs more RAM |
| mistral | 4.1GB | Fast and capable, great for chat |
| codellama | 3.8GB | Code generation and understanding |
| phi | 1.6GB | Small, fast, efficient |
| neural-chat | 4.1GB | Conversational AI |

### Ollama API

Ollama runs an API server on port 11434:

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Generate text
curl http://localhost:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "Hello, how are you?"
}'
```

## Troubleshooting

### OpenWebUI Not Starting

**Check Docker status:**
```bash
sudo systemctl status docker
sudo systemctl start docker
```

**Check container logs:**
```bash
cd /opt/openwebui
docker compose logs
```

**Verify port is available:**
```bash
sudo netstat -tlnp | grep 3000
```

### Cannot Connect to OpenWebUI

**Check firewall:**
```bash
sudo ufw status
sudo ufw allow 3000/tcp
```

**Verify container is running:**
```bash
docker ps | grep openwebui
```

### Ollama Connection Issues

**Check Ollama is running:**
```bash
sudo systemctl status ollama
sudo systemctl start ollama
```

**Test Ollama API:**
```bash
curl http://localhost:11434/api/tags
```

**Update OpenWebUI environment:**
```bash
cd /opt/openwebui
nano docker-compose.yml
# Update OLLAMA_API_BASE_URL if needed
docker compose restart
```

### Performance Issues

**Check system resources:**
```bash
free -h  # Memory
df -h    # Disk space
htop     # CPU and processes
```

**Reduce model size:**
- Use smaller models (phi, mistral instead of llama2:13b)
- Limit concurrent users
- Increase server resources

### Database/Data Issues

**Reset OpenWebUI data:**
```bash
cd /opt/openwebui
docker compose down -v  # WARNING: Deletes all data
docker compose up -d
```

**Backup data:**
```bash
docker cp openwebui:/app/backend/data ./backup-data
```

**Restore data:**
```bash
docker cp ./backup-data openwebui:/app/backend/data
docker compose restart
```

## VPS Connection Check

The platform includes automated checks for OpenWebUI services:

```bash
# Full VPS check including OpenWebUI
./deploy.sh --host your-vps.com
```

The check will verify:
- ✓ Port 3000 (OpenWebUI) is accessible
- ✓ Port 11434 (Ollama) is accessible
- ✓ OpenWebUI web interface is responding
- ✓ Ollama API is responding

## Security Best Practices

### 1. Secure the Admin Account

- Use a strong password
- Don't share admin credentials
- Create separate user accounts for each person

### 2. Use HTTPS

- Always setup SSL with Certbot
- Redirect HTTP to HTTPS
- Use strong cipher suites

### 3. Firewall Configuration

```bash
# Allow only necessary ports
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### 4. Keep Software Updated

```bash
# Update system
sudo apt update && sudo apt upgrade

# Update Docker images
cd /opt/openwebui
docker compose pull
docker compose up -d

# Update Ollama
curl -fsSL https://ollama.ai/install.sh | sh
```

### 5. Regular Backups

```bash
# Backup OpenWebUI data
docker cp openwebui:/app/backend/data ./backup-$(date +%Y%m%d)

# Backup docker-compose configuration
cp /opt/openwebui/docker-compose.yml ./backup-compose-$(date +%Y%m%d).yml
```

### 6. Monitor Logs

```bash
# Check for suspicious activity
cd /opt/openwebui
docker compose logs --tail=100

# Setup log rotation
sudo nano /etc/docker/daemon.json
```

Add:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

## Advanced Configuration

### Custom Models

You can add custom models or external APIs:

1. **OpenAI API**
   - Go to Settings → Connections
   - Add OpenAI API key
   - Select GPT models

2. **Custom Ollama Models**
   - Create Modelfile
   - Import into Ollama
   - Available in OpenWebUI

3. **Remote Ollama Instance**
   - Update `OLLAMA_API_BASE_URL` in docker-compose.yml
   - Point to remote server
   - Ensure network connectivity

### Scaling

For high-traffic scenarios:

1. **Multiple Instances**
   ```bash
   # Use load balancer (nginx) to distribute traffic
   # Run multiple OpenWebUI containers on different ports
   ```

2. **Database External**
   - Move to PostgreSQL or MySQL
   - Update connection in docker-compose.yml

3. **Resource Limits**
   ```yaml
   # Add to docker-compose.yml
   deploy:
     resources:
       limits:
         cpus: '2'
         memory: 4G
   ```

### Integration with Other Services

**Webhook Integration:**
- Configure webhooks in OpenWebUI settings
- Integrate with Slack, Discord, Teams

**API Access:**
- OpenWebUI provides REST API
- Documentation available at `/api/docs`

## Maintenance

### Regular Tasks

**Daily:**
- Monitor logs for errors
- Check service status

**Weekly:**
- Review user activity
- Check disk space
- Backup important data

**Monthly:**
- Update Docker images
- Update system packages
- Review and rotate logs
- Security audit

### Monitoring Scripts

Create a monitoring script:

```bash
#!/bin/bash
# /opt/scripts/monitor-openwebui.sh

cd /opt/openwebui

# Check if container is running
if ! docker compose ps | grep -q "Up"; then
    echo "OpenWebUI is down! Restarting..."
    docker compose up -d
    # Send alert (email, slack, etc.)
fi

# Check disk space
DISK_USAGE=$(df -h /opt | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "Warning: Disk usage is ${DISK_USAGE}%"
    # Send alert
fi
```

Add to crontab:
```bash
crontab -e
# Add: */5 * * * * /opt/scripts/monitor-openwebui.sh
```

## Resources

### Official Links

- **OpenWebUI GitHub**: https://github.com/open-webui/open-webui
- **OpenWebUI Documentation**: https://docs.openwebui.com
- **Ollama Website**: https://ollama.ai
- **Ollama GitHub**: https://github.com/ollama/ollama
- **Ollama Models**: https://ollama.ai/library

### Community

- **Discord**: Join OpenWebUI community
- **GitHub Issues**: Report bugs and feature requests
- **Discussions**: Ask questions and share tips

### Learning Resources

- **LLM Basics**: Understanding large language models
- **Prompt Engineering**: Crafting effective prompts
- **Model Comparison**: Choosing the right model
- **Fine-tuning**: Customizing models for specific tasks

## FAQ

**Q: How much RAM do I need?**
A: Minimum 2GB for the interface, 4GB+ recommended. For models: Phi (2GB), Llama2 (8GB), Llama2:13b (16GB).

**Q: Can I use OpenAI models?**
A: Yes! Add your OpenAI API key in settings to use GPT models.

**Q: Is my data secure?**
A: When running locally with Ollama, everything stays on your server. No data leaves your infrastructure.

**Q: Can multiple users use it simultaneously?**
A: Yes, OpenWebUI supports multiple concurrent users with separate accounts.

**Q: How do I update OpenWebUI?**
A: Run `cd /opt/openwebui && docker compose pull && docker compose up -d`

**Q: Can I use it without internet?**
A: Yes, once Ollama and models are installed, it works completely offline.

**Q: What's the difference between OpenWebUI and ChatGPT?**
A: OpenWebUI is self-hosted, private, and can use various models including local ones. ChatGPT is cloud-based.

**Q: Can I customize the interface?**
A: Yes, OpenWebUI supports themes and various customization options in settings.

## Support

For issues related to:

**AI-Agent-Platform Integration:**
- Open an issue: https://github.com/wasalstor-web/AI-Agent-Platform/issues
- Check documentation: [README.md](README.md)

**OpenWebUI Itself:**
- OpenWebUI GitHub: https://github.com/open-webui/open-webui/issues
- OpenWebUI Docs: https://docs.openwebui.com

**Ollama:**
- Ollama GitHub: https://github.com/ollama/ollama/issues
- Ollama Docs: https://ollama.ai/docs

## Changelog

### 2025-10-20
- Initial OpenWebUI integration
- Created setup script with bilingual support
- Added to smart-deploy menu
- Integrated with VPS connection checks
- Complete documentation

## License

This integration guide is part of the AI-Agent-Platform project.

OpenWebUI is licensed under the MIT License.
Ollama is licensed under the MIT License.

---

**AI-Agent-Platform** © 2025
