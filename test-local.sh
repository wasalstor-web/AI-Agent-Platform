#!/bin/bash

# Quick Local Test Server
# خادم اختبار محلي سريع

set -e

PORT=${1:-8000}

echo "🚀 Starting local server on port $PORT..."
echo "🌐 Open your browser at: http://localhost:$PORT"
echo "⏹️  Press Ctrl+C to stop"
echo ""

# Try to open browser automatically (ignore errors)
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:$PORT" 2>/dev/null || true &
elif command -v open &> /dev/null; then
    open "http://localhost:$PORT" 2>/dev/null || true &
fi

# Start Python HTTP server (try python3 first, then python)
if command -v python3 &> /dev/null; then
    python3 -m http.server "$PORT"
elif command -v python &> /dev/null; then
    python -m http.server "$PORT"
else
    echo "❌ Error: Python is not installed"
    echo "Please install Python 3 to use this script"
    exit 1
fi
