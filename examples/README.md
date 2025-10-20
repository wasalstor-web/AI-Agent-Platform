# أمثلة استخدام نظام DL+ / DL+ System Examples

This directory contains various examples demonstrating how to use the DL+ system.

## 📋 قائمة الأمثلة / Examples List

### 1. الاستخدام الأساسي / Basic Usage
**File:** `basic_usage.py`

يوضح الاستخدام الأساسي لنظام DL+:
- تهيئة النظام
- معالجة الأوامر البسيطة
- توليد الأكواد
- البحث عن المعلومات

Demonstrates basic DL+ system usage:
- System initialization
- Simple command processing
- Code generation
- Information search

**Run:**
```bash
python examples/basic_usage.py
```

---

### 2. استخدام Agents / Agent Usage
**File:** `agent_usage.py`

يوضح كيفية استخدام agents المختلفة:
- Web Retrieval Agent
- Code Generator Agent
- Custom agents

Shows how to use different agents:
- Web Retrieval Agent
- Code Generator Agent
- Custom agents

**Run:**
```bash
python examples/agent_usage.py
```

---

### 3. استخدام API Client / API Client Usage
**File:** `api_client_usage.py`

يوضح كيفية التفاعل مع DL+ عبر API:
- استدعاءات HTTP
- معالجة الردود
- التعامل مع الأخطاء

Shows how to interact with DL+ via API:
- HTTP calls
- Response handling
- Error handling

**Run:**
```bash
python examples/api_client_usage.py
```

---

### 4. تنفيذ الأوامر على Hostinger / Hostinger Command Execution ⭐ NEW!
**File:** `hostinger_command_examples.py`

يوضح كيفية تنفيذ الأوامر على خادم Hostinger:
- إدارة الملفات (إنشاء، قراءة، تحديث، حذف)
- إدارة الخدمات (إعادة التشغيل، الحالة)
- إدارة OpenWebUI
- عرض السجلات والحالة
- إنشاء النسخ الاحتياطية
- سير عمل نشر كامل

Demonstrates command execution on Hostinger server:
- File management (create, read, update, delete)
- Service management (restart, status)
- OpenWebUI management
- Logs and status viewing
- Backup creation
- Complete deployment workflow

**Run:**
```bash
# تأكد من تشغيل DL+ أولاً / Make sure DL+ is running first
./start-dlplus.sh

# في نافذة طرفية أخرى / In another terminal
python examples/hostinger_command_examples.py
```

**📖 وثائق كاملة / Full Documentation:**
- [دليل تنفيذ أوامر Hostinger](../HOSTINGER_COMMAND_EXECUTION.md)

---

## ⚙️ المتطلبات / Requirements

قبل تشغيل الأمثلة، تأكد من:

Before running the examples, ensure:

1. **تثبيت المتطلبات / Install requirements:**
   ```bash
   pip install -r requirements.txt
   ```

2. **إعداد ملف .env / Setup .env file:**
   ```bash
   cp .env.dlplus.example .env
   # Edit .env with your configuration
   ```

3. **تشغيل نظام DL+ / Start DL+ system (للأمثلة التي تحتاج API / for API examples):**
   ```bash
   ./start-dlplus.sh
   ```

---

## 🚀 الاستخدام السريع / Quick Start

### استخدام أساسي / Basic Usage
```bash
python examples/basic_usage.py
```

### استخدام مع API / Usage with API
```bash
# Terminal 1: Start DL+
./start-dlplus.sh

# Terminal 2: Run example
python examples/hostinger_command_examples.py
```

---

## 🔐 تكوين API Key / API Key Configuration

للأمثلة التي تستخدم API (مثل Hostinger commands)، قم بتحديث `api_key`:

For examples using API (like Hostinger commands), update the `api_key`:

```python
executor = HostingerCommandExecutor(
    base_url="http://localhost:8000",
    api_key="your-secret-key-here"  # ⬅️ استخدم مفتاحك / Use your key
)
```

**للحصول على مفتاح آمن / To generate a secure key:**
```bash
openssl rand -hex 32
```

---

## 📝 إنشاء مثال خاص / Creating Your Own Example

### قالب بسيط / Simple Template

```python
#!/usr/bin/env python3
"""
Your Example Name
اسم مثالك
"""

import asyncio
import sys
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from dlplus import DLPlusCore


async def main():
    """Main function"""
    print("=" * 60)
    print("Your Example / مثالك")
    print("=" * 60)
    
    # Initialize DL+ Core
    core = DLPlusCore()
    await core.initialize()
    
    # Your code here
    result = await core.process_command("مرحباً")
    print(result['response'])
    
    # Cleanup
    await core.shutdown()


if __name__ == "__main__":
    asyncio.run(main())
```

---

## 🧪 اختبار الأمثلة / Testing Examples

### اختبار فردي / Individual Test
```bash
python examples/basic_usage.py
```

### اختبار جميع الأمثلة / Test All Examples
```bash
# يمكنك إنشاء سكريبت بسيط / You can create a simple script
for example in examples/*.py; do
    echo "Testing $example..."
    python "$example"
done
```

---

## 🐛 استكشاف الأخطاء / Troubleshooting

### خطأ: ModuleNotFoundError
**المشكلة:** لم يتم العثور على وحدة DL+

**الحل:**
```bash
# تأكد من أنك في المجلد الصحيح
cd /path/to/AI-Agent-Platform

# تثبيت المتطلبات
pip install -r requirements.txt
```

### خطأ: Connection refused
**المشكلة:** لا يمكن الاتصال بـ API

**الحل:**
```bash
# تأكد من تشغيل DL+
./start-dlplus.sh

# تحقق من أنه يعمل
curl http://localhost:8000/api/health
```

### خطأ: Invalid API key
**المشكلة:** مفتاح API غير صحيح

**الحل:**
1. تحقق من ملف `.env`
2. تأكد من استخدام نفس المفتاح في الكود
3. أعد توليد المفتاح إذا لزم الأمر:
   ```bash
   openssl rand -hex 32
   ```

---

## 📚 وثائق إضافية / Additional Documentation

- **[نظام DL+ الكامل](../dlplus/docs/DLPLUS_SYSTEM.md)**
- **[دليل البدء السريع](../DLPLUS_README.md)**
- **[تنفيذ أوامر Hostinger](../HOSTINGER_COMMAND_EXECUTION.md)**
- **[README الرئيسي](../README.md)**

---

## 🤝 المساهمة / Contributing

لإضافة مثال جديد:

To add a new example:

1. أنشئ ملف Python جديد في هذا المجلد
2. اتبع هيكل الأمثلة الموجودة
3. أضف تعليقات بالعربية والإنجليزية
4. حدّث هذا README
5. اختبر المثال

1. Create a new Python file in this directory
2. Follow the structure of existing examples
3. Add Arabic and English comments
4. Update this README
5. Test the example

---

## ⚡ ملاحظات سريعة / Quick Notes

- ✅ جميع الأمثلة تدعم العربية والإنجليزية
- ✅ استخدم `asyncio` لجميع الأمثلة
- ✅ أضف معالجة الأخطاء المناسبة
- ✅ وثّق الكود بشكل جيد
- ✅ اختبر قبل الإرسال

- ✅ All examples support Arabic and English
- ✅ Use `asyncio` for all examples
- ✅ Add proper error handling
- ✅ Document code well
- ✅ Test before submitting

---

**🌟 ابدأ الآن / Get Started Now:**

```bash
# 1. تثبيت المتطلبات / Install requirements
pip install -r requirements.txt

# 2. تشغيل مثال / Run an example
python examples/basic_usage.py
```

**للأسئلة أو المساعدة / For questions or help:**
- GitHub Issues: [فتح مشكلة / Open an issue](https://github.com/wasalstor-web/AI-Agent-Platform/issues)
