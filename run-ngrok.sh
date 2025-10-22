#!/bin/bash
# Simple helper to expose OpenWebUI or DL+ via ngrok (for testing only).
# Usage: ./run-ngrok.sh openwebui  OR ./run-ngrok.sh dlplus
set -e

if ! command -v ngrok >/dev/null 2>&1; then
  echo "ngrok not found. Install ngrok and authenticate first: https://ngrok.com"
  exit 1
fi

TARGET="$1"
if [ "$TARGET" = "openwebui" ]; then
  PORT=3000
elif [ "$TARGET" = "dlplus" ]; then
  PORT=8000
else
  echo "Usage: $0 {openwebui|dlplus}"
  exit 1
fi

echo "Starting ngrok tunnel to http://localhost:${PORT} ..."
ngrok http ${PORT}
