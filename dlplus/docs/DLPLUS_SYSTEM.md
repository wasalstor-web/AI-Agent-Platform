# 🧠 نظام DL+ للذكاء الصناعي العربي الموحد

## DL+ Unified Arabic Intelligence System

**النسخة التنفيذية الجاهزة - GitHub Intelligence + Hostinger Integration**

---

## 📋 المحتويات

1. [نظرة عامة](#نظرة-عامة)
2. [البنية المعمارية](#البنية-المعمارية)
3. [المكونات الأساسية](#المكونات-الأساسية)
4. [التثبيت والإعداد](#التثبيت-والإعداد)
5. [الاستخدام](#الاستخدام)
6. [واجهات API](#واجهات-api)
7. [الأمثلة](#الأمثلة)
8. [الأسئلة الشائعة](#الأسئلة-الشائعة)

---

## 🎯 نظرة عامة

### الهدف

إنشاء منظومة ذكاء صناعي عربية فصيحة تعمل كنظام موحد مكوّن من 3 طبقات مترابطة:

1. **GitHub** — مركز الذكاء والنماذج
2. **Hostinger** — بيئة تشغيل الواجهة والتنفيذ
3. **OpenWeb Interface** — الواجهة التفاعلية للمستخدم

### المميزات الرئيسية

✅ **ذكاء صناعي كامل** داخل GitHub (بدون سيرفرات ثقيلة)  
✅ **واجهة OpenWeb** على Hostinger لسهولة الوصول والتفاعل  
✅ **ربط مباشر** بين GitHub ↔ Hostinger عبر FastAPI  
✅ **تنفيذ أوامر فعلية** داخل Hostinger عند الحاجة  
✅ **تعلم ذاتي لغوي** مستمر بالعربية الفصحى  
✅ **بنية قابلة للتوسع** وإضافة وكلاء وواجهات جديدة

---

## 🏗️ البنية المعمارية

### الطبقات الثلاث

```
[المستخدم]
   ⇅
[واجهة OpenWebUI (على Hostinger)]
   ⇅
[FastAPI Connector (Hostinger)]
   ⇅
[GitHub Intelligence Core]
   ⇅
[Internal Execution API (Hostinger)]
```

### توزيع المسؤوليات

| الجهة            | الوظيفة                               | مستوى الذكاء    |
| ---------------- | ------------------------------------- | --------------- |
| **GitHub**       | التفكير، التحليل، التوليد، القرار     | 🧠 ذكاء كامل    |
| **Hostinger**    | تنفيذ الأوامر البسيطة + تشغيل الواجهة | ⚙️ ذراع تنفيذية |
| **OpenWebUI**    | التفاعل مع المستخدم + عرض النتائج     | 💬 واجهة تواصل  |
| **FastAPI**      | القناة التي تنقل الرسائل والأوامر     | 🔗 جسر اتصال    |
| **Internal API** | تنفيذ فعلي داخل Hostinger             | ⚡ موجه التنفيذ  |

---

## 🧩 المكونات الأساسية

### 1. GitHub Intelligence Core (نواة الذكاء)

**الموقع:** `dlplus/core/`

المكونات:
- `intelligence_core.py` - المحرك الرئيسي للذكاء
- `arabic_processor.py` - معالج اللغة العربية
- `context_analyzer.py` - محلل السياق

**المهام:**
- فهم أوامر المستخدم وتحليل النية
- اختيار النموذج أو الوكيل الأنسب للتنفيذ
- دمج نتائج النماذج في استجابة موحدة
- توليد الرد بالعربية الفصحى
- تنفيذ العمليات داخل GitHub
- إرسال أوامر تنفيذية إلى Hostinger

**النماذج المدعومة:**
- AraBERT - فهم اللغة العربية
- CAMeLBERT - تحليل النصوص العربية
- Qwen 2.5 Arabic - التوليد والاستدلال
- LLaMA 3 - التفكير والبرمجة
- DeepSeek - البرمجة المتقدمة
- Mistral - التوليد متعدد اللغات

### 2. FastAPI Connector (موصل FastAPI)

**الموقع:** `dlplus/api/fastapi_connector.py`

**الوظائف:**
- البوابة الرسمية للاتصال بين GitHub وHostinger
- استقبال الطلبات من GitHub
- إرسال النتائج إلى OpenWebUI
- المصادقة والأمان
- إدارة الجلسات

**نقاط النهاية الرئيسية:**
- `GET /` - معلومات النظام
- `GET /api/health` - فحص صحة النظام
- `GET /api/status` - حالة النظام
- `POST /api/process` - معالجة الأوامر
- `POST /api/github/execute` - تنفيذ أوامر من GitHub
- `POST /api/hostinger/report` - إرسال تقارير لـ GitHub

### 3. Internal Execution API (واجهة التنفيذ الداخلية)

**الموقع:** `dlplus/api/internal_api.py`

**الأوامر المسموح بها:**
- `file_create` - إنشاء ملف
- `file_update` - تحديث ملف
- `file_read` - قراءة ملف
- `file_delete` - حذف ملف
- `service_restart` - إعادة تشغيل خدمة
- `log_view` - عرض السجلات
- `status_check` - فحص الحالة
- `openwebui_manage` - إدارة OpenWebUI
- `backup_create` - إنشاء نسخة احتياطية

**ميزات الأمان:**
- قائمة بيضاء للأوامر المسموح بها
- منع اختراق المسارات
- تسجيل جميع العمليات
- صلاحيات محددة مسبقاً

### 4. Configuration System (نظام الإعدادات)

**الموقع:** `dlplus/config/`

المكونات:
- `settings.py` - إعدادات النظام الرئيسية
- `models_config.py` - إعدادات نماذج الذكاء الصناعي
- `agents_config.py` - إعدادات الوكلاء

---

## 📦 التثبيت والإعداد

### المتطلبات الأساسية

- Python 3.8 أو أحدث
- Git
- حساب GitHub
- خادم Hostinger (اختياري للنشر)

### خطوات التثبيت

#### 1. استنساخ المستودع

```bash
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
```

#### 2. إنشاء بيئة افتراضية

```bash
python -m venv venv
source venv/bin/activate  # في Linux/Mac
# أو
venv\Scripts\activate  # في Windows
```

#### 3. تثبيت المتطلبات

```bash
pip install -r requirements.txt
```

#### 4. إعداد المتغيرات البيئية

```bash
cp .env.example .env
```

ثم قم بتحرير ملف `.env`:

```env
# FastAPI Configuration
FASTAPI_HOST=0.0.0.0
FASTAPI_PORT=8000
FASTAPI_SECRET_KEY=your-secret-key-here

# GitHub Configuration
GITHUB_TOKEN=your-github-token
GITHUB_REPO=wasalstor-web/AI-Agent-Platform

# Hostinger Configuration
HOSTINGER_HOST=your-hostinger-host
HOSTINGER_PORT=8000

# OpenWebUI Configuration
OPENWEBUI_PORT=3000
OPENWEBUI_HOST=0.0.0.0
```

#### 5. توليد مفتاح أمان

```bash
openssl rand -hex 32
```

استخدم المفتاح الناتج في `FASTAPI_SECRET_KEY`

---

## 🚀 الاستخدام

### تشغيل النظام محلياً

```bash
# تشغيل FastAPI Server
python dlplus/main.py
```

سيبدأ النظام على `http://localhost:8000`

### تشغيل OpenWebUI

```bash
# استخدام السكريبت المضمن
./setup-openwebui.sh install

# أو يدوياً باستخدام Docker
docker run -d -p 3000:8080 \
  -e OLLAMA_API_BASE_URL=http://localhost:11434 \
  -v open-webui:/app/backend/data \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
```

### الوصول إلى الواجهات

- **FastAPI Docs:** http://localhost:8000/api/docs
- **OpenWebUI:** http://localhost:3000
- **System Status:** http://localhost:8000/api/status

---

## 🔌 واجهات API

### معالجة الأوامر

**نقطة النهاية:** `POST /api/process`

**الطلب:**
```json
{
  "command": "اشرح لي كيف يعمل نظام DL+",
  "context": {
    "user_id": "user123",
    "session_id": "session456"
  }
}
```

**الاستجابة:**
```json
{
  "success": true,
  "response": "نظام DL+ هو منظومة ذكاء صناعي عربية...",
  "intent": "general",
  "executor": "llama3",
  "timestamp": "2025-10-20T08:40:00Z"
}
```

### فحص الحالة

**نقطة النهاية:** `GET /api/status`

**الاستجابة:**
```json
{
  "status": "operational",
  "initialized": true,
  "models": 6,
  "agents": 7,
  "timestamp": "2025-10-20T08:40:00Z"
}
```

### تنفيذ أمر من GitHub

**نقطة النهاية:** `POST /api/github/execute`

**الطلب:**
```json
{
  "type": "file_create",
  "payload": {
    "path": "test.txt",
    "content": "محتوى الملف"
  }
}
```

**الاستجابة:**
```json
{
  "success": true,
  "result": {
    "action": "file_created",
    "path": "test.txt",
    "timestamp": "2025-10-20T08:40:00Z"
  },
  "timestamp": "2025-10-20T08:40:00Z"
}
```

---

## 💡 الأمثلة

### مثال 1: معالجة أمر بسيط

```python
import httpx
import asyncio

async def process_command():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "http://localhost:8000/api/process",
            headers={"X-API-Key": "your-api-key"},
            json={
                "command": "اكتب كود بايثون لحساب مجموع قائمة",
                "context": {"language": "python"}
            }
        )
        print(response.json())

asyncio.run(process_command())
```

### مثال 2: إنشاء ملف عبر GitHub

```python
import httpx
import asyncio

async def create_file():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "http://localhost:8000/api/github/execute",
            headers={"X-API-Key": "your-api-key"},
            json={
                "type": "file_create",
                "payload": {
                    "path": "data/output.txt",
                    "content": "بيانات الإخراج"
                }
            }
        )
        print(response.json())

asyncio.run(create_file())
```

### مثال 3: استخدام من OpenWebUI

في واجهة OpenWebUI، اكتب:

```
اشرح لي كيف يعمل نظام DL+ وما هي مكوناته الأساسية
```

سيقوم النظام بـ:
1. تحليل السؤال بالعربية
2. تحديد النية (شرح/معلومات)
3. اختيار النموذج المناسب
4. توليد الإجابة بالعربية الفصحى
5. عرض النتيجة في الواجهة

---

## 🔒 الأمان

### المصادقة

جميع طلبات API تتطلب مفتاح API في الرأس:

```
X-API-Key: your-secret-key
```

### التشفير

- جميع الاتصالات تستخدم HTTPS في الإنتاج
- المفاتيح السرية محفوظة في متغيرات البيئة
- لا يتم حفظ بيانات حساسة في الكود

### القيود الأمنية

- قائمة بيضاء للأوامر المسموح بها
- منع اختراق المسارات
- تسجيل جميع العمليات
- حدود معدل الطلبات (Rate limiting)

---

## 🧪 الاختبار

### تشغيل الاختبارات

```bash
# تشغيل جميع الاختبارات
pytest

# مع تغطية الكود
pytest --cov=dlplus

# اختبارات محددة
pytest tests/test_core.py
```

### اختبار يدوي

```bash
# فحص صحة النظام
curl http://localhost:8000/api/health

# فحص الحالة
curl -H "X-API-Key: your-key" http://localhost:8000/api/status

# إرسال أمر
curl -X POST http://localhost:8000/api/process \
  -H "X-API-Key: your-key" \
  -H "Content-Type: application/json" \
  -d '{"command": "مرحباً"}'
```

---

## 📚 الوثائق الإضافية

- [دليل النشر](DEPLOYMENT.md)
- [دليل OpenWebUI](OPENWEBUI.md)
- [دليل البدء السريع](QUICK-START.md)
- [ملخص التنفيذ](IMPLEMENTATION_SUMMARY.md)

---

## 🤝 المساهمة

نرحب بالمساهمات! يرجى:

1. Fork المستودع
2. إنشاء فرع للميزة (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push إلى الفرع (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

---

## 📝 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

---

## 👤 المؤلف

**خليف "ذيبان" العنزي**  
مؤسس منظومة DL+ للذكاء الصناعي العربي  
📍 القصيم – بريدة – المملكة العربية السعودية

---

## 🌟 الأسئلة الشائعة

### س: كيف يختلف DL+ عن أنظمة الذكاء الصناعي الأخرى؟

ج: DL+ مصمم خصيصاً للغة العربية الفصحى مع فهم عميق للسياق اللغوي والثقافي. كما أنه يجمع بين قوة GitHub للتطوير وسهولة Hostinger للنشر.

### س: هل يمكنني استخدام DL+ مع نماذج أخرى؟

ج: نعم، النظام مصمم ليكون قابلاً للتوسع. يمكنك إضافة أي نموذج جديد في ملف `models_config.py`.

### س: هل DL+ يعمل دون اتصال بالإنترنت؟

ج: النواة الأساسية تعمل محلياً، لكن بعض الوظائف مثل البحث على الويب تتطلب اتصال بالإنترنت.

### س: كيف يتم تحديث النظام؟

ج: النظام يدعم التحديثات التلقائية عبر GitHub. يمكنك أيضاً تحديثه يدوياً بـ `git pull`.

---

## 📞 الدعم

للحصول على الدعم:
- افتح [Issue](https://github.com/wasalstor-web/AI-Agent-Platform/issues) في GitHub
- راجع [الوثائق](README.md)
- تواصل مع المجتمع

---

**DL+ - نظام الذكاء الصناعي العربي الأول الذي يجمع بين الفهم العميق، اللغة الفصحى، والتنفيذ الذاتي المتكامل بين GitHub وHostinger.**
