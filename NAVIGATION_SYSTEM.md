# نظام التنقل المركزي - Multi-Page Navigation System
# Central Navigation System Documentation

## 📋 نظرة عامة | Overview

نظام تنقل مركزي وقابل للتوسع لإدارة الصفحات المتعددة في لوحة التحكم. كل صفحة منفصلة تماماً ويمكن التكامل مع أي نظام بسهولة.

Central, scalable navigation system for managing multiple pages in the dashboard. Each page is completely independent and can be easily integrated with any system.

## 🏗️ البنية المعمارية | Architecture

```
AI-Agent-Platform/
├── index.html              # الصفحة الرئيسية (Dashboard الأصلية)
├── servers.html            # إدارة السيرفرات والمنصات
├── monitoring.html         # المراقبة والسجلات
└── common/                 # الملفات المشتركة
    ├── navigation.js       # نظام التنقل المركزي
    ├── navigation.css      # أنماط التنقل
    ├── language.js        # نظام اللغة المركزي
    ├── styles.css         # الأنماط المشتركة
    └── README.md          # دليل الاستخدام
```

## 🔄 آلية التنقل | Navigation Mechanism

### 1. **نظام الصفحات المتعددة | Multi-Page System**

كل صفحة هي ملف HTML منفصل تماماً:
- ✅ **index.html** - Dashboard الرئيسية (الأصلية)
- ✅ **servers.html** - إدارة السيرفرات
- ✅ **monitoring.html** - المراقبة

**المميزات:**
- كل صفحة مستقلة تماماً
- لا توجد اعتماديات بين الصفحات
- يمكن إضافة صفحات جديدة بسهولة
- سهولة الصيانة والتطوير

### 2. **النظام المركزي | Central System**

#### ملفات مشتركة:

**`common/navigation.js`**
- إدارة قائمة الصفحات
- توليد قائمة التنقل تلقائياً
- تحديد الصفحة النشطة
- تحديث اللغة تلقائياً

**`common/language.js`**
- إدارة اللغات (عربي/إنجليزي)
- حفظ التفضيلات في localStorage
- تحديث جميع العناصر تلقائياً
- كشف اللغة تلقائياً من المتصفح

**`common/navigation.css`**
- تصميم موحد للتنقل
- دعم RTL/LTR تلقائي
- متجاوب مع جميع الأجهزة

**`common/styles.css`**
- أنماط مشتركة (زر اللغة، مؤشر الحالة)
- تصميم موحد

### 3. **كيفية العمل | How It Works**

```
┌─────────────────────────────────────────┐
│  User Opens Page (index.html)          │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Load Common Files                     │
│  - language.js                         │
│  - navigation.js                       │
│  - navigation.css                      │
│  - styles.css                          │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  language.js Initializes                │
│  - Detect/load saved language           │
│  - Apply language to page               │
│  - Setup language toggle button         │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  navigation.js Initializes              │
│  - Read NAVIGATION_CONFIG.pages         │
│  - Detect current page                   │
│  - Generate navigation HTML              │
│  - Insert into #nav-menu-container      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  User Clicks Navigation Link            │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  handleNavigation() Called               │
│  - Check onBeforeNavigate hook           │
│  - Navigate to new page                  │
│  - New page loads with same system      │
└─────────────────────────────────────────┘
```

## 🔧 التكامل | Integration

### إضافة صفحة جديدة | Adding New Page

#### الطريقة 1: يدوياً في navigation.js

```javascript
// في common/navigation.js
NAVIGATION_CONFIG.pages.push({
    id: 'new-page',
    url: 'new-page.html',
    icon: '📄',
    ar: 'صفحة جديدة',
    en: 'New Page',
    order: 4
});
```

#### الطريقة 2: برمجياً من أي صفحة

```javascript
// في أي صفحة HTML
NavigationSystem.addPage({
    id: 'analytics',
    url: 'analytics.html',
    icon: '📈',
    ar: 'التحليلات',
    en: 'Analytics',
    order: 5
});
```

### إنشاء صفحة جديدة | Creating New Page

```html
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-ar="صفحة جديدة" data-en="New Page">صفحة جديدة</title>
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.css">
    
    <!-- Common Styles -->
    <link rel="stylesheet" href="common/styles.css">
    <link rel="stylesheet" href="common/navigation.css">
    
    <style>
        /* Your custom styles here */
    </style>
</head>
<body>
    <!-- Language Toggle -->
    <button class="lang-toggle" id="lang-toggle-btn">
        <span>English</span>
    </button>
    
    <div class="dashboard-container">
        <!-- Your page content here -->
        <div class="header-card">
            <h1 data-ar="صفحة جديدة" data-en="New Page">صفحة جديدة</h1>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Common Scripts -->
    <script src="common/language.js"></script>
    <script src="common/navigation.js"></script>
    
    <script>
        // Your page-specific JavaScript here
        // Use getCurrentLanguage() to get current language
    </script>
    
    <!-- Navigation Container -->
    <div id="nav-menu-container"></div>
</body>
</html>
```

### التكامل مع APIs | API Integration

```javascript
// في أي صفحة
window.onBeforeNavigate = function(pageId, url) {
    // يمكنك منع الانتقال أو تنفيذ إجراءات
    if (hasUnsavedChanges()) {
        return confirm('هل تريد الحفظ قبل الانتقال؟');
    }
    return true; // Allow navigation
};

// بعد الانتقال
window.addEventListener('languageChanged', function(event) {
    const lang = event.detail.language;
    // Update your page content based on language
});
```

### التكامل مع React/Vue/Angular

```javascript
// React Example
import { useEffect } from 'react';

function MyComponent() {
    useEffect(() => {
        // Load navigation system
        const script1 = document.createElement('script');
        script1.src = 'common/language.js';
        document.body.appendChild(script1);
        
        const script2 = document.createElement('script');
        script2.src = 'common/navigation.js';
        document.body.appendChild(script2);
        
        return () => {
            // Cleanup
        };
    }, []);
    
    return <div id="nav-menu-container"></div>;
}
```

## 📊 API Reference

### NavigationSystem API

```javascript
// إضافة صفحة
NavigationSystem.addPage({
    id: 'page-id',
    url: 'page.html',
    icon: '📄',
    ar: 'العربية',
    en: 'English',
    order: 1
});

// إزالة صفحة
NavigationSystem.removePage('page-id');

// الحصول على جميع الصفحات
const pages = NavigationSystem.getPages();

// الانتقال لصفحة
NavigationSystem.navigate('page-id');

// تحديث اللغة في التنقل
NavigationSystem.updateLanguage();

// إعادة تهيئة التنقل
NavigationSystem.init();
```

### LanguageSystem API

```javascript
// تبديل اللغة
LanguageSystem.toggle();

// تعيين لغة محددة
LanguageSystem.set('ar'); // or 'en'

// الحصول على اللغة الحالية
const lang = LanguageSystem.get();

// الحصول على الترجمة
const text = LanguageSystem.getTranslation('key', 'ar');
```

### Global Helpers

```javascript
// الحصول على اللغة الحالية (في أي مكان)
const lang = getCurrentLanguage();

// الاستماع لتغيير اللغة
window.addEventListener('languageChanged', function(event) {
    const lang = event.detail.language;
    // Update your content
});
```

## 🎯 المميزات الرئيسية | Key Features

### ✅ سهولة التكامل | Easy Integration

- ملفات مشتركة واحدة
- لا حاجة لتعديل كل صفحة
- API بسيط وواضح
- يعمل مع أي framework

### ✅ قابلية التوسع | Scalability

- إضافة صفحات جديدة بسهولة
- إزالة صفحات بسهولة
- ترتيب الصفحات قابل للتخصيص
- لا حدود لعدد الصفحات

### ✅ كل صفحة منفصلة | Independent Pages

- كل صفحة HTML منفصلة
- لا اعتماديات بين الصفحات
- يمكن تطوير كل صفحة بشكل مستقل
- سهولة الصيانة

### ✅ دعم اللغات | Language Support

- نظام مركزي للغات
- حفظ التفضيلات
- تحديث تلقائي
- كشف تلقائي من المتصفح

### ✅ تصميم موحد | Unified Design

- أنماط مشتركة
- تصميم متجاوب
- دعم RTL/LTR
- تجربة مستخدم موحدة

## 🔍 مثال كامل | Complete Example

### إضافة صفحة Analytics جديدة

**1. إنشاء الملف `analytics.html`:**

```html
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-ar="التحليلات" data-en="Analytics">التحليلات</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="common/styles.css">
    <link rel="stylesheet" href="common/navigation.css">
</head>
<body>
    <button class="lang-toggle" id="lang-toggle-btn">
        <span>English</span>
    </button>
    
    <div class="dashboard-container">
        <div class="header-card">
            <h1 data-ar="التحليلات" data-en="Analytics">التحليلات</h1>
        </div>
        <!-- Your content -->
    </div>
    
    <script src="common/language.js"></script>
    <script src="common/navigation.js"></script>
    
    <script>
        // Add page to navigation
        NavigationSystem.addPage({
            id: 'analytics',
            url: 'analytics.html',
            icon: '📈',
            ar: 'التحليلات',
            en: 'Analytics',
            order: 4
        });
    </script>
    
    <div id="nav-menu-container"></div>
</body>
</html>
```

**2. أو أضفها في `common/navigation.js`:**

```javascript
NAVIGATION_CONFIG.pages.push({
    id: 'analytics',
    url: 'analytics.html',
    icon: '📈',
    ar: 'التحليلات',
    en: 'Analytics',
    order: 4
});
```

## 🚀 الاستخدام السريع | Quick Start

### في أي صفحة HTML جديدة:

```html
<!-- 1. أضف الملفات المشتركة في <head> -->
<link rel="stylesheet" href="common/styles.css">
<link rel="stylesheet" href="common/navigation.css">

<!-- 2. أضف الأزرار في <body> -->
<button class="lang-toggle" id="lang-toggle-btn">
    <span>English</span>
</button>

<!-- 3. أضف scripts قبل </body> -->
<script src="common/language.js"></script>
<script src="common/navigation.js"></script>

<!-- 4. أضف container للتنقل -->
<div id="nav-menu-container"></div>
```

## 📝 ملاحظات مهمة | Important Notes

1. **كل صفحة منفصلة**: لا توجد اعتماديات بين الصفحات
2. **النظام المركزي**: جميع الملفات المشتركة في `common/`
3. **سهولة التكامل**: يمكن استخدامه مع أي نظام
4. **قابل للتوسع**: إضافة صفحات جديدة بسهولة
5. **دعم اللغات**: نظام مركزي للغات

## 🔗 الروابط | Links

- **الصفحة الرئيسية**: `index.html`
- **إدارة السيرفرات**: `servers.html`
- **المراقبة**: `monitoring.html`
- **الملفات المشتركة**: `common/`

---

**صُنع بـ ❤️ للمجتمع العربي**

