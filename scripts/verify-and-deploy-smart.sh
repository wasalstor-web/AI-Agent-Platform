#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_URL="https://github.com/wasalstor-web/AI-Agent-Platform.git"
REPO_DIR="$HOME/AI-Agent-Platform"
BRANCH="main"
LOCK_FILE="/tmp/dlplus_deploy.lock"
LOG_FILE="/tmp/dlplus_deploy.log"
DEPLOY_LOG="$REPO_DIR/DEPLOY.md"

timestamp(){ date +"%Y-%m-%d %H:%M:%S"; }
log(){ mkdir -p "$(dirname "$DEPLOY_LOG")" "$(dirname "$LOG_FILE")" 2>/dev/null || true; echo "[$(timestamp)] $*" | tee -a "$LOG_FILE" "$DEPLOY_LOG" >/dev/null; }

if [ -f "$LOCK_FILE" ]; then log "⚠️ Deployment already running."; exit 0; fi
trap 'rm -f "$LOCK_FILE"' EXIT
touch "$LOCK_FILE"

log "🚀 DL+ Smart Verify-and-Deploy Started"

if ping -c 1 github.com >/dev/null 2>&1; then log "✅ Internet OK"; else log "❌ No Internet"; exit 1; fi

if [ ! -d "$REPO_DIR/.git" ]; then
  log "📥 Cloning repo..."; git clone --depth=1 --branch "$BRANCH" "$REPO_URL" "$REPO_DIR" || { log "❌ Clone failed"; exit 1; }
else
  log "🔄 Updating repo..."; cd "$REPO_DIR"; git fetch origin "$BRANCH"; git reset --hard "origin/$BRANCH" || log "⚠️ reset failed"
fi

cd "$REPO_DIR"
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
[[ "$REMOTE_URL" != *"AI-Agent-Platform.git"* ]] && git remote set-url origin "$REPO_URL" && log "✅ Remote fixed"

command -v docker >/dev/null || { log "🔧 Installing Docker..."; sudo apt update -y && sudo apt install -y docker.io docker-compose; }
systemctl is-active --quiet docker || sudo systemctl enable --now docker || log "⚠️ Docker failed to start"

for i in 1 2 3; do
  log "🧠 Deployment attempt $i..."
  if bash autonomous-deploy.sh >>"$LOG_FILE" 2>&1; then log "✅ Success on attempt $i"; break; fi
  [ "$i" -eq 3 ] && log "❌ Failed after 3 tries" && exit 1; sleep 10
done

declare -A PORTS=([8080]="OpenWebUI" [8000]="API Gateway" [11434]="Ollama" [6333]="Qdrant")
for P in "${!PORTS[@]}"; do
  if curl -fsS --max-time 4 "http://127.0.0.1:$P" >/dev/null 2>&1; then
    log "✅ ${PORTS[$P]} OK ($P)"
  else
    log "⚠️ ${PORTS[$P]} down ($P)"
  fi
done

PUBLIC_IP=$(curl -fsS https://ifconfig.me || echo "unknown")
log "🌐 IP: $PUBLIC_IP"
log "✅ DL+ Verify-and-Deploy Completed"
echo "🌍 WebUI: http://${PUBLIC_IP}:8080"
echo "🧠 API:   http://${PUBLIC_IP}:8000"
