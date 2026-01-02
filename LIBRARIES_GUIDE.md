# 📚 دليل المكتبات - Libraries Guide

## المكتبات المضافة للوكلاء المطورة

تم إضافة المكتبات التالية لدعم الوكلاء المطورة:

---

## 🔍 وكيل البحث على الويب (Web Retrieval Agent)

### المكتبات المطلوبة:

1. **beautifulsoup4** (>=4.12.0)
   - **الاستخدام**: تحليل HTML واستخراج المحتوى من صفحات الويب
   - **التثبيت**: `pip install beautifulsoup4`
   - **الوظيفة**: استخراج النصوص والروابط من صفحات HTML

2. **lxml** (>=4.9.0)
   - **الاستخدام**: محرك XML/HTML سريع لـ BeautifulSoup
   - **التثبيت**: `pip install lxml`
   - **الوظيفة**: تحليل سريع وفعال لصفحات HTML

3. **duckduckgo-search** (>=4.0.0)
   - **الاستخدام**: البحث الفعلي على DuckDuckGo بدون API key
   - **التثبيت**: `pip install duckduckgo-search`
   - **الوظيفة**: تنفيذ عمليات بحث حقيقية على DuckDuckGo

4. **html5lib** (>=1.1)
   - **الاستخدام**: محرك HTML5 parser بديل
   - **التثبيت**: `pip install html5lib`
   - **الوظيفة**: تحليل HTML5 بدقة عالية

---

## 🌐 وكيل الترجمة (Translation Agent)

### المكتبات المطلوبة:

1. **deep-translator** (>=1.11.0)
   - **الاستخدام**: ترجمة متقدمة مع دعم 100+ لغة
   - **التثبيت**: `pip install deep-translator`
   - **الوظيفة**: ترجمة عالية الجودة مع دعم متعدد المصادر
   - **الميزات**:
     - دعم Google Translate, Microsoft Translator, DeepL
     - ترجمة نصوص طويلة
     - دعم الترجمة بالسياق

2. **googletrans** (>=4.0.0rc1)
   - **الاستخدام**: واجهة لـ Google Translate API
   - **التثبيت**: `pip install googletrans==4.0.0rc1`
   - **الوظيفة**: ترجمة سريعة باستخدام Google Translate
   - **ملاحظة**: قد يتطلب تحديثات دورية

---

## 🔍 وكيل التحليل (Analysis Agent)

### المكتبات المطلوبة:

1. **nltk** (>=3.8.0)
   - **الاستخدام**: معالجة اللغة الطبيعية
   - **التثبيت**: `pip install nltk`
   - **الوظيفة**: تحليل النصوص، استخراج الكلمات المفتاحية، تحليل المشاعر
   - **الاستخدام الأولي**: يحتاج تحميل البيانات:
     ```python
     import nltk
     nltk.download('punkt')
     nltk.download('stopwords')
     nltk.download('vader_lexicon')
     ```

2. **textblob** (>=0.17.1)
   - **الاستخدام**: معالجة نصوص بسيطة وسهلة
   - **التثبيت**: `pip install textblob`
   - **الوظيفة**: تحليل المشاعر، تصنيف النصوص، استخراج العبارات
   - **التبعيات**: يعتمد على nltk

---

## 📖 معالج اللغة العربية (Arabic Processor)

### المكتبات المطلوبة:

1. **pyarabic** (>=0.6.2)
   - **الاستخدام**: معالجة متقدمة للغة العربية
   - **التثبيت**: `pip install pyarabic`
   - **الوظيفة**: 
     - استخراج الجذور
     - تحليل الصرف
     - تصريف الكلمات
     - معالجة التشكيل

---

## 📦 التثبيت الكامل

### تثبيت جميع المكتبات:

```bash
# تثبيت المكتبات الأساسية
pip install beautifulsoup4 lxml duckduckgo-search html5lib

# تثبيت مكتبات الترجمة
pip install deep-translator googletrans==4.0.0rc1

# تثبيت مكتبات التحليل
pip install nltk textblob

# تثبيت مكتبات العربية
pip install pyarabic

# أو تثبيت جميع المكتبات من requirements.txt
pip install -r requirements.txt
```

### إعداد NLTK (بعد التثبيت):

```python
import nltk

# تحميل البيانات المطلوبة
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('vader_lexicon')
nltk.download('averaged_perceptron_tagger')
nltk.download('wordnet')
```

---

## 🔧 الاستخدام في الكود

### مثال: استخدام BeautifulSoup في Web Retrieval Agent

```python
from bs4 import BeautifulSoup
import httpx

async def extract_content(url):
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        soup = BeautifulSoup(response.text, 'lxml')
        # استخراج النص الرئيسي
        text = soup.get_text()
        return text
```

### مثال: استخدام deep-translator في Translation Agent

```python
from deep_translator import GoogleTranslator

translator = GoogleTranslator(source='ar', target='en')
translated = translator.translate('مرحباً بك')
```

### مثال: استخدام pyarabic في Arabic Processor

```python
from pyarabic import araby

# استخراج الجذور
root = araby.stem(word)
# تحليل الصرف
morphology = araby.tokenize(text)
```

---

## ⚠️ ملاحظات مهمة

### 1. **googletrans**
- قد يتطلب تحديثات دورية
- قد يكون غير مستقر في بعض الأحيان
- بديل أفضل: `deep-translator` مع Google Translator

### 2. **duckduckgo-search**
- لا يتطلب API key
- قد يتغير مع تحديثات DuckDuckGo
- بديل: استخدام DuckDuckGo API مباشرة

### 3. **nltk**
- يحتاج تحميل البيانات عند أول استخدام
- حجم البيانات كبير نسبياً
- يمكن استخدام بدائل أخف مثل `textblob`

---

## 🔄 الترقية

لترقية جميع المكتبات:

```bash
pip install --upgrade beautifulsoup4 lxml duckduckgo-search html5lib
pip install --upgrade deep-translator googletrans
pip install --upgrade nltk textblob
pip install --upgrade pyarabic
```

---

## 📝 ملاحظات التطوير

- جميع المكتبات متوافقة مع Python 3.8+
- المكتبات اختيارية - الوكلاء تعمل بدونها لكن بمواصفات محدودة
- يمكن تفعيل الميزات المتقدمة عند تثبيت المكتبات

---

**آخر تحديث**: 2025-01-XX  
**الإصدار**: 2.0.0

