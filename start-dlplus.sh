#!/bin/bash

# DL+ System Startup Script
# سكريبت تشغيل نظام DL+

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🧠 DL+ Unified Arabic Intelligence System${NC}"
echo -e "${BLUE}   نظام DL+ للذكاء الصناعي العربي الموحد${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}المؤسس: خليف 'ذيبان' العنزي${NC}"
echo -e "${GREEN}الموقع: القصيم – بريدة – المملكة العربية السعودية${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Python installation
echo -e "${YELLOW}📋 Checking requirements...${NC}"
if ! command_exists python3; then
    echo -e "${RED}❌ Python 3 is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python 3 found${NC}"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}📦 Creating virtual environment...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✅ Virtual environment created${NC}"
fi

# Activate virtual environment
echo -e "${YELLOW}🔌 Activating virtual environment...${NC}"
source venv/bin/activate
echo -e "${GREEN}✅ Virtual environment activated${NC}"

# Check if requirements are installed
if [ ! -f "venv/.installed" ]; then
    echo -e "${YELLOW}📦 Installing requirements...${NC}"
    pip install --upgrade pip
    pip install -r requirements.txt
    touch venv/.installed
    echo -e "${GREEN}✅ Requirements installed${NC}"
else
    echo -e "${GREEN}✅ Requirements already installed${NC}"
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚙️  Creating .env file from example...${NC}"
    if [ -f ".env.dlplus.example" ]; then
        cp .env.dlplus.example .env
        echo -e "${GREEN}✅ .env file created${NC}"
        echo -e "${YELLOW}⚠️  Please edit .env file with your configuration${NC}"
    else
        echo -e "${RED}❌ .env.dlplus.example not found${NC}"
        exit 1
    fi
fi

# Create logs directory if it doesn't exist
mkdir -p logs

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🚀 Starting DL+ System...${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# Start the system
python dlplus/main.py
