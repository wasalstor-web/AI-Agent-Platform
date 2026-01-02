# ⚡ إعداد VPS السريع - ملخص
# Quick VPS Setup - Summary

## 🎯 المشاكل الموجودة (بسيطة):

1. ✅ **توكنات مكشوفة** → سيتم نقلها لـ `.env` تلقائياً
2. ✅ **CORS مفتوح** → سيتم تقييده تلقائياً
3. ⚠️ **TODO معلقة** → لا تؤثر على التشغيل

**الخلاصة**: المشاكل بسيطة وتم حلها في سكربت التثبيت! ✅

---

## 🚀 التثبيت السريع (أمر واحد):

```bash
# استنساخ المشروع
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# تشغيل سكربت التثبيت الكامل
bash install-complete-vps.sh your-domain.com
```

**هذا كل شيء!** السكربت سيقوم بـ:
- ✅ تثبيت جميع المتطلبات
- ✅ إعداد Python وبيئة التطوير
- ✅ تثبيت Docker و Docker Compose
- ✅ إعداد Nginx
- ✅ توليد مفاتيح آمنة
- ✅ إنشاء ملف `.env` آمن
- ✅ إعداد systemd service
- ✅ إعداد الجدار الناري

---

## 📦 ما سيتم تثبيته:

### البرمجيات الأساسية:
- Python 3.8+ و pip و venv
- Nginx (خادم الويب)
- MySQL & Redis (قواعد البيانات)
- Docker & Docker Compose
- Ollama (اختياري)
- Git, curl, wget, openssl
- UFW (الجدار الناري)
- Certbot (للـ SSL)

### مكتبات Python:
- FastAPI, Uvicorn
- جميع المكتبات من `requirements.txt`

---

## 🔐 المفاتيح الآمنة:

سيتم توليدها تلقائياً:
- `FASTAPI_SECRET_KEY`
- `HOSTINGER_API_KEY`
- `WEBUI_SECRET_KEY`
- `KHALID_TOKEN` (بدلاً من المكشوف)
- `AGENT_TOKEN` (بدلاً من المكشوف)

**جميعها محفوظة في `.env` آمن!**

---

## ✅ بعد التثبيت:

1. **إعداد SSL**:
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

2. **تحديث ملفات PHP** (استخدام التوكنات من `.env`):
   - `onlainee.space/command-center.php`
   - `onlainee.space/api/agent-webhook.php`

3. **فحص الخدمة**:
   ```bash
   sudo systemctl status ai-agent-platform
   curl http://localhost:8000/api/health
   ```

---

## 📚 للمزيد من التفاصيل:

راجع: `VPS_INSTALLATION_GUIDE.md`

---

**تم إعداد الدليل بواسطة**: خليف 'ذيبان' العنزي

