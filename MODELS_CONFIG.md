# OpenWebUI Models Configuration
# إعدادات نماذج OpenWebUI

## نماذج الذكاء الصناعي المفتوحة المصدر
## Open-Source AI Models

---

## 1. LLaMA 3 8B (Meta)

**معرف النموذج / Model ID:** `llama-3-8b`

**الوصف / Description:**
- نموذج لغوي كبير من Meta AI
- Large language model from Meta AI
- متعدد الأغراض للاستخدامات العامة
- General-purpose for various tasks

**القدرات / Capabilities:**
- فهم ومعالجة اللغة الطبيعية
- Natural language understanding and processing
- توليد النصوص
- Text generation
- الإجابة على الأسئلة
- Question answering
- الملخصات
- Summarization

**الاستخدام الأمثل / Best Use Cases:**
- المحادثات العامة / General conversations
- كتابة المحتوى / Content writing
- الترجمة / Translation
- التحليل / Analysis

---

## 2. Qwen 2.5 Arabic (Alibaba)

**معرف النموذج / Model ID:** `qwen-2.5-arabic`

**الوصف / Description:**
- نموذج متخصص في اللغة العربية من Alibaba Cloud
- Arabic-specialized model from Alibaba Cloud
- تدريب متقدم على النصوص العربية
- Advanced training on Arabic texts

**القدرات / Capabilities:**
- فهم عميق للغة العربية الفصحى والعامية
- Deep understanding of Modern Standard and Colloquial Arabic
- توليد نصوص عربية طبيعية
- Natural Arabic text generation
- تحليل المشاعر بالعربية
- Arabic sentiment analysis
- معالجة النصوص العربية المعقدة
- Complex Arabic text processing

**الاستخدام الأمثل / Best Use Cases:**
- المحادثات بالعربية / Arabic conversations
- كتابة المحتوى العربي / Arabic content writing
- الترجمة من وإلى العربية / Translation from/to Arabic
- التحليل اللغوي العربي / Arabic linguistic analysis

---

## 3. AraBERT (American University of Beirut)

**معرف النموذج / Model ID:** `arabert`

**الوصف / Description:**
- نموذج BERT مخصص للغة العربية
- BERT model specialized for Arabic
- من الجامعة الأمريكية في بيروت
- From American University of Beirut

**القدرات / Capabilities:**
- تحليل النصوص العربية
- Arabic text analysis
- استخراج الكيانات المسماة
- Named Entity Recognition (NER)
- تصنيف النصوص
- Text classification
- تحليل المشاعر
- Sentiment analysis

**الاستخدام الأمثل / Best Use Cases:**
- معالجة اللغة الطبيعية العربية / Arabic NLP
- استخراج المعلومات / Information extraction
- التصنيف التلقائي / Automatic classification
- البحث الدلالي / Semantic search

---

## 4. Mistral 7B (Mistral AI)

**معرف النموذج / Model ID:** `mistral-7b`

**الوصف / Description:**
- نموذج قوي وفعال من Mistral AI
- Powerful and efficient model from Mistral AI
- دعم متعدد اللغات
- Multilingual support

**القدرات / Capabilities:**
- معالجة متعددة اللغات
- Multilingual processing
- استدلال منطقي
- Logical reasoning
- توليد نصوص عالية الجودة
- High-quality text generation
- حل المشكلات
- Problem solving

**الاستخدام الأمثل / Best Use Cases:**
- المحادثات متعددة اللغات / Multilingual conversations
- التفكير المنطقي / Logical reasoning
- كتابة إبداعية / Creative writing
- المساعدة التقنية / Technical assistance

---

## 5. DeepSeek Coder (DeepSeek)

**معرف النموذج / Model ID:** `deepseek-coder`

**الوصف / Description:**
- نموذج متخصص في البرمجة
- Specialized coding model
- من DeepSeek AI
- From DeepSeek AI

**القدرات / Capabilities:**
- توليد الأكواد البرمجية
- Code generation
- شرح الأكواد
- Code explanation
- إصلاح الأخطاء البرمجية
- Bug fixing
- تحسين الكود
- Code optimization

**الاستخدام الأمثل / Best Use Cases:**
- كتابة الأكواد / Code writing
- مراجعة الكود / Code review
- التعلم البرمجي / Programming learning
- حل المشكلات البرمجية / Programming problem solving

**اللغات المدعومة / Supported Languages:**
- Python, JavaScript, Java, C++, C#, Go, Rust, PHP, Ruby, TypeScript, Swift, Kotlin

---

## 6. Phi-3 Mini (Microsoft)

**معرف النموذج / Model ID:** `phi-3-mini`

**الوصف / Description:**
- نموذج مدمج لكنه قوي من Microsoft
- Compact but powerful model from Microsoft
- كفاءة عالية في الأداء
- High performance efficiency

**القدرات / Capabilities:**
- معالجة سريعة
- Fast processing
- استهلاك موارد منخفض
- Low resource consumption
- فهم لغوي جيد
- Good language understanding
- إجابات دقيقة
- Accurate responses

**الاستخدام الأمثل / Best Use Cases:**
- الأجهزة محدودة الموارد / Resource-limited devices
- الاستجابة السريعة / Quick responses
- التطبيقات الخفيفة / Lightweight applications
- الاستخدام المكثف / High-volume usage

---

## إعدادات الأداء / Performance Settings

### استهلاك الذاكرة التقريبي / Approximate Memory Usage
- **LLaMA 3 8B:** ~16 GB RAM
- **Qwen 2.5 Arabic:** ~8 GB RAM
- **AraBERT:** ~4 GB RAM
- **Mistral 7B:** ~14 GB RAM
- **DeepSeek Coder:** ~10 GB RAM
- **Phi-3 Mini:** ~4 GB RAM

### سرعة الاستجابة / Response Speed
- **Phi-3 Mini:** الأسرع / Fastest
- **AraBERT:** سريع / Fast
- **Qwen 2.5 Arabic:** متوسط / Medium
- **Mistral 7B:** متوسط / Medium
- **DeepSeek Coder:** متوسط / Medium
- **LLaMA 3 8B:** متوسط إلى بطيء / Medium to Slow

---

## التكوين الموصى به / Recommended Configuration

### للاستخدام العام / For General Use
```json
{
  "default_model": "llama-3-8b",
  "fallback_model": "phi-3-mini",
  "timeout": 30,
  "max_tokens": 2048
}
```

### للمحتوى العربي / For Arabic Content
```json
{
  "default_model": "qwen-2.5-arabic",
  "fallback_model": "arabert",
  "timeout": 30,
  "max_tokens": 2048
}
```

### للبرمجة / For Coding
```json
{
  "default_model": "deepseek-coder",
  "fallback_model": "llama-3-8b",
  "timeout": 45,
  "max_tokens": 4096
}
```

### للأداء السريع / For Fast Performance
```json
{
  "default_model": "phi-3-mini",
  "fallback_model": "arabert",
  "timeout": 15,
  "max_tokens": 1024
}
```

---

## متطلبات التشغيل / System Requirements

### الحد الأدنى / Minimum
- **CPU:** 4 cores
- **RAM:** 8 GB
- **Storage:** 50 GB
- **Network:** 10 Mbps

### الموصى به / Recommended
- **CPU:** 8+ cores
- **RAM:** 32 GB
- **Storage:** 100 GB SSD
- **Network:** 100 Mbps
- **GPU:** Optional (NVIDIA with CUDA support)

---

## الترخيص / Licensing

جميع النماذج مفتوحة المصدر وتستخدم تراخيص متساهلة:

All models are open-source with permissive licenses:

- **LLaMA 3:** Meta License
- **Qwen 2.5:** Apache 2.0
- **AraBERT:** MIT License
- **Mistral 7B:** Apache 2.0
- **DeepSeek Coder:** DeepSeek License
- **Phi-3:** MIT License

---

## التحديثات المستقبلية / Future Updates

### نماذج مخطط إضافتها / Planned Models
- [ ] Falcon 7B (TII)
- [ ] BLOOM (BigScience)
- [ ] GPT-J (EleutherAI)
- [ ] Gemma (Google)
- [ ] Code Llama (Meta)

---

## الدعم / Support

للحصول على مساعدة في تكوين النماذج:

For help with model configuration:

- **Documentation:** `/api/docs`
- **GitHub Issues:** https://github.com/wasalstor-web/AI-Agent-Platform/issues
- **Models List:** `GET /api/models`

---

**تاريخ التحديث / Last Updated:** 2025-10-20  
**الإصدار / Version:** 1.0.0
