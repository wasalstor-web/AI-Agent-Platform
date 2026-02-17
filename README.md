# AI Agent Platform - منصة الوكيل الذكي
# نظام الذكاء الاصطناعي المستقل عبر GitHub Actions

[![GitHub Actions](https://img.shields.io/badge/Automated-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![OpenRouter](https://img.shields.io/badge/AI-OpenRouter-10B981?logo=openai&logoColor=white)](https://openrouter.ai/)
[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)

## 🌟 مقدمة | Introduction

**AI Agent Platform** عبارة عن نظام ذكاء اصطناعي مستقل ومتطور يعمل بالكامل عبر GitHub Actions، مما يوفر بيئة قوية لبناء ونشر وإدارة الوكلاء الأذكياء (AI Agents) القادرين على التفكير المنطقي، واختيار الأدوات المناسبة، وتنفيذ المهام المعقدة بشكل ذاتي.

**AI Agent Platform** is an advanced autonomous artificial intelligence system that runs entirely through GitHub Actions, providing a powerful environment for building, deploying, and managing intelligent AI agents capable of logical reasoning, tool selection, and autonomous execution of complex tasks.

### ✨ لماذا هذا المشروع مميز؟ | Why This Project Stands Out?

- **🤖 استقلالية كاملة**: وكيل ذكي يعمل بدون تدخل بشري
- **🧠 تفكير منطقي متقدم**: يحلل المهام ويخطط للحلول
- **🛠️ اختيار أدوات ذكي**: ينتقي الأدوات المناسبة لكل مهمة
- **🌐 تكامل سلس**: يعمل مع GitHub Actions و OpenRouter و Render
- **🇸🇦 دعم عربي أصلي**: معالجة متقدمة للغة العربية الفصحى

---

## 🚀 الميزات الرئيسية | Key Features

### 1. **التفكير المنطقي المتقدم** | Advanced Reasoning
نظام DL+ Intelligence Core يوفر قدرات تفكير متطورة:
- تحليل السياق والمعنى
- فهم النوايا من الأوامر العربية والإنجليزية
- التخطيط متعدد الخطوات
- اتخاذ القرارات الذكية

### 2. **اختيار الأدوات الذكي** | Intelligent Tool Selection
الوكيل يختار تلقائياً الأداة المناسبة من مجموعة شاملة:
- **`run_web_search`** - البحث على الإنترنت وجمع المعلومات
- **`run_shell`** - تنفيذ أوامر النظام والبرمجيات
- **`write_to_file`** - كتابة وتعديل الملفات
- **`read_from_file`** - قراءة محتوى الملفات
- **`code_generator`** - توليد الأكواد بلغات متعددة
- **`arabic_processor`** - معالجة متقدمة للغة العربية

### 3. **البحث على الويب** | Web Search (run_web_search)
وكيل البحث على الويب (WebRetrievalAgent):
- البحث الذكي على الإنترنت
- جمع المعلومات من مصادر متعددة
- تحليل النتائج وترتيبها حسب الأهمية
- دعم الاستعلامات بالعربية والإنجليزية

### 4. **تنفيذ الأوامر** | Shell Execution (run_shell)
تنفيذ آمن للأوامر عبر:
- واجهة API آمنة مع قائمة بيضاء للأوامر
- تنفيذ على خوادم Hostinger
- مراقبة الأداء والنتائج
- سجلات تنفيذ شاملة

### 5. **كتابة الملفات** | File Writing (write_to_file)
إدارة متقدمة للملفات:
- إنشاء وتحديث الملفات تلقائياً
- دعم صيغ متعددة (Python, JavaScript, JSON, Markdown)
- حفظ النتائج والتقارير
- إنشاء وثائق تلقائية

### 6. **توليد الأكواد** | Code Generation
وكيل توليد الأكواد (CodeGeneratorAgent):
- توليد أكواد احترافية في 10+ لغات برمجة
- Python, JavaScript, Java, C++, Go, Rust, TypeScript
- إنشاء اختبارات وحدة تلقائياً
- توثيق الأكواد بالعربية والإنجليزية

### 7. **معالجة اللغة العربية** | Arabic Language Processing
نظام متقدم لمعالجة العربية:
- دعم العربية الفصحى
- تحليل النوايا من النصوص العربية
- توليد استجابات باللغة العربية السليمة
- فهم السياق العربي

---

## 🔄 كيف يعمل النظام | How It Works

### معمارية النظام | System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      User Input / إدخال المستخدم            │
│              "Your prompt for the agent"                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                 GitHub Actions Workflow                      │
│              سير عمل GitHub Actions                          │
│  • Triggered manually or automatically                       │
│  • Receives user prompt                                      │
│  • Sets up environment                                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              DL+ Intelligence Core                           │
│              نواة الذكاء DL+                                 │
│  • Arabic Processor - معالج اللغة العربية                   │
│  • Context Analyzer - محلل السياق                           │
│  • Intent Detection - كشف النوايا                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Reasoning Engine                                │
│              محرك التفكير المنطقي                            │
│  • Analyzes the task                                         │
│  • Plans execution steps                                     │
│  • Selects appropriate tools                                 │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Tool Selection                                  │
│              اختيار الأدوات                                  │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │run_web_search│  │  run_shell   │  │write_to_file │      │
│  │  البحث ويب   │  │  تنفيذ أوامر │  │  كتابة ملف   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │code_generator│  │read_from_file│  │arabic_process│      │
│  │  توليد كود   │  │  قراءة ملف   │  │  معالجة عربي │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│           OpenRouter AI Integration                          │
│           تكامل OpenRouter للذكاء الصناعي                    │
│  • GPT-4, Claude 3, Gemini Pro                              │
│  • LLaMA 3, Mistral, DeepSeek                               │
│  • Qwen Arabic, AraBERT                                     │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Execution & Results                             │
│              التنفيذ والنتائج                                │
│  • Tools execute tasks                                       │
│  • Results are collected                                     │
│  • Logs are generated                                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│           Final Response / الاستجابة النهائية                │
│  • Comprehensive answer in Arabic/English                    │
│  • Generated files and reports                               │
│  • Execution logs                                            │
└─────────────────────────────────────────────────────────────┘
```

### سير العمل خطوة بخطوة | Step-by-Step Workflow

1. **استقبال المهمة** - يتلقى الوكيل الأمر عبر GitHub Actions
2. **التحليل** - DL+ Intelligence Core يحلل المهمة ويفهم السياق
3. **التفكير** - محرك التفكير يخطط للخطوات اللازمة
4. **اختيار الأدوات** - انتقاء الأدوات المناسبة (بحث، تنفيذ، كتابة)
5. **التنفيذ** - تشغيل الأدوات عبر OpenRouter و FastAPI
6. **التجميع** - جمع النتائج ومعالجتها
7. **الاستجابة النهائية** - إنشاء رد شامل بالعربية أو الإنجليزية

---

## 📖 دليل البدء السريع | Quick Start Guide

### المتطلبات الأساسية | Prerequisites

- حساب GitHub مع صلاحيات GitHub Actions
- مفتاح API من OpenRouter (للذكاء الصناعي)
- (اختياري) خادم Hostinger لتنفيذ الأوامر
- (اختياري) حساب Render للنشر المتقدم

### الخطوة 1: استنساخ المشروع | Clone the Repository

```bash
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
```

### الخطوة 2: إعداد المتغيرات البيئية | Configure Environment Variables

في GitHub، اذهب إلى Settings > Secrets and variables > Actions وأضف:

```
OPENROUTER_API_KEY=your_openrouter_api_key_here
VPS_HOST=your_hostinger_host (optional)
VPS_USER=your_hostinger_user (optional)
VPS_KEY=your_ssh_key (optional)
```

### الخطوة 3: استخدام الوكيل عبر GitHub Actions | Use Agent via GitHub Actions

1. اذهب إلى تبويب **Actions** في مستودع GitHub
2. اختر workflow حسب احتياجاتك:
   - **DL+ Smart VPS Auto Verify & Deploy** - للنشر التلقائي
   - **Deploy Pages** - لنشر الواجهة
   - **OpenWeb Pages** - لنشر OpenWebUI
3. انقر على **Run workflow**
4. أدخل **Your prompt for the agent** في حقل الإدخال
   - مثال بالعربية: "ابحث عن أحدث تقنيات الذكاء الصناعي واكتب تقريراً في ملف report.md"
   - مثال بالإنجليزية: "Search for AI trends and create a summary file"
5. انقر **Run workflow** لبدء التنفيذ
6. راقب السجلات في تبويب Actions

### الخطوة 4: مشاهدة النتائج | View Results

- **السجلات (Logs)**: في صفحة الـ workflow run
- **الملفات المنشأة**: في المستودع أو artifacts
- **التقارير**: في ملفات markdown المُنشأة

---

## ⚡ النشر السريع | Quick Deployment with DEPLOY-NOW.sh

### 🚀 للوصول لخادم API والواجهات والنماذج فقط | API Access Only Mode

**commit 670b146**: New feature added! Quick deployment script for instant API access.

```bash
# Clone and navigate to the repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# Checkout the deployment branch
git checkout copilot/add-deployment-scripts

# Run DEPLOY-NOW.sh with --api flag
bash DEPLOY-NOW.sh --api
```

### ✨ What You Get / ما تحصل عليه

This provides / يوفر هذا:

- 🌐 **3 Web Interfaces** / **3 واجهات ويب**
  - Flask API Server (Port 5000)
  - DL+ Intelligence System (Port 8000)
  - Web Dashboard (Port 8080)

- 📋 **8 AI Models** / **8 نماذج ذكاء اصطناعي**
  - GPT-3.5 Turbo, GPT-4 (OpenAI)
  - Claude 3 (Anthropic)
  - LLaMA 3 (Meta)
  - Qwen Arabic, AraBERT (Arabic Models)
  - Mistral, DeepSeek Coder

- 🧪 **Test API Endpoints** / **اختبار نقاط API**
- 🚀 **Start Local API Server** / **بدء خادم API محلي**
- 🔗 **Hostinger Domain 2 Integration** / **تكامل مع الدومين الثاني** (mbst.space)

### 📚 Full Documentation / التوثيق الكامل

For complete documentation, see [DEPLOY-NOW-README.md](./DEPLOY-NOW-README.md)

---

## 🌐 النشر على Render | Deployment on Render

### نظرة عامة | Overview

يمكن نشر المشروع على منصة Render للحصول على:
- API دائم التشغيل
- واجهة OpenWebUI تفاعلية
- ربط مع نطاق مخصص

### خطوات النشر | Deployment Steps

#### 1. إنشاء ملف `render.yaml`

في جذر المشروع، أنشئ ملف `render.yaml`:

```yaml
services:
  - type: web
    name: dlplus-ai-agent
    env: python
    buildCommand: pip install -r requirements.txt
    startCommand: uvicorn dlplus.main:app --host 0.0.0.0 --port $PORT
    envVars:
      - key: OPENROUTER_API_KEY
        sync: false
      - key: WEBUI_SECRET_KEY
        generateValue: true
      - key: PYTHON_VERSION
        value: 3.9
```

#### 2. الربط مع Render

1. اذهب إلى [render.com](https://render.com)
2. انقر **New** > **Web Service**
3. اربط مستودع GitHub
4. Render سيكتشف `render.yaml` تلقائياً
5. أضف المتغيرات البيئية (OPENROUTER_API_KEY)
6. انقر **Create Web Service**

#### 3. الوصول للتطبيق

بعد النشر، ستحصل على رابط:
- `https://your-app-name.onrender.com`
- API Docs: `https://your-app-name.onrender.com/api/docs`

### ربط نطاق مخصص | Custom Domain Setup

لربط نطاقك الخاص (مثل ai.yourdomain.com)، راجع:
**[دليل إعداد النطاق المخصص - DOMAIN_SETUP_GUIDE.md](DOMAIN_SETUP_GUIDE.md)**

---

## 🧠 نظام DL+ للذكاء العربي | DL+ Arabic Intelligence System

### المكونات الأساسية | Core Components

#### 1. **نواة الذكاء** | Intelligence Core
`dlplus/core/intelligence_core.py`
- محرك الذكاء الرئيسي
- تنسيق جميع النماذج والوكلاء
- إدارة السياق والذاكرة

#### 2. **معالج اللغة العربية** | Arabic Processor
`dlplus/core/arabic_processor.py`
- معالجة متقدمة للعربية الفصحى
- تحليل النوايا
- استخراج الكيانات

#### 3. **محلل السياق** | Context Analyzer
`dlplus/core/context_analyzer.py`
- فهم سياق المحادثة
- إدارة الذاكرة قصيرة وطويلة المدى
- تتبع العلاقات بين المهام

#### 4. **طبقة API** | API Layer
`dlplus/api/fastapi_connector.py`
- بوابة الاتصال بين GitHub و Hostinger
- نقاط نهاية API آمنة
- توثيق تفاعلي (Swagger)

#### 5. **الوكلاء الأذكياء** | Intelligent Agents
- `WebRetrievalAgent` - البحث على الويب
- `CodeGeneratorAgent` - توليد الأكواد
- `BaseAgent` - فئة أساسية لوكلاء مخصصة

### نماذج الذكاء الاصطناعي المدعومة | Supported AI Models

#### النماذج العربية | Arabic Models
- **AraBERT** - فهم اللغة العربية
- **CAMeLBERT** - معالجة اللغة الطبيعية العربية
- **Qwen 2.5 Arabic** - توليد النصوص العربية

#### النماذج العامة | General Models
- **LLaMA 3** - التفكير العام والبرمجة
- **GPT-4** - مهام متقدمة
- **Claude 3** - تحليل وكتابة
- **Mistral 7B** - دعم متعدد اللغات
- **DeepSeek Coder** - توليد أكواد متقدم
- **Phi-3 Mini** - كفاءة عالية

---

## 💻 أمثلة الاستخدام | Usage Examples

### مثال 1: البحث وإنشاء تقرير
**Arabic Prompt:**
```
ابحث عن أحدث تطورات الذكاء الاصطناعي في 2024 واكتب تقريراً شاملاً في ملف ai_trends_2024.md
```

**ما سيفعله الوكيل:**
1. يستخدم `run_web_search` للبحث عن معلومات
2. يحلل النتائج
3. يستخدم `write_to_file` لإنشاء الملف
4. يكتب تقريراً مفصلاً بالعربية

### مثال 2: توليد كود Python
**English Prompt:**
```
Generate a Python script that fetches weather data from an API and saves it to JSON
```

**What the agent will do:**
1. Uses `code_generator` agent
2. Generates complete Python code
3. Creates unit tests
4. Saves to file using `write_to_file`

### مثال 3: تحليل وتنفيذ
**Arabic Prompt:**
```
قم بتحليل ملف requirements.txt وتثبيت المكتبات المطلوبة على الخادم
```

**Agent Actions:**
1. Uses `read_from_file` to read requirements.txt
2. Analyzes dependencies
3. Uses `run_shell` to execute `pip install -r requirements.txt`
4. Reports results

---

## 📚 البنية التنظيمية | Project Structure

```
AI-Agent-Platform/
├── dlplus/                      # نظام DL+ الأساسي
│   ├── core/                    # النواة الذكية
│   │   ├── intelligence_core.py     # محرك الذكاء الرئيسي
│   │   ├── arabic_processor.py      # معالج العربية
│   │   └── context_analyzer.py      # محلل السياق
│   ├── agents/                  # الوكلاء الأذكياء
│   │   ├── base_agent.py            # الفئة الأساسية
│   │   ├── web_retrieval_agent.py   # وكيل البحث
│   │   └── code_generator_agent.py  # وكيل توليد الأكواد
│   ├── api/                     # طبقة API
│   │   ├── fastapi_connector.py     # موصل FastAPI
│   │   └── internal_api.py          # API الداخلي
│   ├── config/                  # الإعدادات
│   │   ├── settings.py              # إعدادات النظام
│   │   ├── models_config.py         # إعدادات النماذج
│   │   └── agents_config.py         # إعدادات الوكلاء
│   └── utils/                   # أدوات مساعدة
│       ├── logger.py                # نظام السجلات
│       └── helpers.py               # دوال مساعدة
├── .github/
│   └── workflows/               # سير عمل GitHub Actions
│       ├── vps-auto-verify.yml      # نشر VPS تلقائي
│       ├── deploy-pages.yml         # نشر الصفحات
│       └── openweb-pages.yml        # نشر OpenWebUI
├── api/                         # API الخارجي
│   └── server.py                    # خادم API
├── examples/                    # أمثلة الاستخدام
├── tests/                       # الاختبارات
├── docs/                        # الوثائق
├── requirements.txt             # المتطلبات
├── README.md                    # هذا الملف
└── DOMAIN_SETUP_GUIDE.md       # دليل إعداد النطاق
```

---

## 🛡️ الأمان وأفضل الممارسات | Security & Best Practices

### الأمان | Security
- ✅ عدم تخزين البيانات الحساسة في المستودع
- ✅ استخدام GitHub Secrets للمفاتيح
- ✅ مصادقة API آمنة
- ✅ قائمة بيضاء للأوامر المسموحة
- ✅ تشفير الاتصالات (HTTPS/WSS)
- ✅ تحديثات أمنية منتظمة

### أفضل الممارسات | Best Practices
- 📝 توثيق شامل للأكواد
- 🧪 اختبارات شاملة (80%+ تغطية)
- 🔄 التكامل المستمر عبر GitHub Actions
- 📊 مراقبة الأداء والسجلات
- 🌍 دعم متعدد اللغات
- ♿ إمكانية الوصول والشمولية

---

## 🤝 المساهمة | Contributing

نرحب بمساهماتكم! يرجى:
1. Fork المشروع
2. إنشاء branch للميزة (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push إلى Branch (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

---

## 📄 الترخيص | License

AI-Agent-Platform © 2025

---

## 🔗 روابط مفيدة | Useful Links

- 🌐 **الموقع الحي**: [https://wasalstor-web.github.io/AI-Agent-Platform/](https://wasalstor-web.github.io/AI-Agent-Platform/)
- 📖 **الوثائق الكاملة**: [docs/](docs/)
- 🚀 **دليل النشر السريع**: [QUICK_DEPLOY_GUIDE.md](QUICK_DEPLOY_GUIDE.md)
- 🔧 **دليل إعداد النطاق**: [DOMAIN_SETUP_GUIDE.md](DOMAIN_SETUP_GUIDE.md)
- 💬 **دمج OpenWebUI**: [OPENWEBUI_INTEGRATION.md](OPENWEBUI_INTEGRATION.md)
- 🤖 **نظام DL+**: [DLPLUS_README.md](DLPLUS_README.md)
- 💳 **نظام تأكيد الدفع**: [PAYMENT_SYSTEM.md](PAYMENT_SYSTEM.md)

---

## 📞 الدعم | Support

للأسئلة والدعم:
- افتح Issue في GitHub
- راجع الوثائق في مجلد `docs/`
- تابع سجلات GitHub Actions للتشخيص

---

<div align="center">

**صُنع بـ ❤️ للمجتمع العربي والعالمي**

**Made with ❤️ for the Arabic and Global Community**

</div>
