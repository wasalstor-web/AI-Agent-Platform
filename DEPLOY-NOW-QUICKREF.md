# DEPLOY-NOW.sh Quick Reference
# مرجع سريع لـ DEPLOY-NOW.sh

## 🚀 Quick Commands / الأوامر السريعة

```bash
# API-only mode (commit 670b146)
bash DEPLOY-NOW.sh --api

# Full deployment
bash DEPLOY-NOW.sh

# With premium features
bash DEPLOY-NOW.sh --premium

# Show help
bash DEPLOY-NOW.sh --help
```

## 🌐 Access URLs / روابط الوصول

| Service | URL | Port |
|---------|-----|------|
| Flask API | http://localhost:5000 | 5000 |
| DL+ System | http://localhost:8000 | 8000 |
| Web Dashboard | http://localhost:8080/index.html | 8080 |
| Domain 2 | mbst.space | - |

## 📋 8 AI Models / 8 نماذج

1. GPT-3.5 Turbo (OpenAI)
2. GPT-4 (OpenAI)
3. Claude 3 (Anthropic)
4. LLaMA 3 (Meta)
5. Qwen Arabic (Alibaba)
6. AraBERT (AUB)
7. Mistral (Mistral AI)
8. DeepSeek Coder (DeepSeek)

## 🧪 Test Endpoints / نقاط الاختبار

```bash
# Flask API
curl http://localhost:5000/api/health
curl http://localhost:5000/api/models

# DL+ System
curl http://localhost:8000/api/health
curl http://localhost:8000/api/status
```

## 🛑 Stop Services / إيقاف الخدمات

```bash
# Stop all
kill $(cat /tmp/deploy-now-*.pid 2>/dev/null)

# Or press Ctrl+C
```

## 📁 Log Files / ملفات السجلات

```bash
# View logs
tail -f /tmp/flask-api.log
tail -f /tmp/dlplus.log
tail -f /tmp/web-server.log
```

## 🔧 Environment Variables / متغيرات البيئة

```bash
export HOSTINGER_DOMAIN_2="your-domain.com"
export HOSTINGER_API_KEY="your-api-key"
```

## 📚 Documentation / التوثيق

- Full Guide: [DEPLOY-NOW-README.md](./DEPLOY-NOW-README.md)
- Main README: [README.md](./README.md)
