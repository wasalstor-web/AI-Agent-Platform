#!/bin/bash

# Quick Local Test Server
# خادم اختبار محلي سريع

PORT=${1:-8000}

echo "🚀 Starting local server on port $PORT..."
echo "🌐 Open your browser at: http://localhost:$PORT"
echo "⏹️  Press Ctrl+C to stop"
echo ""

# Try to open browser automatically
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:$PORT" 2>/dev/null &
elif command -v open &> /dev/null; then
    open "http://localhost:$PORT" 2>/dev/null &
fi

# Start Python HTTP server
python3 -m http.server "$PORT"
