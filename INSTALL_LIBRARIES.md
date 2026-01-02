# 🚀 دليل التثبيت السريع - Quick Installation Guide

## تثبيت المكتبات المطلوبة للوكلاء المطورة

### الطريقة السريعة (جميع المكتبات):

```bash
pip install -r requirements.txt
```

---

## تثبيت حسب الوكيل

### 1. وكيل البحث على الويب

```bash
pip install beautifulsoup4 lxml duckduckgo-search html5lib
```

### 2. وكيل الترجمة

```bash
pip install deep-translator googletrans==4.0.0rc1
```

### 3. وكيل التحليل

```bash
pip install nltk textblob
# بعد التثبيت، قم بتشغيل:
python -c "import nltk; nltk.download('punkt'); nltk.download('stopwords'); nltk.download('vader_lexicon')"
```

### 4. معالج اللغة العربية

```bash
pip install pyarabic
```

---

## التحقق من التثبيت

```python
# تحقق من المكتبات
try:
    import bs4
    print("✅ beautifulsoup4 مثبت")
except ImportError:
    print("❌ beautifulsoup4 غير مثبت")

try:
    import lxml
    print("✅ lxml مثبت")
except ImportError:
    print("❌ lxml غير مثبت")

try:
    from deep_translator import GoogleTranslator
    print("✅ deep-translator مثبت")
except ImportError:
    print("❌ deep-translator غير مثبت")

try:
    import nltk
    print("✅ nltk مثبت")
except ImportError:
    print("❌ nltk غير مثبت")

try:
    from textblob import TextBlob
    print("✅ textblob مثبت")
except ImportError:
    print("❌ textblob غير مثبت")

try:
    import pyarabic
    print("✅ pyarabic مثبت")
except ImportError:
    print("❌ pyarabic غير مثبت")
```

---

## ملاحظات

- جميع المكتبات اختيارية - الوكلاء تعمل بدونها لكن بمواصفات محدودة
- للتثبيت في بيئة افتراضية:
  ```bash
  python -m venv venv
  source venv/bin/activate  # Linux/Mac
  # أو
  venv\Scripts\activate  # Windows
  pip install -r requirements.txt
  ```

---

**جاهز للاستخدام!** 🎉

