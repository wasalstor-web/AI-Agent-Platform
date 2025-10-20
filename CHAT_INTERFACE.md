# واجهة الدردشة التفاعلية / Interactive Chat Interface

## نظرة عامة / Overview

تتضمن منصة وكيل الذكاء الاصطناعي الآن واجهة دردشة تفاعلية مباشرة تسمح لك بالتواصل مع نماذج الذكاء الاصطناعي المختلفة.

The AI Agent Platform now includes an interactive chat interface that allows you to communicate directly with various AI models.

---

## الميزات / Features

### ✨ الميزات الرئيسية / Key Features

- **🤖 اختيار النماذج / Model Selection**: اختر من بين 8 نماذج ذكاء اصطناعي مختلفة
  - GPT-3.5 Turbo
  - GPT-4
  - Claude 3
  - LLaMA 3
  - Qwen Arabic (مثالي للعربية)
  - AraBERT (متخصص في اللغة العربية)
  - Mistral
  - DeepSeek Coder

- **💬 واجهة محادثة فورية / Real-time Chat Interface**
  - رسائل مع طوابع زمنية / Messages with timestamps
  - تمييز بصري بين رسائل المستخدم والمساعد / Visual distinction between user and assistant messages
  - مؤشر كتابة أثناء معالجة الطلبات / Typing indicator during request processing
  - تمرير تلقائي للرسائل الجديدة / Auto-scroll to new messages

- **⚙️ إعدادات API قابلة للتخصيص / Customizable API Settings**
  - تكوين نقطة نهاية API / Configure API endpoint
  - دعم مفتاح API الاختياري / Optional API key support
  - حفظ الإعدادات محلياً / Save settings locally

- **🌐 دعم ثنائي اللغة / Bilingual Support**
  - واجهة كاملة بالعربية والإنجليزية / Full Arabic and English interface
  - تبديل سلس بين اللغات / Seamless language switching

- **📱 تصميم متجاوب / Responsive Design**
  - يعمل على الهواتف والأجهزة اللوحية وأجهزة الكمبيوتر / Works on phones, tablets, and computers
  - واجهة قابلة للتكيف / Adaptive interface

---

## كيفية الاستخدام / How to Use

### 1️⃣ الوصول إلى الواجهة / Access the Interface

افتح الموقع في متصفحك:
Open the website in your browser:

```
https://wasalstor-web.github.io/AI-Agent-Platform/
```

أو محلياً:
Or locally:

```bash
# من مجلد المشروع / From project folder
python3 -m http.server 8080
# ثم افتح / Then open: http://localhost:8080/index.html
```

### 2️⃣ تكوين API / Configure API

قبل البدء، تأكد من تشغيل خادم API:
Before starting, make sure the API server is running:

#### باستخدام DL+ System / Using DL+ System:
```bash
cd /home/runner/work/AI-Agent-Platform/AI-Agent-Platform
./start-dlplus.sh
```

أو:
Or:

```bash
cd dlplus
python3 main.py
```

#### باستخدام Flask API / Using Flask API:
```bash
cd api
python3 server.py
```

### 3️⃣ ضبط الإعدادات / Adjust Settings

1. انقر على "⚙️ إعدادات API" في واجهة الدردشة
   Click on "⚙️ API Settings" in the chat interface

2. أدخل نقطة نهاية API (افتراضياً: `http://localhost:8000/api/process`)
   Enter the API endpoint (default: `http://localhost:8000/api/process`)

3. أدخل مفتاح API إذا كان مطلوباً (اختياري)
   Enter API key if required (optional)

4. انقر على "حفظ الإعدادات" / Click "Save Settings"

### 4️⃣ الاتصال بنموذج / Connect to a Model

1. اختر النموذج من القائمة المنسدلة
   Select a model from the dropdown

2. انقر على زر "اتصل" / Click the "Connect" button

3. انتظر حتى يتغير المؤشر إلى "🟢 متصل"
   Wait for the indicator to change to "🟢 Connected"

### 5️⃣ ابدأ المحادثة / Start Chatting

1. اكتب رسالتك في مربع النص
   Type your message in the text box

2. اضغط "إرسال" أو Enter للإرسال
   Press "Send" or Enter to send

3. شاهد الرد من النموذج
   Watch for the model's response

---

## تكوين الخادم / Server Configuration

### DL+ FastAPI Backend

نقطة النهاية الافتراضية / Default endpoint:
```
http://localhost:8000/api/process
```

تنسيق الطلب / Request format:
```json
{
  "command": "مرحباً، كيف حالك؟",
  "context": {
    "model": "gpt-3.5-turbo",
    "language": "ar"
  }
}
```

تنسيق الرد / Response format:
```json
{
  "success": true,
  "response": "مرحباً! أنا بخير، شكراً لسؤالك. كيف يمكنني مساعدتك اليوم؟",
  "intent": "greeting",
  "executor": "intelligence_core",
  "timestamp": "2025-10-20T10:42:00.000Z"
}
```

### Flask API Backend

نقطة النهاية / Endpoint:
```
http://localhost:5000/api/chat
```

تنسيق الطلب / Request format:
```json
{
  "message": "Hello, how are you?",
  "model": "gpt-3.5-turbo"
}
```

---

## استكشاف الأخطاء / Troubleshooting

### ❌ خطأ: "فشل الاتصال بالنموذج"
### ❌ Error: "Failed to connect to model"

**الحل / Solution:**

1. تأكد من تشغيل خادم API
   Make sure the API server is running

2. تحقق من نقطة النهاية في الإعدادات
   Check the endpoint in settings

3. تحقق من جدار الحماية والشبكة
   Check firewall and network

```bash
# اختبر الخادم / Test the server
curl http://localhost:8000/api/health
```

### ❌ خطأ: "مطلوب مفتاح API"
### ❌ Error: "API key required"

**الحل / Solution:**

1. احصل على مفتاح API من إعدادات الخادم
   Get API key from server settings

2. أدخله في إعدادات API
   Enter it in API settings

3. احفظ الإعدادات
   Save settings

### ❌ الرسائل لا تظهر
### ❌ Messages not showing

**الحل / Solution:**

1. افتح أدوات المطور (F12)
   Open Developer Tools (F12)

2. تحقق من وحدة التحكم للأخطاء
   Check Console for errors

3. تحقق من علامة تبويب الشبكة
   Check Network tab

4. تحديث الصفحة
   Refresh the page

---

## التخصيص / Customization

### إضافة نماذج جديدة / Add New Models

عدّل قائمة النماذج في `index.html`:
Edit the model list in `index.html`:

```html
<select id="model-select" class="model-dropdown">
    <option value="your-model">Your Model Name</option>
    <!-- أضف نماذجك هنا / Add your models here -->
</select>
```

عدّل دالة `getModelName()` في JavaScript:
Edit the `getModelName()` function in JavaScript:

```javascript
function getModelName(model) {
    const names = {
        'your-model': 'Your Model Display Name',
        // أضف أسماء النماذج هنا / Add model names here
    };
    return names[model] || model;
}
```

### تغيير نقطة النهاية الافتراضية / Change Default Endpoint

في `index.html`، ابحث عن:
In `index.html`, find:

```javascript
let apiEndpoint = 'http://localhost:8000/api/process';
```

غيّره إلى نقطة النهاية الخاصة بك:
Change it to your endpoint:

```javascript
let apiEndpoint = 'https://your-api-endpoint.com/api/process';
```

---

## الأمان / Security

### 🔒 أفضل الممارسات / Best Practices

1. **لا تشارك مفاتيح API علناً**
   **Never share API keys publicly**

2. **استخدم HTTPS في الإنتاج**
   **Use HTTPS in production**

3. **قم بالتحقق من صحة جميع المدخلات**
   **Validate all inputs**

4. **حدد معدل الطلبات**
   **Implement rate limiting**

5. **استخدم المصادقة المناسبة**
   **Use proper authentication**

---

## التكامل مع الخلفية / Backend Integration

### مثال: Python FastAPI

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class ChatRequest(BaseModel):
    command: str
    context: dict = {}

@app.post("/api/process")
async def process_command(request: ChatRequest):
    try:
        # معالجة الأمر / Process the command
        response = await your_ai_model.process(
            request.command,
            model=request.context.get("model", "gpt-3.5-turbo"),
            language=request.context.get("language", "en")
        )
        
        return {
            "success": True,
            "response": response,
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

### مثال: Node.js Express

```javascript
const express = require('express');
const app = express();

app.use(express.json());

app.post('/api/process', async (req, res) => {
    try {
        const { command, context } = req.body;
        
        // معالجة الأمر / Process the command
        const response = await yourAIModel.process(
            command,
            context.model,
            context.language
        );
        
        res.json({
            success: true,
            response: response,
            timestamp: new Date().toISOString()
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

app.listen(8000, () => {
    console.log('Server running on port 8000');
});
```

---

## الدعم والمساعدة / Support and Help

### 📚 موارد إضافية / Additional Resources

- [README.md](README.md) - نظرة عامة على المشروع / Project overview
- [OPENWEBUI.md](OPENWEBUI.md) - تكامل OpenWebUI / OpenWebUI integration
- [DLPLUS_README.md](DLPLUS_README.md) - نظام DL+ / DL+ System
- [DEPLOYMENT.md](DEPLOYMENT.md) - دليل النشر / Deployment guide

### 💬 الحصول على المساعدة / Get Help

- افتح Issue على GitHub / Open an Issue on GitHub
- راجع التوثيق / Check the documentation
- تحقق من السجلات / Check the logs

---

## التحديثات المستقبلية / Future Updates

### 🚀 قادم قريباً / Coming Soon

- [ ] حفظ سجل المحادثات / Save chat history
- [ ] تصدير المحادثات / Export conversations
- [ ] دعم الملفات المرفقة / File attachment support
- [ ] تكامل الصوت / Voice integration
- [ ] وضع الظلام / Dark mode
- [ ] اختصارات لوحة المفاتيح / Keyboard shortcuts
- [ ] بحث في المحادثات / Search in conversations
- [ ] محادثات متعددة / Multiple conversations

---

## المساهمة / Contributing

نرحب بمساهماتك! يرجى:
We welcome your contributions! Please:

1. Fork the repository
2. إنشاء فرع للميزة / Create a feature branch
3. إجراء التغييرات / Make your changes
4. إرسال Pull Request / Submit a Pull Request

---

## الترخيص / License

AI-Agent-Platform © 2025

---

**آخر تحديث / Last Updated:** 2025-10-20
**الإصدار / Version:** 1.0.0
