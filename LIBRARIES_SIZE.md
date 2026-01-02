# 📦 أحجام المكتبات - Libraries Size Guide

## حجم المكتبات المضافة للوكلاء المطورة

---

## 📊 جدول الأحجام الفعلية (من PyPI)

| المكتبة | حجم التحميل | الحجم بعد التثبيت | التبعيات | الوصف |
|---------|-------------|-------------------|----------|--------|
| **beautifulsoup4** | 107 KB | ~2-3 MB | soupsieve (36 KB) | صغيرة - تحليل HTML |
| **lxml** | ~5-10 MB | ~15-20 MB | - | متوسطة - محرك XML/HTML |
| **duckduckgo-search** | 18 KB | ~500 KB | - | صغيرة جداً - بحث DuckDuckGo |
| **html5lib** | 112 KB | ~2-3 MB | webencodings (11 KB) | صغيرة - محرك HTML5 |
| **deep-translator** | 42 KB | ~1-2 MB | requests, tqdm (78 KB) | صغيرة - ترجمة متقدمة |
| **googletrans** | 18 KB | ~500 KB | - | صغيرة جداً - Google Translate |
| **nltk** | 1.5 MB | **~500 MB - 1 GB** | joblib (309 KB), regex (277 KB) | كبيرة جداً (مع البيانات) |
| **textblob** | 624 KB | ~5-10 MB | primp (3.1 MB), nltk | متوسطة - تحليل النصوص |
| **pyarabic** | 126 KB | ~1-2 MB | - | صغيرة - معالجة العربية |

---

## 📈 الحجم الإجمالي الفعلي

### حجم التحميل (Download Size):

**بدون lxml و NLTK:**
- **الحجم الإجمالي للتحميل**: ~1.2 MB
- **مع التبعيات**: ~6-7 MB
- **المكتبات**: beautifulsoup4, duckduckgo-search, deep-translator, googletrans, html5lib, pyarabic, textblob

**مع lxml (بدون NLTK):**
- **الحجم الإجمالي للتحميل**: ~7-17 MB
- **مع التبعيات**: ~12-22 MB

**مع NLTK (كامل):**
- **حجم التحميل**: ~8-18 MB
- **بعد التثبيت**: **~500 MB - 1 GB** (مع جميع بيانات NLTK)

**مع NLTK (الحد الأدنى - البيانات الأساسية فقط):**
- **حجم التحميل**: ~8-18 MB
- **بعد التثبيت**: ~50-100 MB (مع البيانات الأساسية فقط)

### الحجم بعد التثبيت:

**بدون NLTK:**
- **الحجم التقريبي**: ~15-25 MB
- **مع lxml**: ~30-50 MB

**مع NLTK (الحد الأدنى):**
- **الحجم التقريبي**: ~50-100 MB

**مع NLTK (كامل):**
- **الحجم التقريبي**: **~500 MB - 1 GB**

---

## ⚠️ ملاحظات مهمة

### 1. **NLTK - المكتبة الأكبر**

NLTK هي أكبر مكتبة في القائمة:
- **الحجم الأساسي**: ~5 MB
- **مع جميع البيانات**: ~500 MB - 1 GB
- **مع البيانات الأساسية فقط**: ~50-100 MB

**البيانات المطلوبة للوكلاء:**
```python
nltk.download('punkt')          # ~1 MB
nltk.download('stopwords')      # ~1 MB
nltk.download('vader_lexicon')  # ~10 MB
```

**البيانات الاختيارية:**
```python
nltk.download('averaged_perceptron_tagger')  # ~50 MB
nltk.download('wordnet')                     # ~50 MB
nltk.download('all')                         # ~500 MB - 1 GB
```

### 2. **lxml - المكتبة الثانية**

lxml تحتاج مساحة معقولة:
- **الحجم الأساسي**: ~5-10 MB
- **بعد التثبيت**: ~15-20 MB
- **البديل**: يمكن استخدام `html.parser` المدمج في Python (أبطأ لكن أصغر)

---

## 💡 توصيات لتقليل الحجم

### الخيار 1: تثبيت أساسي (الأصغر) - ~1-2 MB تحميل
```bash
# فقط المكتبات الأساسية
pip install beautifulsoup4 duckduckgo-search deep-translator pyarabic
# حجم التحميل: ~300 KB
# بعد التثبيت: ~5-10 MB
```

### الخيار 2: تثبيت متوسط (موصى به) - ~7-17 MB تحميل
```bash
# بدون NLTK (استخدام textblob فقط)
pip install beautifulsoup4 lxml duckduckgo-search deep-translator textblob pyarabic html5lib
# حجم التحميل: ~7-17 MB (مع lxml)
# بعد التثبيت: ~30-50 MB
```

### الخيار 3: تثبيت كامل (الأفضل) - ~8-18 MB تحميل
```bash
# جميع المكتبات
pip install -r requirements.txt
# حجم التحميل: ~8-18 MB
# بعد التثبيت: ~500 MB - 1 GB (مع NLTK كامل)
# أو ~50-100 MB (مع NLTK الأساسي فقط)
```

---

## 🔍 فحص الحجم الفعلي

### فحص حجم المكتبات المثبتة:

```python
import os
import site

def get_package_size(package_name):
    """احسب حجم مكتبة مثبتة"""
    try:
        import importlib
        spec = importlib.util.find_spec(package_name)
        if spec and spec.origin:
            path = os.path.dirname(spec.origin)
            total_size = 0
            for dirpath, dirnames, filenames in os.walk(path):
                for filename in filenames:
                    filepath = os.path.join(dirpath, filename)
                    total_size += os.path.getsize(filepath)
            return total_size / (1024 * 1024)  # بالميجابايت
    except:
        return 0

# فحص المكتبات
packages = ['bs4', 'lxml', 'deep_translator', 'nltk', 'textblob', 'pyarabic']
for pkg in packages:
    size = get_package_size(pkg)
    print(f"{pkg}: {size:.2f} MB")
```

### فحص حجم NLTK البيانات:

```python
import nltk
import os

nltk_data_path = nltk.data.path[0] if nltk.data.path else None
if nltk_data_path:
    total_size = 0
    for root, dirs, files in os.walk(nltk_data_path):
        for file in files:
            filepath = os.path.join(root, file)
            total_size += os.path.getsize(filepath)
    print(f"NLTK Data: {total_size / (1024 * 1024):.2f} MB")
```

---

## 📊 مقارنة الأحجام

### أصغر تثبيت ممكن:
- **duckduckgo-search** + **pyarabic**: ~144 KB تحميل، ~2 MB بعد التثبيت
- **الوظيفة**: بحث أساسي + معالجة عربية

### تثبيت موصى به:
- **beautifulsoup4** + **lxml** + **deep-translator** + **textblob** + **pyarabic**: ~7-17 MB تحميل، ~30-50 MB بعد التثبيت
- **الوظيفة**: جميع الميزات بدون NLTK الكامل

### تثبيت كامل:
- **جميع المكتبات** + **NLTK كامل**: ~8-18 MB تحميل، ~500 MB - 1 GB بعد التثبيت
- **الوظيفة**: جميع الميزات مع تحليل متقدم

---

## 🎯 التوصية

**للاستخدام العادي:**
- استخدم التثبيت المتوسط (~30-50 MB)
- NLTK مع البيانات الأساسية فقط

**للاستخدام المتقدم:**
- استخدم التثبيت الكامل (~500 MB - 1 GB)
- NLTK مع جميع البيانات

---

**آخر تحديث**: 2025-01-XX

