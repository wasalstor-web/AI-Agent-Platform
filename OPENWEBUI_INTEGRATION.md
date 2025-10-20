# OpenWebUI Integration Guide
# دليل التكامل مع OpenWebUI

## English

### Overview

The AI Agent Platform now integrates directly with OpenWebUI instances, allowing you to interact with AI models through a beautiful web interface. The platform is pre-configured to work with an OpenWebUI instance at `http://72.61.178.135:3000/`.

### Features

1. **Direct OpenWebUI Connection**
   - Pre-configured to connect to `http://72.61.178.135:3000/`
   - Automatic model discovery from the OpenWebUI instance
   - OpenAI-compatible API format support

2. **Dynamic Model Loading**
   - Automatically fetches available models from OpenWebUI
   - Falls back to default models if loading fails
   - Support for multiple model types (GPT, Claude, LLaMA, etc.)

3. **Enhanced User Experience**
   - One-click button to open OpenWebUI directly
   - Real-time connection status
   - Detailed error messages with troubleshooting tips
   - Form validation for API endpoints

4. **Chat History Management**
   - Maintains conversation context across messages
   - Reset history when reconnecting to models

### Getting Started

#### 1. Access the Interface

Open the web interface at:
- **Local**: `file:///path/to/index.html`
- **GitHub Pages**: `https://wasalstor-web.github.io/AI-Agent-Platform/`

#### 2. Connect to OpenWebUI

1. The interface is pre-configured with the OpenWebUI endpoint: `http://72.61.178.135:3000/`
2. Select a model from the dropdown (models are automatically loaded from OpenWebUI)
3. Click the **"اتصل" (Connect)** button
4. Wait for the connection confirmation

#### 3. Start Chatting

Once connected:
1. Type your message in the text area
2. Press Enter or click **"إرسال" (Send)**
3. The AI will respond with context from your conversation history

#### 4. Access OpenWebUI Directly

Click the **"🔗 OpenWebUI"** button to open the OpenWebUI interface in a new tab for advanced features.

### Configuration

#### API Settings

To change the OpenWebUI endpoint:

1. Click on **"⚙️ إعدادات API" (API Settings)**
2. Update the API endpoint URL (e.g., `http://your-server:3000/api/chat/completions`)
3. Add an API key if required (optional)
4. Click **"حفظ الإعدادات" (Save Settings)**
5. Reconnect to the model

#### Supported Endpoints

The integration supports OpenWebUI's standard endpoints:
- `/api/models` - List available models
- `/api/chat/completions` - OpenAI-compatible chat completions

### Troubleshooting

#### Connection Failed

**Symptoms**: "Connection Error" message appears

**Solutions**:
1. Verify the OpenWebUI server is running
2. Check if you can access `http://72.61.178.135:3000/` directly in your browser
3. If accessing from a different domain, ensure CORS is properly configured on OpenWebUI
4. Check your network connection and firewall settings

#### CORS Issues

If you see CORS-related errors:
1. Access OpenWebUI directly at `http://72.61.178.135:3000/` instead of through the integration
2. Configure OpenWebUI to allow CORS from your domain
3. Use a browser extension to bypass CORS for testing (not recommended for production)

#### Models Not Loading

If models don't appear in the dropdown:
1. Check if OpenWebUI has models installed
2. Verify the API endpoint is correct
3. Check browser console for error messages
4. The interface will fall back to default models

### API Request Format

The integration uses OpenAI-compatible format:

```json
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {"role": "user", "content": "Hello"},
    {"role": "assistant", "content": "Hi there!"},
    {"role": "user", "content": "How are you?"}
  ],
  "stream": false
}
```

### API Response Format

Expected response from OpenWebUI:

```json
{
  "id": "chat-id",
  "model": "gpt-3.5-turbo",
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "I'm doing well, thank you!"
      }
    }
  ]
}
```

---

## العربية

### نظرة عامة

تتكامل منصة وكيل الذكاء الاصطناعي الآن مباشرةً مع نسخ OpenWebUI، مما يتيح لك التفاعل مع نماذج الذكاء الاصطناعي من خلال واجهة ويب جميلة. المنصة مُعدة مسبقًا للعمل مع نسخة OpenWebUI على `http://72.61.178.135:3000/`.

### الميزات

1. **اتصال مباشر بـ OpenWebUI**
   - مُعد مسبقًا للاتصال بـ `http://72.61.178.135:3000/`
   - اكتشاف تلقائي للنماذج من نسخة OpenWebUI
   - دعم تنسيق API متوافق مع OpenAI

2. **تحميل النماذج الديناميكي**
   - يجلب النماذج المتاحة تلقائيًا من OpenWebUI
   - يعود إلى النماذج الافتراضية في حالة فشل التحميل
   - دعم أنواع متعددة من النماذج (GPT، Claude، LLaMA، إلخ)

3. **تجربة مستخدم محسنة**
   - زر بنقرة واحدة لفتح OpenWebUI مباشرة
   - حالة الاتصال في الوقت الفعلي
   - رسائل خطأ تفصيلية مع نصائح لحل المشاكل
   - التحقق من صحة النماذج لنقاط نهاية API

4. **إدارة سجل المحادثة**
   - يحافظ على سياق المحادثة عبر الرسائل
   - إعادة تعيين السجل عند إعادة الاتصال بالنماذج

### البدء

#### 1. الوصول إلى الواجهة

افتح واجهة الويب على:
- **محلي**: `file:///path/to/index.html`
- **GitHub Pages**: `https://wasalstor-web.github.io/AI-Agent-Platform/`

#### 2. الاتصال بـ OpenWebUI

1. الواجهة مُعدة مسبقًا مع نقطة نهاية OpenWebUI: `http://72.61.178.135:3000/`
2. اختر نموذجًا من القائمة المنسدلة (يتم تحميل النماذج تلقائيًا من OpenWebUI)
3. انقر على زر **"اتصل"**
4. انتظر تأكيد الاتصال

#### 3. بدء المحادثة

بمجرد الاتصال:
1. اكتب رسالتك في منطقة النص
2. اضغط Enter أو انقر على **"إرسال"**
3. سيستجيب الذكاء الاصطناعي مع سياق من سجل محادثتك

#### 4. الوصول المباشر إلى OpenWebUI

انقر على زر **"🔗 OpenWebUI"** لفتح واجهة OpenWebUI في علامة تبويب جديدة للحصول على ميزات متقدمة.

### التكوين

#### إعدادات API

لتغيير نقطة نهاية OpenWebUI:

1. انقر على **"⚙️ إعدادات API"**
2. قم بتحديث عنوان URL لنقطة نهاية API (مثل: `http://your-server:3000/api/chat/completions`)
3. أضف مفتاح API إذا كان مطلوبًا (اختياري)
4. انقر على **"حفظ الإعدادات"**
5. أعد الاتصال بالنموذج

#### نقاط النهاية المدعومة

يدعم التكامل نقاط نهاية OpenWebUI القياسية:
- `/api/models` - قائمة النماذج المتاحة
- `/api/chat/completions` - إكمال المحادثة المتوافق مع OpenAI

### حل المشاكل

#### فشل الاتصال

**الأعراض**: ظهور رسالة "خطأ في الاتصال"

**الحلول**:
1. تحقق من أن خادم OpenWebUI يعمل
2. تحقق من إمكانية الوصول إلى `http://72.61.178.135:3000/` مباشرة في متصفحك
3. إذا كنت تصل من نطاق مختلف، تأكد من تكوين CORS بشكل صحيح على OpenWebUI
4. تحقق من اتصال الشبكة وإعدادات جدار الحماية

#### مشاكل CORS

إذا رأيت أخطاء متعلقة بـ CORS:
1. قم بالوصول إلى OpenWebUI مباشرة على `http://72.61.178.135:3000/` بدلاً من التكامل
2. قم بتكوين OpenWebUI للسماح بـ CORS من نطاقك
3. استخدم امتداد متصفح لتجاوز CORS للاختبار (غير موصى به للإنتاج)

#### عدم تحميل النماذج

إذا لم تظهر النماذج في القائمة المنسدلة:
1. تحقق من أن OpenWebUI لديه نماذج مثبتة
2. تحقق من أن نقطة نهاية API صحيحة
3. تحقق من وحدة تحكم المتصفح لرسائل الخطأ
4. ستعود الواجهة إلى النماذج الافتراضية

### تنسيق طلب API

يستخدم التكامل تنسيقًا متوافقًا مع OpenAI:

```json
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {"role": "user", "content": "مرحبا"},
    {"role": "assistant", "content": "مرحبًا بك!"},
    {"role": "user", "content": "كيف حالك؟"}
  ],
  "stream": false
}
```

### تنسيق استجابة API

الاستجابة المتوقعة من OpenWebUI:

```json
{
  "id": "chat-id",
  "model": "gpt-3.5-turbo",
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "أنا بخير، شكرًا لك!"
      }
    }
  ]
}
```

---

## Technical Details

### Architecture

```
┌─────────────────┐
│   Web Browser   │
│   (index.html)  │
└────────┬────────┘
         │
         │ HTTP/HTTPS
         │
┌────────▼────────────────┐
│   OpenWebUI Server      │
│  72.61.178.135:3000     │
├─────────────────────────┤
│  /api/models            │
│  /api/chat/completions  │
└────────┬────────────────┘
         │
         │
┌────────▼────────┐
│  AI Models      │
│  (Ollama/etc)   │
└─────────────────┘
```

### Security Considerations

1. **API Keys**: Store API keys securely in browser localStorage
2. **HTTPS**: Use HTTPS in production to encrypt data in transit
3. **CORS**: Configure OpenWebUI CORS settings appropriately
4. **Input Validation**: All user inputs are validated before sending to API

### Browser Compatibility

- Chrome/Edge: ✅ Fully supported
- Firefox: ✅ Fully supported
- Safari: ✅ Supported (may have CORS limitations)
- Mobile browsers: ✅ Responsive design

### Performance

- Chat history is stored in memory (cleared on page refresh)
- API requests use `fetch` API with async/await
- No caching of responses (ensures fresh data)

---

## Support

For issues or questions:
- GitHub Issues: https://github.com/wasalstor-web/AI-Agent-Platform/issues
- OpenWebUI Docs: https://docs.openwebui.com

## License

This integration is part of the AI-Agent-Platform project.
