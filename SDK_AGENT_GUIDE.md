# 🚀 دليل وكيل SDK الاحترافي - Professional SDK Agent Guide

## نظرة عامة | Overview

**وكيل SDK الاحترافي** هو وكيل شامل ومتقدم يوفر واجهة موحدة لجميع الوكلاء الأخرى في نظام DL+. يتميز بتحليل متقدم، تخطيط ذكي، تنفيذ محسّن، ومراقبة شاملة للأداء.

**Professional SDK Agent** is an advanced universal agent that provides a unified interface for all other agents in the DL+ system. Features advanced analysis, intelligent planning, optimized execution, and comprehensive performance monitoring.

## ✨ الميزات الاحترافية | Professional Features

- ✅ **تحليل متقدم للمهام**: تحليل شامل للمهام مع تقييم التعقيد والأولويات
- ✅ **تخطيط ذكي**: إنشاء خطط تنفيذ محسّنة تلقائياً
- ✅ **تنفيذ محسّن**: تنفيذ متوازي وتحسين تلقائي
- ✅ **مراقبة الأداء**: تتبع شامل للأداء والإحصائيات
- ✅ **نظام التعلم**: تعلم من التنفيذات السابقة لتحسين الأداء
- ✅ **التخزين المؤقت الذكي**: تخزين مؤقت ذكي للنتائج
- ✅ **تقارير شاملة**: تقارير تفصيلية مع تحليلات وإحصائيات
- ✅ **معالجة أخطاء متقدمة**: معالجة أخطاء ذكية مع توصيات

---

## ✨ الميزات الرئيسية | Key Features

- ✅ **واجهة موحدة**: واجهة واحدة لجميع الوكلاء
- ✅ **كشف تلقائي**: يكتشف تلقائياً العملية المطلوبة
- ✅ **عمليات متعددة**: تنسيق عدة وكلاء معاً
- ✅ **عمليات جماعية**: معالجة عدة نصوص دفعة واحدة
- ✅ **سهولة الاستخدام**: واجهة بسيطة وواضحة

---

## 📦 التثبيت | Installation

```python
from dlplus.agents import SDKAgent

# إنشاء وكيل SDK
sdk = SDKAgent()
```

---

## 📊 التحليلات والتقارير | Analytics and Reports

### الحصول على التحليلات

```python
# الحصول على تحليلات شاملة
analytics = await sdk.get_analytics()

print(f"إجمالي المهام: {analytics['performance']['total_tasks']}")
print(f"معدل النجاح: {analytics['performance']['successful_tasks'] / analytics['performance']['total_tasks'] * 100:.1f}%")
print(f"متوسط المدة: {analytics['performance']['average_duration']:.2f}s")
print(f"معدل التخزين المؤقت: {analytics['cache_stats']['hit_rate'] * 100:.1f}%")
```

### توليد تقرير شامل

```python
# توليد تقرير JSON
report = await sdk.generate_report(format='json')

# أو كسلسلة نصية
report_text = await sdk.generate_report(format='text')
```

### فحص الصحة الشامل

```python
health = await sdk.health_check()

print(f"حالة SDK Agent: {health['sdk_agent']['status']}")
print(f"معدل النجاح: {health['performance']['success_rate'] * 100:.1f}%")
print(f"حجم التخزين المؤقت: {health['system']['cache_size']}")
```

## 🎯 الاستخدام الأساسي | Basic Usage

### 1. البحث | Search

```python
# البحث البسيط
result = await sdk.search("الذكاء الاصطناعي")

# البحث مع خيارات
result = await sdk.search(
    "Python best practices",
    max_results=20,
    search_type="web"
)
```

### 2. توليد الأكواد | Code Generation

```python
# توليد كود بسيط
result = await sdk.generate_code(
    "دالة لحساب مجموع قائمة",
    language="python"
)

# توليد كود مع اختبارات
result = await sdk.generate_code(
    "دالة لفرز قائمة",
    language="python",
    include_tests=True,
    optimize=True
)
```

### 3. الترجمة | Translation

```python
# ترجمة بسيطة
result = await sdk.translate(
    "مرحباً بك في نظام DL+",
    target_language="en"
)

# ترجمة مع خيارات
result = await sdk.translate(
    "هذا نص للترجمة",
    source_language="ar",
    target_language="en",
    style="formal"
)
```

### 4. التحليل | Analysis

```python
# تحليل شامل
result = await sdk.analyze(
    "هذا منتج رائع ومفيد جداً",
    analysis_type="comprehensive"
)

# تحليل المشاعر فقط
result = await sdk.analyze(
    "أنا سعيد جداً بهذا المنتج",
    analysis_type="sentiment"
)
```

---

## 🔄 الكشف التلقائي | Auto Detection

يمكن لوكيل SDK اكتشاف العملية المطلوبة تلقائياً:

```python
# الكشف التلقائي
result = await sdk.execute({
    "action": "auto",
    "description": "ابحث عن الذكاء الاصطناعي"
})
# سيستخدم وكيل البحث تلقائياً

result = await sdk.execute({
    "action": "auto",
    "description": "اكتب كود Python"
})
# سيستخدم وكيل توليد الأكواد تلقائياً
```

---

## 🔗 عمليات متعددة الوكلاء | Multi-Agent Operations

### البحث والتحليل | Search and Analyze

```python
result = await sdk.search_and_analyze(
    "الذكاء الاصطناعي في 2024",
    analyze_results=True
)
```

### الترجمة والتحليل | Translate and Analyze

```python
result = await sdk.translate_and_analyze(
    "هذا منتج رائع",
    target_language="en"
)
```

### توليد كود مع البحث | Generate Code with Search

```python
result = await sdk.generate_code_with_search(
    "دالة لفرز قائمة",
    language="python",
    search_first=True  # البحث عن أفضل الممارسات أولاً
)
```

### تحليل شامل | Comprehensive Analysis

```python
result = await sdk.comprehensive_analysis(
    "نص للتحليل",
    translate=True,
    target_language="en"
)
```

---

## 📦 عمليات جماعية | Batch Operations

### ترجمة جماعية | Batch Translation

```python
texts = ["مرحباً", "شكراً", "مع السلامة"]
result = await sdk.batch_translate(
    texts,
    target_language="en"
)
```

### تحليل جماعي | Batch Analysis

```python
texts = ["نص 1", "نص 2", "نص 3"]
result = await sdk.batch_analyze(
    texts,
    analysis_type="sentiment"
)
```

---

## 🛠️ وظائف مساعدة | Utility Methods

### فحص الحقائق | Fact Checking

```python
result = await sdk.fact_check(
    "الذكاء الاصطناعي سيتجاوز البشر في 2025"
)
print(result['verdict_arabic'])  # الحكم
print(result['credibility_score'])  # درجة المصداقية
```

### مراجعة الكود | Code Review

```python
code = """
def calculate_sum(numbers):
    total = 0
    for num in numbers:
        total += num
    return total
"""

result = await sdk.review_code(code, language="python")
print(result['analysis']['quality_score'])
```

### معلومات الوكلاء | Agent Info

```python
# الحصول على العمليات المتاحة
actions = sdk.get_available_actions()
print(actions)  # ['search', 'code', 'translate', ...]

# معلومات الوكلاء
info = sdk.get_agent_info()
print(info)

# فحص الصحة
health = await sdk.health_check()
print(health)
```

---

## 📋 قائمة العمليات المتاحة | Available Actions

| العملية | الوصف | المثال |
|---------|-------|--------|
| `search` | البحث على الويب | `await sdk.search("query")` |
| `code` | توليد الأكواد | `await sdk.generate_code("description")` |
| `translate` | الترجمة | `await sdk.translate("text")` |
| `analyze` | التحليل | `await sdk.analyze("text")` |
| `auto` | كشف تلقائي | `await sdk.execute({"action": "auto", ...})` |

---

## 💡 أمثلة متقدمة | Advanced Examples

### مثال 1: سير عمل كامل

```python
# 1. البحث عن معلومات
search_result = await sdk.search("Python best practices")

# 2. تحليل النتائج
analysis = await sdk.analyze(
    search_result['result']['summary'],
    analysis_type="comprehensive"
)

# 3. توليد كود بناءً على النتائج
code = await sdk.generate_code(
    "تنفيذ أفضل الممارسات من التحليل",
    language="python",
    include_tests=True
)

# 4. مراجعة الكود
review = await sdk.review_code(
    code['result']['code'],
    language="python"
)
```

### مثال 2: معالجة متعددة الخطوات

```python
# نص للتحليل
text = "نظام DL+ هو نظام ذكاء اصطناعي متقدم"

# تحليل شامل مع ترجمة
result = await sdk.comprehensive_analysis(
    text,
    translate=True,
    target_language="en"
)

# النتائج
print("التحليل الأصلي:", result['results']['analysis'])
print("الترجمة:", result['results']['translation'])
print("تحليل المترجم:", result['results']['translated_analysis'])
```

---

## ⚙️ الإعدادات | Configuration

```python
# إعدادات مخصصة
config = {
    'web_retrieval': {
        'max_results': 20,
        'timeout': 60
    },
    'code_generator': {
        'enable_code_analysis': True,
        'enable_auto_fix': True
    },
    'translation': {
        'enable_context_aware': True
    },
    'analysis': {
        'analysis_types': ['sentiment', 'topic', 'entity']
    }
}

sdk = SDKAgent(config=config)
```

---

## 🎯 أفضل الممارسات | Best Practices

1. **استخدم الكشف التلقائي** عندما تكون غير متأكد من العملية
2. **استخدم العمليات المتعددة** للمهام المعقدة
3. **استخدم العمليات الجماعية** لمعالجة عدة نصوص
4. **راجع النتائج** دائماً قبل الاستخدام
5. **استخدم الإعدادات المخصصة** للتحكم في السلوك

---

## 📚 المزيد من الأمثلة

راجع ملف `examples/sdk_agent_usage.py` لمزيد من الأمثلة الشاملة.

---

## 🔗 روابط مفيدة

- [دليل الوكلاء](AGENTS_DEVELOPMENT.md)
- [دليل المكتبات](LIBRARIES_GUIDE.md)
- [أمثلة الاستخدام](examples/sdk_agent_usage.py)

---

**آخر تحديث**: 2025-01-XX  
**الإصدار**: 2.0.0

