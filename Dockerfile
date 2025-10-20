FROM python:3.11-slim

# Metadata
LABEL maintainer="wasalstor-web"
LABEL description="Supreme Agent - Integrated AI Agent Platform"
LABEL version="1.0.0"

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.ai/install.sh | sh

# Copy project files
COPY . /app/

# Install Python dependencies
RUN pip install --no-cache-dir \
    requests \
    flask \
    flask-cors

# Create directories
RUN mkdir -p /app/logs /app/data

# Make scripts executable
RUN chmod +x /app/scripts/*.sh /app/scripts/*.py /app/api/server.py

# Expose ports
# 5000 - API Server
# 8080 - Web Interface
# 11434 - Ollama
# 3000 - OpenWebUI (optional)
EXPOSE 5000 8080 11434 3000

# Environment variables
ENV OLLAMA_HOST=http://localhost:11434
ENV API_HOST=0.0.0.0
ENV API_PORT=5000
ENV WEB_PORT=8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5000/api/health || exit 1

# Start script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["api"]
