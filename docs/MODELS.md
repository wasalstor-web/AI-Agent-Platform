# Supreme Agent Models Documentation
# توثيق نماذج الوكيل الأعلى

## Overview / نظرة عامة

Supreme Agent supports multiple AI models, each optimized for different tasks. This guide helps you understand and choose the right model for your needs.

الوكيل الأعلى يدعم نماذج ذكاء اصطناعي متعددة، كل منها محسّن لمهام مختلفة. هذا الدليل يساعدك على فهم واختيار النموذج المناسب لاحتياجاتك.

## Available Models / النماذج المتاحة

### 1. Supreme Executor (supreme-executor) ⭐

**النموذج الرئيسي / Primary Model**

This is the custom-built model specifically designed for Supreme Agent. It combines the best features of multiple models with enhanced bilingual (Arabic/English) support.

هذا هو النموذج المخصص المصمم خصيصاً للوكيل الأعلى. يجمع أفضل ميزات النماذج المتعددة مع دعم ثنائي اللغة محسّن (عربي/إنجليزي).

**Capabilities / القدرات:**
- ✅ Bilingual chat (Arabic/English) / محادثة ثنائية اللغة
- ✅ Command execution / تنفيذ الأوامر
- ✅ File analysis / تحليل الملفات
- ✅ Code generation / توليد الأكواد
- ✅ Context understanding / فهم السياق
- ✅ Creative problem-solving / حل المشكلات الإبداعي

**Specifications / المواصفات:**
- Base Model: llama3
- Parameters: ~7B
- Context Length: 4096 tokens
- Temperature: 0.7 (default)
- Languages: Arabic, English (primary)

**Best For / الأفضل لـ:**
- General-purpose tasks / مهام عامة
- Bilingual conversations / محادثات ثنائية اللغة
- Complex problem-solving / حل المشكلات المعقدة
- Educational purposes / أغراض تعليمية

**Example Usage / مثال الاستخدام:**
```bash
supreme-agent chat "اشرح لي مفهوم الذكاء الاصطناعي"
supreme-agent execute "Create a Python web scraper"
```

---

### 2. Llama 3 (llama3)

**General Purpose Foundation Model / نموذج أساسي متعدد الأغراض**

Meta's Llama 3 is a powerful open-source model with excellent general knowledge and reasoning capabilities.

Llama 3 من Meta هو نموذج مفتوح المصدر قوي مع معرفة عامة ممتازة وقدرات استدلال.

**Capabilities / القدرات:**
- ✅ General knowledge / معرفة عامة
- ✅ Reasoning / استدلال
- ✅ Writing assistance / مساعدة في الكتابة
- ✅ Question answering / الإجابة على الأسئلة
- ⚠️ Limited Arabic support / دعم عربي محدود

**Specifications / المواصفات:**
- Parameters: 7B / 13B / 70B variants
- Context Length: 8192 tokens
- Languages: English (primary), others (limited)

**Best For / الأفضل لـ:**
- English conversations / محادثات إنجليزية
- General knowledge queries / استعلامات معرفية عامة
- Content creation / إنشاء المحتوى
- Research assistance / مساعدة بحثية

**Example Usage:**
```bash
ollama run llama3 "Explain quantum computing"
```

---

### 3. Aya (aya)

**Multilingual Specialist / متخصص متعدد اللغات**

Aya is specifically designed for multilingual tasks with excellent Arabic language support.

Aya مصمم خصيصاً للمهام متعددة اللغات مع دعم ممتاز للغة العربية.

**Capabilities / القدرات:**
- ⭐ Excellent Arabic support / دعم عربي ممتاز
- ✅ Multilingual understanding / فهم متعدد اللغات
- ✅ Translation / ترجمة
- ✅ Cultural context / سياق ثقافي
- ✅ Arabic text generation / توليد نصوص عربية

**Specifications / المواصفات:**
- Parameters: ~7B
- Languages: 101+ languages including Arabic
- Context Length: 4096 tokens

**Best For / الأفضل لـ:**
- Arabic conversations / محادثات عربية
- Translation tasks / مهام الترجمة
- Multilingual content / محتوى متعدد اللغات
- Arabic content generation / توليد محتوى عربي

**Example Usage:**
```bash
ollama run aya "اكتب قصيدة عن الذكاء الاصطناعي"
```

---

### 4. Mistral (mistral)

**Fast and Efficient Model / نموذج سريع وفعال**

Mistral 7B is known for its speed and efficiency while maintaining high quality outputs.

Mistral 7B معروف بسرعته وكفاءته مع الحفاظ على جودة عالية في المخرجات.

**Capabilities / القدرات:**
- ⚡ Fast response time / وقت استجابة سريع
- ✅ Efficient resource usage / استخدام فعال للموارد
- ✅ Good reasoning / استدلال جيد
- ✅ Code understanding / فهم الأكواد
- ⚠️ Limited Arabic / عربي محدود

**Specifications / المواصفات:**
- Parameters: 7B
- Context Length: 8192 tokens
- Speed: ~2x faster than similar models

**Best For / الأفضل لـ:**
- Quick responses / استجابات سريعة
- Resource-constrained environments / بيئات محدودة الموارد
- Real-time applications / تطبيقات فورية
- Batch processing / معالجة دفعية

**Example Usage:**
```bash
ollama run mistral "Write a quick summary of machine learning"
```

---

### 5. DeepSeek Coder (deepseek-coder)

**Programming Specialist / متخصص في البرمجة**

DeepSeek Coder is optimized specifically for programming tasks, code generation, and technical documentation.

DeepSeek Coder محسّن خصيصاً لمهام البرمجة وتوليد الأكواد والتوثيق التقني.

**Capabilities / القدرات:**
- ⭐ Excellent code generation / توليد أكواد ممتاز
- ✅ Multiple programming languages / لغات برمجة متعددة
- ✅ Code explanation / شرح الأكواد
- ✅ Debugging assistance / مساعدة في تصحيح الأخطاء
- ✅ Algorithm optimization / تحسين الخوارزميات

**Specifications / المواصفات:**
- Parameters: 6.7B
- Context Length: 16384 tokens
- Supports: Python, Java, C++, JavaScript, and 80+ languages

**Best For / الأفضل لـ:**
- Code generation / توليد الأكواد
- Programming assistance / مساعدة برمجية
- Code review / مراجعة الأكواد
- Technical documentation / توثيق تقني

**Example Usage:**
```bash
supreme-agent generate-code "Binary search algorithm" --lang python
ollama run deepseek-coder "Optimize this Python function"
```

---

### 6. Qwen2 (qwen2)

**Advanced Chinese-English Model / نموذج صيني-إنجليزي متقدم**

Qwen2 is an advanced model with strong performance in both English and Chinese, with some multilingual capabilities.

Qwen2 هو نموذج متقدم بأداء قوي في الإنجليزية والصينية، مع بعض القدرات متعددة اللغات.

**Capabilities / القدرات:**
- ✅ Strong reasoning / استدلال قوي
- ✅ Mathematical tasks / مهام رياضية
- ✅ Code generation / توليد أكواد
- ✅ Long context understanding / فهم سياق طويل
- ⚠️ Limited Arabic / عربي محدود

**Specifications / المواصفات:**
- Parameters: 7B
- Context Length: 32768 tokens (very long!)
- Languages: English, Chinese (primary)

**Best For / الأفضل لـ:**
- Long document analysis / تحليل مستندات طويلة
- Mathematical reasoning / استدلال رياضي
- Complex problem-solving / حل مشكلات معقدة
- Extended conversations / محادثات ممتدة

**Example Usage:**
```bash
ollama run qwen2 "Solve this complex math problem"
```

---

## Model Comparison / مقارنة النماذج

| Model | Arabic Support | Speed | Code Gen | Context | Best Use Case |
|-------|---------------|-------|----------|---------|---------------|
| **supreme-executor** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | 4K | All-purpose, Bilingual |
| **aya** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | 4K | Arabic conversations |
| **llama3** | ⭐ | ⭐⭐ | ⭐⭐ | 8K | English general tasks |
| **mistral** | ⭐ | ⭐⭐⭐ | ⭐⭐ | 8K | Fast responses |
| **deepseek-coder** | ⭐ | ⭐⭐ | ⭐⭐⭐ | 16K | Programming |
| **qwen2** | ⭐ | ⭐⭐ | ⭐⭐⭐ | 32K | Long contexts |

⭐⭐⭐ Excellent / ممتاز  
⭐⭐ Good / جيد  
⭐ Limited / محدود

## Choosing the Right Model / اختيار النموذج المناسب

### For Arabic Users / للمستخدمين العرب
1. **supreme-executor** - أفضل خيار للاستخدام العام
2. **aya** - للمحادثات العربية البحتة
3. **deepseek-coder** - للبرمجة (مع ملاحظات بالعربية)

### For English Users
1. **supreme-executor** - Best for general use
2. **llama3** - For knowledge-intensive tasks
3. **mistral** - For quick responses
4. **deepseek-coder** - For programming

### For Specific Tasks / لمهام محددة

**Programming / البرمجة:**
1. deepseek-coder
2. supreme-executor
3. qwen2

**Arabic Content / محتوى عربي:**
1. aya
2. supreme-executor

**Speed-Critical / السرعة مهمة:**
1. mistral
2. supreme-executor

**Long Documents / مستندات طويلة:**
1. qwen2
2. llama3

## Customizing Models / تخصيص النماذج

You can create your own custom models based on these foundation models.

يمكنك إنشاء نماذج مخصصة خاصة بك بناءً على هذه النماذج الأساسية.

### Creating a Custom Modelfile / إنشاء Modelfile مخصص

```modelfile
# My Custom Model
FROM llama3

# System prompt
SYSTEM """
You are a specialized assistant for [your domain].
أنت مساعد متخصص في [مجالك].
"""

# Parameters
PARAMETER temperature 0.8
PARAMETER top_p 0.9
PARAMETER top_k 40
```

### Building the Model / بناء النموذج

```bash
ollama create my-custom-model -f Modelfile
```

### Using Custom Models / استخدام النماذج المخصصة

```bash
# في سطر الأوامر / Command line
ollama run my-custom-model "Your prompt"

# في Supreme Agent / In Supreme Agent
# Update config/settings.json:
{
  "agent": {
    "default_model": "my-custom-model"
  }
}
```

## Model Management / إدارة النماذج

### List Models / قائمة النماذج
```bash
ollama list
```

### Pull a Model / تحميل نموذج
```bash
ollama pull llama3
ollama pull aya
```

### Remove a Model / حذف نموذج
```bash
ollama rm model-name
```

### Update a Model / تحديث نموذج
```bash
ollama pull model-name
```

## Performance Optimization / تحسين الأداء

### Memory Requirements / متطلبات الذاكرة

| Model | Minimum RAM | Recommended RAM |
|-------|-------------|-----------------|
| 7B models | 8 GB | 16 GB |
| 13B models | 16 GB | 32 GB |
| 70B models | 64 GB | 128 GB |

### CPU vs GPU / المعالج مقابل بطاقة الرسوميات

- **CPU Only**: Slower but accessible / أبطأ لكن متاح
- **GPU (NVIDIA)**: 10-100x faster / أسرع 10-100 مرة
- **Apple Silicon**: Good performance with Metal / أداء جيد مع Metal

### Tips for Better Performance / نصائح لأداء أفضل

1. **Use smaller models** for faster responses
   استخدم نماذج أصغر للاستجابات الأسرع

2. **Adjust temperature** for different use cases
   اضبط درجة الحرارة لحالات استخدام مختلفة

3. **Clear cache** periodically
   امسح الذاكرة المؤقتة بشكل دوري

4. **Monitor resource usage**
   راقب استخدام الموارد

## Troubleshooting / حل المشاكل

### Model Not Loading / النموذج لا يتحمل
```bash
# Check if model exists
ollama list

# Re-pull the model
ollama pull model-name

# Check system resources
free -h  # Linux
```

### Slow Response Times / بطء في الاستجابة
- Use a smaller model
- Close other applications
- Consider using GPU
- Reduce context length

### Out of Memory Errors / أخطاء نفاد الذاكرة
- Use a smaller model
- Reduce max_tokens
- Close other applications
- Add swap space (Linux)

## Best Practices / أفضل الممارسات

1. **Start with supreme-executor** for general use
   ابدأ بـ supreme-executor للاستخدام العام

2. **Use specialized models** for specific tasks
   استخدم نماذج متخصصة لمهام محددة

3. **Monitor performance** and switch models as needed
   راقب الأداء وبدّل النماذج حسب الحاجة

4. **Keep models updated** for improvements
   حدّث النماذج للحصول على تحسينات

5. **Experiment** to find what works best
   جرّب لتجد ما يعمل أفضل

## Resources / المصادر

- **Ollama Library**: https://ollama.ai/library
- **Model Cards**: Detailed information about each model
- **Community Forum**: Share experiences and tips
- **GitHub**: Model implementations and examples

## Frequently Asked Questions / الأسئلة الشائعة

**Q: Can I use multiple models simultaneously?**
**س: هل يمكنني استخدام نماذج متعددة في نفس الوقت؟**

A: Yes, but they will share system resources. Be mindful of RAM usage.
ج: نعم، لكنها ستشارك موارد النظام. انتبه لاستخدام الذاكرة.

**Q: Which model is best for Arabic?**
**س: أي نموذج أفضل للعربية؟**

A: supreme-executor and aya are best for Arabic.
ج: supreme-executor و aya هما الأفضل للعربية.

**Q: Can I fine-tune these models?**
**س: هل يمكنني ضبط هذه النماذج بدقة؟**

A: Yes, but it requires advanced knowledge and significant compute resources.
ج: نعم، لكن يتطلب معرفة متقدمة وموارد حوسبة كبيرة.

---

**Supreme Agent Models Documentation** v1.0.0  
© 2025 wasalstor-web
