# تنفيذ الأوامر على خادم Hostinger
# Command Execution on Hostinger Server

## 🎯 نظرة عامة / Overview

**نعم، يمكن لنظام DL+ تنفيذ الأوامر على الخادم المرتبط معه على Hostinger!**

**Yes, the DL+ system can execute commands on the connected Hostinger server!**

نظام DL+ مصمم خصيصاً للعمل بين بيئتين:
- **GitHub**: مركز الذكاء والتحليل والقرار
- **Hostinger**: بيئة التنفيذ والنشر

The DL+ system is specifically designed to work between two environments:
- **GitHub**: Intelligence, analysis, and decision center
- **Hostinger**: Execution and deployment environment

---

## ✅ القدرات المتاحة / Available Capabilities

يوفر نظام DL+ واجهة آمنة لتنفيذ الأوامر التالية على خادم Hostinger:

The DL+ system provides a secure interface for executing the following commands on Hostinger server:

### 1. إدارة الملفات / File Management

#### إنشاء ملف / Create File
```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "file_create",
    "payload": {
      "path": "data/test.txt",
      "content": "مرحباً من نظام DL+"
    }
  }'
```

#### تحديث ملف / Update File
```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "file_update",
    "payload": {
      "path": "data/test.txt",
      "content": "محتوى محدث"
    }
  }'
```

#### قراءة ملف / Read File
```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "file_read",
    "payload": {
      "path": "data/test.txt"
    }
  }'
```

#### حذف ملف / Delete File
```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "file_delete",
    "payload": {
      "path": "data/test.txt"
    }
  }'
```

### 2. إدارة الخدمات / Service Management

#### إعادة تشغيل خدمة / Restart Service
```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "service_restart",
    "payload": {
      "service": "openwebui"
    }
  }'
```

**الخدمات المسموح بها / Allowed Services:**
- `openwebui` - واجهة OpenWebUI
- `nginx` - خادم الويب
- `ollama` - خدمة Ollama AI

### 3. إدارة OpenWebUI / OpenWebUI Management

```bash
# بدء OpenWebUI / Start OpenWebUI
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "openwebui_manage",
    "payload": {
      "action": "start"
    }
  }'

# إيقاف OpenWebUI / Stop OpenWebUI
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "openwebui_manage",
    "payload": {
      "action": "stop"
    }
  }'

# إعادة تشغيل OpenWebUI / Restart OpenWebUI
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "openwebui_manage",
    "payload": {
      "action": "restart"
    }
  }'

# فحص حالة OpenWebUI / Check OpenWebUI Status
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "openwebui_manage",
    "payload": {
      "action": "status"
    }
  }'
```

### 4. عرض السجلات / View Logs

```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "log_view",
    "payload": {
      "log_type": "execution",
      "lines": 50
    }
  }'
```

### 5. فحص الحالة / Status Check

```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "status_check",
    "payload": {}
  }'
```

### 6. إنشاء نسخة احتياطية / Create Backup

```bash
curl -X POST http://your-hostinger-server:8000/api/github/execute \
  -H "X-API-Key: your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "backup_create",
    "payload": {
      "type": "full"
    }
  }'
```

---

## 🔒 الأمان / Security

### نظام القائمة البيضاء / Whitelist System

النظام يستخدم قائمة بيضاء للأوامر المسموح بها فقط:

The system uses a whitelist for allowed commands only:

```python
allowed_commands = {
    'file_create',      # إنشاء ملف
    'file_update',      # تحديث ملف
    'file_read',        # قراءة ملف
    'file_delete',      # حذف ملف
    'service_restart',  # إعادة تشغيل خدمة
    'log_view',         # عرض السجلات
    'status_check',     # فحص الحالة
    'openwebui_manage', # إدارة OpenWebUI
    'backup_create'     # إنشاء نسخة احتياطية
}
```

### حماية المسارات / Path Protection

جميع عمليات الملفات محمية ضد:
- اجتياز المسار (`..` في المسار)
- المسارات المطلقة (تبدأ بـ `/`)
- الوصول خارج مجلد المشروع

All file operations are protected against:
- Path traversal (`..` in path)
- Absolute paths (starting with `/`)
- Access outside project directory

### المصادقة / Authentication

كل طلب يتطلب:
- مفتاح API صحيح في header `X-API-Key`
- التوقيع الرقمي للطلبات الحساسة

Every request requires:
- Valid API key in `X-API-Key` header
- Digital signature for sensitive requests

### تسجيل العمليات / Operation Logging

جميع الأوامر المنفذة يتم تسجيلها في سجل التنفيذ:
- الطابع الزمني
- نوع الأمر
- الحمولة
- النتيجة أو الخطأ

All executed commands are logged in execution log:
- Timestamp
- Command type
- Payload
- Result or error

---

## 🚀 الإعداد والتشغيل / Setup and Launch

### 1. تثبيت النظام على Hostinger

```bash
# الاتصال بخادم Hostinger
ssh user@your-hostinger-server.com

# استنساخ المستودع
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# تشغيل النظام
./start-dlplus.sh
```

### 2. إعداد المفاتيح السرية

```bash
# نسخ ملف الإعدادات
cp .env.dlplus.example .env

# توليد مفتاح سري آمن
echo "FASTAPI_SECRET_KEY=$(openssl rand -hex 32)" >> .env

# تحرير الإعدادات
nano .env
```

### 3. التحقق من التشغيل

```bash
# فحص صحة النظام
curl http://localhost:8000/api/health

# يجب أن ترى:
{
  "status": "healthy",
  "timestamp": "2024-01-20T10:30:00.000000"
}
```

---

## 📝 أمثلة عملية / Practical Examples

### مثال 1: إنشاء ملف تكوين

```python
import httpx
import asyncio

async def create_config_file():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "http://your-hostinger-server:8000/api/github/execute",
            headers={"X-API-Key": "your-secret-key"},
            json={
                "type": "file_create",
                "payload": {
                    "path": "config/app.yaml",
                    "content": """
# App Configuration
server:
  host: 0.0.0.0
  port: 8000
  
logging:
  level: INFO
  format: json
"""
                }
            }
        )
        print(response.json())

asyncio.run(create_config_file())
```

### مثال 2: إعادة تشغيل خدمة بعد التحديث

```python
async def update_and_restart():
    async with httpx.AsyncClient() as client:
        # 1. تحديث ملف التكوين
        await client.post(
            "http://your-hostinger-server:8000/api/github/execute",
            headers={"X-API-Key": "your-secret-key"},
            json={
                "type": "file_update",
                "payload": {
                    "path": "config/app.yaml",
                    "content": "# Updated config..."
                }
            }
        )
        
        # 2. إعادة تشغيل الخدمة
        response = await client.post(
            "http://your-hostinger-server:8000/api/github/execute",
            headers={"X-API-Key": "your-secret-key"},
            json={
                "type": "service_restart",
                "payload": {"service": "openwebui"}
            }
        )
        print(response.json())

asyncio.run(update_and_restart())
```

### مثال 3: مراقبة السجلات

```python
async def monitor_logs():
    async with httpx.AsyncClient() as client:
        while True:
            response = await client.post(
                "http://your-hostinger-server:8000/api/github/execute",
                headers={"X-API-Key": "your-secret-key"},
                json={
                    "type": "log_view",
                    "payload": {
                        "log_type": "execution",
                        "lines": 10
                    }
                }
            )
            
            logs = response.json()
            print(f"آخر {len(logs['logs'])} عملية:")
            for log in logs['logs']:
                print(f"  - {log['timestamp']}: {log['command_type']} - {log['status']}")
            
            await asyncio.sleep(60)  # تحديث كل دقيقة

asyncio.run(monitor_logs())
```

---

## 🔧 استكشاف الأخطاء / Troubleshooting

### خطأ: "Command not whitelisted"

**السبب:** الأمر المطلوب غير موجود في القائمة البيضاء.

**الحل:**
```python
# تحقق من الأوامر المسموح بها
response = await client.post(
    "http://your-hostinger-server:8000/api/github/execute",
    headers={"X-API-Key": "your-secret-key"},
    json={"type": "status_check", "payload": {}}
)
print(response.json()['allowed_commands'])
```

### خطأ: "Invalid API key"

**السبب:** مفتاح API غير صحيح أو منتهي الصلاحية.

**الحل:**
1. تحقق من ملف `.env`
2. تأكد من استخدام نفس المفتاح في الطلب
3. أعد توليد المفتاح إذا لزم الأمر

### خطأ: "Invalid file path"

**السبب:** محاولة الوصول إلى مسار غير آمن.

**الحل:**
- استخدم مسارات نسبية فقط
- تجنب استخدام `..` في المسار
- لا تستخدم `/` في بداية المسار

---

## 📚 الوثائق ذات الصلة / Related Documentation

- **[نظام DL+ الكامل](dlplus/docs/DLPLUS_SYSTEM.md)**
- **[دليل البدء السريع](DLPLUS_README.md)**
- **[واجهة FastAPI](dlplus/api/fastapi_connector.py)**
- **[واجهة التنفيذ الداخلية](dlplus/api/internal_api.py)**

---

## 🤝 المساهمة / Contributing

لإضافة أوامر جديدة:

1. افتح `dlplus/api/internal_api.py`
2. أضف نوع الأمر الجديد إلى `allowed_commands`
3. أنشئ دالة معالجة جديدة `_handle_<command_type>`
4. اختبر الأمر الجديد
5. حدّث هذه الوثائق

To add new commands:

1. Open `dlplus/api/internal_api.py`
2. Add new command type to `allowed_commands`
3. Create new handler function `_handle_<command_type>`
4. Test the new command
5. Update this documentation

---

## 📞 الدعم / Support

للمساعدة والاستفسارات:
- **GitHub Issues**: [فتح مشكلة](https://github.com/wasalstor-web/AI-Agent-Platform/issues)
- **الوثائق**: مجلد `dlplus/docs/`

For help and inquiries:
- **GitHub Issues**: [Open an issue](https://github.com/wasalstor-web/AI-Agent-Platform/issues)
- **Documentation**: `dlplus/docs/` folder

---

## ⚡ الخلاصة / Summary

**نعم، نظام DL+ قادر على تنفيذ الأوامر على خادم Hostinger بشكل آمن ومنظم!**

**Yes, the DL+ system is capable of executing commands on Hostinger server in a secure and organized manner!**

يوفر النظام:
✅ واجهة API آمنة
✅ نظام قائمة بيضاء للأوامر
✅ حماية ضد اجتياز المسارات
✅ تسجيل شامل للعمليات
✅ مصادقة قوية
✅ توثيق كامل بالعربية والإنجليزية

The system provides:
✅ Secure API interface
✅ Command whitelist system
✅ Path traversal protection
✅ Comprehensive operation logging
✅ Strong authentication
✅ Complete Arabic and English documentation

---

**🌟 ابدأ الآن / Get Started Now:**

```bash
# على خادم Hostinger / On Hostinger server
./start-dlplus.sh

# اختبر النظام / Test the system
curl http://localhost:8000/api/health
```

**🎯 للاستخدام المتقدم، راجع:**
- [دليل API الكامل](dlplus/docs/DLPLUS_SYSTEM.md)
- [أمثلة الاستخدام](examples/)
- [الكود المصدري](dlplus/api/)
