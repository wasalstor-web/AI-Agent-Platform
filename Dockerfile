# Lightweight Python image for DL+ backend
FROM python:3.11-slim

# Avoid buffering
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# System deps for common Python packages (adjust if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for layer caching
COPY requirements.txt /app/requirements.txt

RUN pip install --upgrade pip setuptools wheel \
    && pip install -r /app/requirements.txt

# Copy project
COPY . /app

# Create logs dir
RUN mkdir -p /app/logs

# Expose backend port
EXPOSE 8000

# Default env file loader: if user mounted .env or used env vars it will be used.
# Start command: prefer the project's entrypoint script if present
# Fallback to running dlplus/main.py
CMD ["bash", "-lc", "if [ -f ./start-dlplus.sh ]; then bash ./start-dlplus.sh; else python dlplus/main.py; fi"]