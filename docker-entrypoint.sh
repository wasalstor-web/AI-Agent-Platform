#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Starting Supreme Agent...${NC}"

# Start Ollama in background
echo -e "${GREEN}Starting Ollama service...${NC}"
nohup ollama serve > /app/logs/ollama.log 2>&1 &
sleep 5

# Wait for Ollama to be ready
echo -e "${GREEN}Waiting for Ollama...${NC}"
timeout=30
counter=0
until curl -s http://localhost:11434/api/tags > /dev/null; do
    sleep 1
    counter=$((counter + 1))
    if [ $counter -ge $timeout ]; then
        echo "Ollama failed to start"
        exit 1
    fi
done
echo -e "${GREEN}Ollama is ready!${NC}"

# Pull models if needed
if [ "$PULL_MODELS" = "true" ]; then
    echo -e "${GREEN}Pulling models...${NC}"
    ollama pull llama3 || true
    ollama pull aya || true
    ollama pull mistral || true
fi

# Create custom model if Modelfile exists
if [ -f "/app/models/Modelfile" ]; then
    echo -e "${GREEN}Creating supreme-executor model...${NC}"
    ollama create supreme-executor -f /app/models/Modelfile || true
fi

# Start based on command
case "$1" in
    api)
        echo -e "${GREEN}Starting API Server...${NC}"
        cd /app
        python3 api/server.py
        ;;
    web)
        echo -e "${GREEN}Starting Web Server...${NC}"
        cd /app/web
        python3 -m http.server $WEB_PORT
        ;;
    all)
        echo -e "${GREEN}Starting all services...${NC}"
        cd /app
        python3 api/server.py &
        cd /app/web
        python3 -m http.server $WEB_PORT
        ;;
    *)
        echo "Usage: $0 {api|web|all}"
        exit 1
        ;;
esac
