# Supreme Agent API Documentation
# توثيق واجهة برمجة التطبيقات للوكيل الأعلى

## Overview / نظرة عامة

Supreme Agent API is a RESTful API that provides access to advanced AI capabilities including chat, command execution, file analysis, and code generation.

واجهة برمجة التطبيقات للوكيل الأعلى هي API RESTful توفر الوصول إلى قدرات الذكاء الاصطناعي المتقدمة بما في ذلك المحادثة وتنفيذ الأوامر وتحليل الملفات وتوليد الأكواد.

## Base URL / عنوان الأساس

```
http://localhost:5000
```

## Authentication / المصادقة

Currently, the API does not require authentication. You can enable API key authentication in `config/settings.json`.

حالياً، لا تتطلب واجهة برمجة التطبيقات مصادقة. يمكنك تفعيل مفتاح API في `config/settings.json`.

## Endpoints / نقاط النهاية

### 1. Health Check / فحص الصحة

Check the health status of the API server and Ollama connection.

**Endpoint:**
```
GET /api/health
```

**Response / الاستجابة:**
```json
{
  "status": "healthy",
  "ollama_connected": true,
  "model_available": true,
  "current_model": "supreme-executor",
  "available_models": ["supreme-executor", "llama3", "aya", "mistral"],
  "conversation_history_size": 10,
  "timestamp": "2025-10-20T07:10:50.282Z"
}
```

**cURL Example:**
```bash
curl http://localhost:5000/api/health
```

**Python Example:**
```python
import requests

response = requests.get('http://localhost:5000/api/health')
print(response.json())
```

**JavaScript Example:**
```javascript
fetch('http://localhost:5000/api/health')
  .then(response => response.json())
  .then(data => console.log(data));
```

---

### 2. Chat / المحادثة

Send a message to the agent and receive an intelligent response.

**Endpoint:**
```
POST /api/chat
```

**Request Body / طلب:**
```json
{
  "message": "مرحباً، كيف يمكنني مساعدتك؟",
  "context": "نتحدث عن البرمجة" // optional
}
```

**Response / الاستجابة:**
```json
{
  "success": true,
  "response": "مرحباً! أنا هنا لمساعدتك في أي شيء تحتاجه. كيف يمكنني مساعدتك اليوم؟",
  "timestamp": "2025-10-20T07:10:50.282Z"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:5000/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello! How are you?",
    "context": "We are discussing programming"
  }'
```

**Python Example:**
```python
import requests

data = {
    "message": "اكتب لي برنامج بايثون بسيط",
    "context": "نحتاج برنامج حاسبة"
}

response = requests.post('http://localhost:5000/api/chat', json=data)
print(response.json()['response'])
```

**JavaScript Example:**
```javascript
const data = {
  message: "What is Python?",
  context: "Learning programming"
};

fetch('http://localhost:5000/api/chat', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(data)
})
  .then(response => response.json())
  .then(data => console.log(data.response));
```

---

### 3. Execute Command / تنفيذ أمر

Execute a command or task and get the result.

**Endpoint:**
```
POST /api/execute
```

**Request Body / طلب:**
```json
{
  "command": "اكتب سكريبت bash لنسخ الملفات"
}
```

**Response / الاستجابة:**
```json
{
  "success": true,
  "response": "#!/bin/bash\n# Script to copy files\n\nsource_dir=\"$1\"\ndest_dir=\"$2\"\n\nif [ -z \"$source_dir\" ] || [ -z \"$dest_dir\" ]; then\n  echo \"Usage: $0 <source> <destination>\"\n  exit 1\nfi\n\ncp -r \"$source_dir\"/* \"$dest_dir\"/\necho \"Files copied successfully!\"",
  "timestamp": "2025-10-20T07:10:50.282Z"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:5000/api/execute \
  -H "Content-Type: application/json" \
  -d '{
    "command": "Create a Python script to read CSV files"
  }'
```

**Python Example:**
```python
import requests

data = {
    "command": "اكتب دالة لحساب المتوسط الحسابي"
}

response = requests.post('http://localhost:5000/api/execute', json=data)
print(response.json()['response'])
```

---

### 4. Analyze File / تحليل ملف

Analyze a file and get comprehensive insights.

**Endpoint:**
```
POST /api/analyze
```

**Request Body / طلب:**
```json
{
  "filepath": "/path/to/file.py"
}
```

**Response / الاستجابة:**
```json
{
  "success": true,
  "filename": "file.py",
  "filepath": "/path/to/file.py",
  "size": 1024,
  "extension": ".py",
  "analysis": "هذا ملف Python يحتوي على...\nThis Python file contains...",
  "timestamp": "2025-10-20T07:10:50.282Z"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:5000/api/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "filepath": "/home/user/script.py"
  }'
```

**Python Example:**
```python
import requests

data = {
    "filepath": "/path/to/myfile.js"
}

response = requests.post('http://localhost:5000/api/analyze', json=data)
result = response.json()

if result['success']:
    print(f"File: {result['filename']}")
    print(f"Size: {result['size']} bytes")
    print(f"Analysis:\n{result['analysis']}")
```

---

### 5. Generate Code / توليد كود

Generate code based on a description in any programming language.

**Endpoint:**
```
POST /api/generate-code
```

**Request Body / طلب:**
```json
{
  "description": "برنامج حاسبة بسيط",
  "language": "python"
}
```

**Response / الاستجابة:**
```json
{
  "success": true,
  "code": "# Simple Calculator Program\n\ndef add(x, y):\n    return x + y\n\ndef subtract(x, y):\n    return x - y\n\n# ... more code",
  "language": "python",
  "timestamp": "2025-10-20T07:10:50.282Z"
}
```

**Supported Languages / اللغات المدعومة:**
- `python`
- `javascript`
- `java`
- `cpp` (C++)
- `csharp` (C#)
- `go`
- `rust`
- `php`
- `ruby`
- `swift`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/api/generate-code \
  -H "Content-Type: application/json" \
  -d '{
    "description": "A function to calculate factorial",
    "language": "python"
  }'
```

**Python Example:**
```python
import requests

data = {
    "description": "دالة لترتيب قائمة من الأرقام",
    "language": "python"
}

response = requests.post('http://localhost:5000/api/generate-code', json=data)
print(response.json()['code'])
```

**JavaScript Example:**
```javascript
const data = {
  description: "A REST API endpoint for user authentication",
  language: "javascript"
};

fetch('http://localhost:5000/api/generate-code', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(data)
})
  .then(response => response.json())
  .then(data => console.log(data.code));
```

---

### 6. List Models / قائمة النماذج

Get a list of all available AI models.

**Endpoint:**
```
GET /api/models
```

**Response / الاستجابة:**
```json
{
  "success": true,
  "models": [
    "supreme-executor",
    "llama3",
    "aya",
    "mistral",
    "deepseek-coder",
    "qwen2"
  ],
  "current_model": "supreme-executor",
  "timestamp": "2025-10-20T07:10:50.282Z"
}
```

**cURL Example:**
```bash
curl http://localhost:5000/api/models
```

**Python Example:**
```python
import requests

response = requests.get('http://localhost:5000/api/models')
models = response.json()['models']

print("Available models:")
for model in models:
    print(f"  - {model}")
```

---

## Error Handling / معالجة الأخطاء

All endpoints return a consistent error format:

```json
{
  "success": false,
  "error": "Error message description"
}
```

**HTTP Status Codes:**
- `200` - Success / نجاح
- `400` - Bad Request / طلب خاطئ
- `404` - Not Found / غير موجود
- `500` - Internal Server Error / خطأ في الخادم

## Rate Limiting / تحديد المعدل

Currently, there is no rate limiting. You can enable it in `config/settings.json`.

حالياً، لا يوجد تحديد للمعدل. يمكنك تفعيله في `config/settings.json`.

## CORS / مشاركة الموارد عبر المصادر

CORS is enabled by default for all origins. You can configure allowed origins in `config/settings.json`.

CORS مفعّل افتراضياً لجميع المصادر. يمكنك تكوين المصادر المسموحة في `config/settings.json`.

## WebSocket Support / دعم WebSocket

WebSocket support for streaming responses is planned for a future release.

دعم WebSocket للاستجابات المتدفقة مخطط له في إصدار مستقبلي.

## Best Practices / أفضل الممارسات

1. **Error Handling / معالجة الأخطاء**
   - Always check the `success` field in responses
   - Handle network errors gracefully

2. **Context Management / إدارة السياق**
   - Use the `context` parameter in chat for better responses
   - The agent maintains conversation history automatically

3. **File Paths / مسارات الملفات**
   - Use absolute paths for file analysis
   - Ensure files are readable by the API server

4. **Code Generation / توليد الأكواد**
   - Be specific in your descriptions
   - Mention any specific requirements or constraints

## Examples / أمثلة

### Complete Python Script / سكريبت بايثون كامل

```python
#!/usr/bin/env python3
"""
Supreme Agent API Client Example
"""

import requests
import json

class SupremeAgentClient:
    def __init__(self, base_url='http://localhost:5000'):
        self.base_url = base_url
    
    def health_check(self):
        """Check API health"""
        response = requests.get(f'{self.base_url}/api/health')
        return response.json()
    
    def chat(self, message, context=None):
        """Send a chat message"""
        data = {'message': message}
        if context:
            data['context'] = context
        
        response = requests.post(f'{self.base_url}/api/chat', json=data)
        return response.json()
    
    def execute(self, command):
        """Execute a command"""
        data = {'command': command}
        response = requests.post(f'{self.base_url}/api/execute', json=data)
        return response.json()
    
    def analyze_file(self, filepath):
        """Analyze a file"""
        data = {'filepath': filepath}
        response = requests.post(f'{self.base_url}/api/analyze', json=data)
        return response.json()
    
    def generate_code(self, description, language='python'):
        """Generate code"""
        data = {'description': description, 'language': language}
        response = requests.post(f'{self.base_url}/api/generate-code', json=data)
        return response.json()
    
    def get_models(self):
        """Get available models"""
        response = requests.get(f'{self.base_url}/api/models')
        return response.json()

# Usage Example
if __name__ == '__main__':
    client = SupremeAgentClient()
    
    # Health check
    health = client.health_check()
    print(f"Status: {health['status']}")
    
    # Chat
    chat_response = client.chat("مرحباً! كيف حالك؟")
    print(f"Agent: {chat_response['response']}")
    
    # Generate code
    code = client.generate_code("برنامج حاسبة بسيط", "python")
    print(f"Generated code:\n{code['code']}")
```

### Complete JavaScript Example / مثال JavaScript كامل

```javascript
/**
 * Supreme Agent API Client
 */
class SupremeAgentClient {
  constructor(baseUrl = 'http://localhost:5000') {
    this.baseUrl = baseUrl;
  }
  
  async healthCheck() {
    const response = await fetch(`${this.baseUrl}/api/health`);
    return await response.json();
  }
  
  async chat(message, context = null) {
    const data = { message };
    if (context) data.context = context;
    
    const response = await fetch(`${this.baseUrl}/api/chat`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    return await response.json();
  }
  
  async execute(command) {
    const response = await fetch(`${this.baseUrl}/api/execute`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ command })
    });
    return await response.json();
  }
  
  async analyzeFile(filepath) {
    const response = await fetch(`${this.baseUrl}/api/analyze`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ filepath })
    });
    return await response.json();
  }
  
  async generateCode(description, language = 'python') {
    const response = await fetch(`${this.baseUrl}/api/generate-code`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ description, language })
    });
    return await response.json();
  }
  
  async getModels() {
    const response = await fetch(`${this.baseUrl}/api/models`);
    return await response.json();
  }
}

// Usage
const client = new SupremeAgentClient();

// Health check
client.healthCheck().then(health => {
  console.log('Status:', health.status);
});

// Chat
client.chat('Hello!').then(response => {
  console.log('Agent:', response.response);
});
```

## Support / الدعم

For issues or questions:
- GitHub Issues: https://github.com/wasalstor-web/AI-Agent-Platform/issues
- Documentation: See README.md and docs/

للأسئلة أو المشاكل:
- GitHub Issues: https://github.com/wasalstor-web/AI-Agent-Platform/issues
- التوثيق: انظر README.md و docs/

---

**Supreme Agent API Documentation** v1.0.0  
© 2025 wasalstor-web
