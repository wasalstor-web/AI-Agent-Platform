#!/bin/bash
# Hostinger Server Setup Script for AI Agent Platform
# This script sets up FastAPI service and connects to Hostinger server

set -e

echo "================================"
echo "Hostinger Server Setup Script"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Install required packages
echo -e "${YELLOW}Installing required packages...${NC}"
sudo apt install -y python3 python3-pip python3-venv git nginx curl

# Create project directory
PROJECT_DIR="/var/www/ai-agent-platform"
echo -e "${YELLOW}Creating project directory: ${PROJECT_DIR}${NC}"
sudo mkdir -p ${PROJECT_DIR}
sudo chown -R $USER:$USER ${PROJECT_DIR}

# Setup Python virtual environment
echo -e "${YELLOW}Setting up Python virtual environment...${NC}"
cd ${PROJECT_DIR}
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
echo -e "${YELLOW}Installing Python dependencies...${NC}"
pip install --upgrade pip
pip install fastapi uvicorn aiohttp python-dotenv

# Create environment file
echo -e "${YELLOW}Creating .env configuration file...${NC}"
cat > .env << 'EOF'
# Hostinger Server Configuration
HOSTINGER_API_KEY=your-secret-api-key-here
HOSTINGER_SERVER_URL=http://localhost:8000
FASTAPI_PORT=8000
FASTAPI_HOST=0.0.0.0

# Security Settings
ALLOWED_COMMANDS=file_create,file_read,file_update,file_delete,service_restart,openwebui_manage,log_view,status_check,backup_create
ALLOWED_PATHS=/var/www,/home,/tmp

# Logging
LOG_LEVEL=INFO
LOG_FILE=/var/log/ai-agent-platform/app.log
EOF

echo -e "${GREEN}Environment file created. Please edit .env with your settings.${NC}"

# Create FastAPI application
echo -e "${YELLOW}Creating FastAPI application...${NC}"
cat > main.py << 'EOF'
from fastapi import FastAPI, HTTPException, Header
from typing import Optional
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="AI Agent Platform - Hostinger API")

API_KEY = os.getenv("HOSTINGER_API_KEY", "your-secret-key")

def verify_api_key(x_api_key: Optional[str] = Header(None)):
    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail="Invalid API Key")
    return True

@app.get("/")
async def root():
    return {"message": "AI Agent Platform API", "status": "running"}

@app.get("/api/health")
async def health_check():
    return {"status": "healthy", "service": "ai-agent-platform"}

@app.post("/api/execute")
async def execute_command(command_data: dict, authenticated: bool = Depends(verify_api_key)):
    command_type = command_data.get("command_type")
    params = command_data.get("params", {})
    
    # Command execution logic here
    return {
        "status": "success",
        "command_type": command_type,
        "result": "Command executed successfully"
    }
EOF

# Create systemd service
echo -e "${YELLOW}Creating systemd service...${NC}"
sudo bash -c "cat > /etc/systemd/system/ai-agent-platform.service" << EOF
[Unit]
Description=AI Agent Platform FastAPI Service
After=network.target

[Service]
Type=simple
User=$USER
Group=www-data
WorkingDirectory=${PROJECT_DIR}
Environment="PATH=${PROJECT_DIR}/venv/bin"
ExecStart=${PROJECT_DIR}/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000 --reload
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create log directory
sudo mkdir -p /var/log/ai-agent-platform
sudo chown -R $USER:$USER /var/log/ai-agent-platform

# Reload systemd and start service
echo -e "${YELLOW}Starting AI Agent Platform service...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable ai-agent-platform
sudo systemctl start ai-agent-platform

# Configure Nginx
echo -e "${YELLOW}Configuring Nginx...${NC}"
sudo bash -c "cat > /etc/nginx/sites-available/ai-agent-platform" << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enable Nginx site
sudo ln -sf /etc/nginx/sites-available/ai-agent-platform /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

# Open firewall port
echo -e "${YELLOW}Configuring firewall...${NC}"
sudo ufw allow 80/tcp
sudo ufw allow 8000/tcp

# Test the service
sleep 3
echo -e "${YELLOW}Testing the service...${NC}"
curl -s http://localhost:8000/api/health || echo -e "${RED}Service test failed${NC}"

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${YELLOW}Important Files:${NC}"
echo "  - Application: ${PROJECT_DIR}/main.py"
echo "  - Config: ${PROJECT_DIR}/.env"
echo "  - Service: /etc/systemd/system/ai-agent-platform.service"
echo "  - Nginx: /etc/nginx/sites-available/ai-agent-platform"
echo ""