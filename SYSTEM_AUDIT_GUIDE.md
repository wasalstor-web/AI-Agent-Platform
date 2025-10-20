# 🔍 نظام الفحص الشامل للذكاء الاصطناعي
# Full AI System Audit Tool Documentation

## نظرة عامة / Overview

أداة فحص شاملة لنظام الذكاء الاصطناعي تقوم بفحص وتوثيق جميع جوانب النظام بما في ذلك:

A comprehensive audit tool for the AI Agent Platform that checks and documents all aspects of the system including:

- ✅ **حالة النظام المبرمج** / System Status - Server uptime, CPU, RAM, Disk usage
- 🧠 **أدوات الذكاء الاصطناعي** / Active AI Models - LLaMA, Qwen, Mistral, DeepSeek, GPT-4, Claude, etc.
- 🌐 **المواقع والأنظمة المرتبطة** / Connected Websites - GitHub Pages, domains, SSL certificates
- 🔗 **واجهات البرمجة** / API/ABI/Webhooks - FastAPI endpoints, webhook handlers
- 📄 **الصفحات والنماذج** / Pages and Forms - Frontend files, HTML forms
- 🔌 **الارتباطات الخارجية** / External Integrations - GitHub, Hostinger, Cloudflare, Telegram

---

## 🚀 التشغيل السريع / Quick Start

### الطريقة الأولى: استخدام السكريبت (مستحسن)

**Method 1: Using Shell Script (Recommended)**

```bash
# تشغيل الفحص الشامل
# Run comprehensive audit
./run-system-audit.sh
```

السكريبت سيقوم تلقائياً بـ:
- ✅ التحقق من Python وpip
- ✅ تثبيت المتطلبات المفقودة
- ✅ تشغيل الفحص
- ✅ عرض التقرير

The script will automatically:
- ✅ Check for Python and pip
- ✅ Install missing requirements
- ✅ Run the audit
- ✅ Display the report

### الطريقة الثانية: استخدام Python مباشرة

**Method 2: Using Python Directly**

```bash
# تثبيت المتطلبات
# Install requirements
pip3 install psutil httpx aiohttp

# تشغيل الفحص
# Run audit
python3 system_audit.py
```

---

## 📋 المتطلبات / Requirements

### البرمجيات الأساسية / Core Software
- Python 3.8 أو أحدث / Python 3.8+
- pip (مدير الحزم) / pip (package manager)

### المكتبات المطلوبة / Required Libraries
```bash
psutil>=5.9.0      # معلومات النظام / System info
httpx>=0.25.0      # طلبات HTTP / HTTP requests
aiohttp>=3.9.0     # طلبات HTTP غير متزامنة / Async HTTP
```

---

## 📊 التقارير المنتجة / Generated Reports

يقوم النظام بإنشاء تقريرين:

The system generates two reports:

### 1. تقرير نصي / Text Report
**الملف / File:** `system_audit_report.txt`

تقرير تفصيلي سهل القراءة بالعربية والإنجليزية يحتوي على:

A detailed, human-readable report in Arabic and English containing:
- معلومات النظام الأساسية / Basic system information
- حالة الموارد / Resource status
- قائمة النماذج / Model listings
- حالة الاتصالات / Connection status
- ملخص شامل / Comprehensive summary

**[See Example Report →](SYSTEM_AUDIT_EXAMPLE.txt)**

### 2. تقرير JSON / JSON Report
**الملف / File:** `system_audit_report.json`

تقرير بصيغة JSON للمعالجة البرمجية يحتوي على جميع البيانات المنظمة.

A JSON-formatted report for programmatic processing containing all structured data.

---

## 🔍 مكونات الفحص / Audit Components

### 1️⃣ حالة النظام المبرمج / System Status

**ماذا يتم فحصه؟ / What is checked?**

- 🖥️ معلومات المنصة (نظام التشغيل، الإصدار) / Platform info (OS, version)
- ⏱️ وقت التشغيل / Uptime
- 💻 استخدام CPU (النسبة والأنوية) / CPU usage (percentage and cores)
- 🧠 استهلاك الذاكرة (الإجمالي، المستخدم، المتاح) / Memory usage (total, used, available)
- 💾 مساحة القرص (الإجمالي، المستخدم، المتاح) / Disk space (total, used, free)
- 🌐 معلومات الشبكة (اسم المضيف، IP المحلي) / Network info (hostname, local IP)

**مثال على النتيجة / Example Output:**

```
🖥️ المنصة / Platform: Linux 6.14.0
🐍 Python: 3.12.3
⏱️ وقت التشغيل / Uptime: 1:23:45

💻 CPU:
   - عدد الأنوية / Cores: 4
   - الاستخدام / Usage: 15.5%

🧠 الذاكرة / Memory:
   - الإجمالي / Total: 16.00 GB
   - المستخدم / Used: 4.50 GB
   - المتاح / Available: 11.50 GB
   - النسبة / Percentage: 28.1%

💾 القرص / Disk:
   - الإجمالي / Total: 100.00 GB
   - المستخدم / Used: 45.00 GB
   - المتاح / Free: 55.00 GB
   - النسبة / Percentage: 45.0%
```

---

### 2️⃣ أدوات الذكاء الاصطناعي المفعّلة / Active AI Models

**ماذا يتم فحصه؟ / What is checked?**

- 🧠 النماذج المكتشفة في الوثائق والتكوين / Models detected in docs and config
- ⚙️ حالة DL+ API (منفذ 8000) / DL+ API status (port 8000)
- 💬 حالة OpenWebUI (منفذ 3000) / OpenWebUI status (port 3000)
- ✅ استجابة النماذج / Model responsiveness

**النماذج المدعومة / Supported Models:**

- LLaMA / لاما
- Qwen
- Mistral
- DeepSeek
- GPT-4
- Claude
- AraBERT / عربرت
- Gemini

**مثال على النتيجة / Example Output:**

```
🧠 النماذج المكتشفة / Detected Models:
   ✓ LLaMA
   ✓ Qwen
   ✓ GPT-4
   ✓ Claude
   ✓ AraBERT

⚙️ حالة الخدمات / Services Status:
   - dlplus_api: ✅ نشط / Active
   - openwebui: ✅ نشط / Active
```

---

### 3️⃣ المواقع والأنظمة المرتبطة / Connected Websites

**ماذا يتم فحصه؟ / What is checked?**

- 🌐 GitHub Pages (الرابط والوصول) / GitHub Pages (URL and accessibility)
- 🔒 شهادات SSL / SSL certificates
- 🔗 النطاقات المكتشفة في التكوين / Domains discovered in config
- 🔌 النقاط النهائية المحلية / Local endpoints

**مثال على النتيجة / Example Output:**

```
🌐 GitHub Pages:
   - الرابط / URL: https://wasalstor-web.github.io/AI-Agent-Platform/
   - الحالة / Status: ✅ متاح / Accessible
   - SSL: ✅ HTTPS نشط / HTTPS Active

🔗 النطاقات المكتشفة / Discovered Domains:
   - github.com
   - wasalstor-web.github.io
   - your-domain.com

🔌 النقاط النهائية المحلية / Local Endpoints:
   - DL+ API: ✅ نشط / Active
   - OpenWebUI: ✅ نشط / Active
```

---

### 4️⃣ الـ API / ABI / Webhooks

**ماذا يتم فحصه؟ / What is checked?**

- 🔗 نقاط FastAPI (/health, /api/status, /docs, etc.) / FastAPI endpoints
- 🪝 معالجات Webhooks / Webhook handlers
- 📡 حالة الاستجابة / Response status
- ⚙️ ملفات الخادم / Server files

**النقاط المفحوصة / Checked Endpoints:**

- `/health` - فحص الصحة / Health check
- `/api/status` - حالة API / API status
- `/api/models` - قائمة النماذج / Models list
- `/docs` - توثيق Swagger / Swagger docs
- `/openapi.json` - مواصفات OpenAPI / OpenAPI specs

**مثال على النتيجة / Example Output:**

```
🔗 واجهات البرمجة / API Endpoints:
   - /health: ✅ نشط / Active
   - /api/status: ✅ نشط / Active
   - /docs: ✅ نشط / Active

🪝 Webhooks:
   - github-webhook-handler.py: ✅ موجود / Present
   - github-commander.py: ✅ موجود / Present
```

---

### 5️⃣ الصفحات والنماذج / Pages and Forms

**ماذا يتم فحصه؟ / What is checked?**

- 📄 ملفات HTML الرئيسية / Main HTML files
- 📝 عدد النماذج والحقول / Form and input counts
- 📊 أحجام الملفات / File sizes
- ✅ وجود الملفات / File existence

**مثال على النتيجة / Example Output:**

```
📄 الواجهة الأمامية / Frontend:
   - الملف / File: index.html
   - الحجم / Size: 54.37 KB
   - الحالة / Status: ✅ موجود / Present

📝 النماذج / Forms:
   - index.html: 3 نموذج / forms, 12 حقل / inputs
```

---

### 6️⃣ الارتباطات والربط الخارجي / External Integrations

**ماذا يتم فحصه؟ / What is checked?**

- 🐙 **GitHub:** ملفات المستودع، workflows، webhooks / Repository files, workflows, webhooks
- 🌐 **Hostinger:** سكريبتات النشر والإدارة / Deployment and management scripts
- ☁️ **Cloudflare:** الإشارات في التكوين / References in config
- 📱 **Telegram:** ملفات البوتات / Bot files

**مثال على النتيجة / Example Output:**

```
🐙 GitHub:
   - المستودع / Repository: wasalstor-web/AI-Agent-Platform
   - الحالة / Status: ✅ نشط / Active
   - الملفات / Files: 4 موجود / present

🌐 Hostinger:
   - الحالة / Status: ✅ مدمج / Integrated
   - الملفات / Files: 4 موجود / present

☁️ Cloudflare:
   - الحالة / Status: ❌ غير مذكور / Not mentioned

📱 Telegram:
   - الحالة / Status: ❌ غير موجود / Not found
```

---

## 🧪 الاختبارات / Testing

### تشغيل الاختبارات / Running Tests

```bash
# تثبيت متطلبات الاختبار
# Install test requirements
pip3 install pytest pytest-asyncio

# تشغيل جميع الاختبارات
# Run all tests
python3 -m pytest tests/test_system_audit.py -v

# تشغيل اختبار محدد
# Run specific test
python3 -m pytest tests/test_system_audit.py::test_check_system_status -v
```

### الاختبارات المتاحة / Available Tests

1. ✅ `test_system_audit_initialization` - تهيئة الأداة / Tool initialization
2. ✅ `test_check_system_status` - فحص حالة النظام / System status check
3. ✅ `test_check_ai_models` - كشف النماذج / Model detection
4. ✅ `test_check_websites` - فحص المواقع / Website check
5. ✅ `test_check_apis` - فحص APIs / API check
6. ✅ `test_check_pages` - فحص الصفحات / Page check
7. ✅ `test_check_integrations` - فحص الارتباطات / Integration check
8. ✅ `test_run_full_audit` - تشغيل فحص كامل / Full audit run
9. ✅ `test_generate_report` - توليد التقرير / Report generation
10. ✅ `test_save_report` - حفظ التقرير / Report saving

---

## 📁 الملفات / Files

```
AI-Agent-Platform/
├── system_audit.py              # الأداة الرئيسية / Main audit tool
├── run-system-audit.sh          # سكريبت التشغيل / Execution script
├── tests/
│   └── test_system_audit.py    # ملف الاختبارات / Test file
├── SYSTEM_AUDIT_GUIDE.md       # هذا الدليل / This guide
├── system_audit_report.txt     # تقرير نصي (مُنشأ) / Text report (generated)
└── system_audit_report.json    # تقرير JSON (مُنشأ) / JSON report (generated)
```

---

## 🔧 الاستخدام البرمجي / Programmatic Usage

### استيراد واستخدام الأداة في Python

**Import and use in Python:**

```python
import asyncio
from system_audit import SystemAudit

async def run_audit():
    # إنشاء كائن الفحص
    # Create audit instance
    audit = SystemAudit()
    
    # تشغيل الفحص الكامل
    # Run full audit
    results = await audit.run_full_audit()
    
    # توليد التقرير
    # Generate report
    report = audit.generate_report()
    print(report)
    
    # حفظ التقارير
    # Save reports
    txt_path, json_path = audit.save_report()
    print(f"Reports saved: {txt_path}, {json_path}")
    
    # الوصول إلى البيانات
    # Access data
    print(f"Detected models: {results['ai_models']['detected_models']}")
    print(f"CPU usage: {results['system_status']['cpu']['usage_percent']}%")

# تشغيل
# Run
asyncio.run(run_audit())
```

### فحص مكونات محددة / Check Specific Components

```python
async def check_specific():
    audit = SystemAudit()
    
    # فحص النظام فقط
    # Check system only
    system_status = await audit.check_system_status()
    print(f"CPU: {system_status['cpu']['usage_percent']}%")
    
    # فحص النماذج فقط
    # Check models only
    models = await audit.check_ai_models()
    print(f"Models: {models['detected_models']}")
    
    # فحص المواقع فقط
    # Check websites only
    websites = await audit.check_websites()
    print(f"GitHub Pages: {websites['github_pages']}")

asyncio.run(check_specific())
```

---

## 🔒 الأمان / Security

### المعلومات الحساسة / Sensitive Information

الأداة **لا تجمع أو تعرض**:

The tool **does NOT collect or display**:
- ❌ كلمات المرور / Passwords
- ❌ مفاتيح API / API keys
- ❌ معلومات اعتماد / Credentials
- ❌ بيانات شخصية / Personal data

### التقارير / Reports

- ✅ التقارير المُنشأة تحتوي فقط على معلومات النظام العامة / Reports contain only general system info
- ✅ يتم تجاهل ملفات .env تلقائياً / .env files are automatically ignored
- ✅ التقارير مستبعدة من Git (.gitignore) / Reports excluded from Git (.gitignore)

---

## 🛠️ استكشاف الأخطاء / Troubleshooting

### المشكلة: الفحص لا يعمل

**Problem: Audit not running**

```bash
# تحقق من Python
# Check Python
python3 --version

# تحقق من pip
# Check pip
pip3 --version

# أعد تثبيت المتطلبات
# Reinstall requirements
pip3 install --upgrade psutil httpx aiohttp
```

### المشكلة: النماذج غير مكتشفة

**Problem: Models not detected**

- تأكد من وجود ملفات README.md و DLPLUS_README.md / Ensure README files exist
- تحقق من ملفات التكوين في dlplus/config / Check config files in dlplus/config
- راجع محتوى index.html / Review index.html content

### المشكلة: APIs غير متوفرة

**Problem: APIs not available**

```bash
# تحقق من تشغيل DL+ API
# Check if DL+ API is running
curl http://localhost:8000/health

# تحقق من OpenWebUI
# Check OpenWebUI
curl http://localhost:3000

# شغل الخدمات
# Start services
./start-dlplus.sh
```

---

## 📚 مراجع إضافية / Additional References

- **[README.md](README.md)** - نظرة عامة على المشروع / Project overview
- **[DLPLUS_README.md](DLPLUS_README.md)** - دليل نظام DL+ / DL+ system guide
- **[STATUS.md](STATUS.md)** - حالة المشروع / Project status
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - دليل النشر / Deployment guide

---

## 🎯 الخلاصة / Summary

أداة الفحص الشامل توفر:

The comprehensive audit tool provides:

✅ **فحص كامل للنظام** / Complete system inspection
✅ **تقارير تفصيلية** / Detailed reports
✅ **دعم ثنائي اللغة** / Bilingual support
✅ **سهولة الاستخدام** / Easy to use
✅ **اختبارات شاملة** / Comprehensive tests
✅ **توثيق واضح** / Clear documentation

---

**آخر تحديث / Last Updated:** 2025-10-20  
**الإصدار / Version:** 1.0.0  
**الحالة / Status:** ✅ مكتمل / Complete
