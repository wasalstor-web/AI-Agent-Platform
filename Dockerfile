# Dockerfile for AI Agent Platform - DL+ System
# دوكرفايل لمنصة وكيل الذكاء الاصطناعي - نظام DL+

FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Update CA certificates
RUN update-ca-certificates

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
# Use trusted host flags as a workaround for SSL issues in some environments
RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt

# Copy application code
COPY dlplus/ ./dlplus/
COPY api/ ./api/
COPY .env.example .env

# Create logs directory
RUN mkdir -p logs

# Expose ports
# 8000: DL+ System API
# 5000: Flask API Server
EXPOSE 8000 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/api/health || exit 1

# Default command runs the DL+ simple server
CMD ["python", "-m", "dlplus.simple_server"]
