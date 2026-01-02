# نظام التنقل واللغة المركزي
# Central Navigation & Language System

## 📋 نظرة عامة

نظام مركزي لإدارة التنقل واللغات في لوحة التحكم متعددة الصفحات. يسهل إضافة صفحات جديدة والتكامل مع أي نظام.

Central system for managing navigation and languages in multi-page dashboard. Makes it easy to add new pages and integrate with any system.

## 📁 الملفات

### 1. `navigation.js` - نظام التنقل
- إدارة الصفحات والتنقل بينها
- إضافة/إزالة صفحات ديناميكياً
- تحديث تلقائي للغة

### 2. `navigation.css` - أنماط التنقل
- تصميم موحد للتنقل
- دعم RTL/LTR
- متجاوب مع جميع الأجهزة

### 3. `language.js` - نظام اللغة
- إدارة اللغات (عربي/إنجليزي)
- حفظ التفضيلات
- تحديث تلقائي للعناصر

### 4. `styles.css` - الأنماط المشتركة
- أنماط مشتركة لجميع الصفحات
- زر تبديل اللغة
- مؤشر الحالة المباشرة

## 🚀 الاستخدام

### إضافة الصفحات

في أي صفحة HTML، أضف:

```html
<!-- في <head> -->
<link rel="stylesheet" href="common/styles.css">
<link rel="stylesheet" href="common/navigation.css">

<!-- قبل </body> -->
<script src="common/language.js"></script>
<script src="common/navigation.js"></script>

<!-- Navigation Container -->
<div id="nav-menu-container"></div>

<!-- Language Toggle -->
<button class="lang-toggle" id="lang-toggle-btn">
    <span>English</span>
</button>
```

### إضافة صفحة جديدة برمجياً

```javascript
// في أي صفحة
NavigationSystem.addPage({
    id: 'new-page',
    url: 'new-page.html',
    icon: '📄',
    ar: 'صفحة جديدة',
    en: 'New Page',
    order: 4
});
```

### الانتقال لصفحة برمجياً

```javascript
NavigationSystem.navigate('servers');
```

## 🔧 التكامل

### مع APIs

```javascript
// في أي صفحة
window.onBeforeNavigate = function(pageId, url) {
    // يمكنك منع الانتقال أو تنفيذ إجراءات قبل الانتقال
    if (hasUnsavedChanges()) {
        return confirm('هل تريد الحفظ قبل الانتقال؟');
    }
    return true;
};
```

### مع أنظمة أخرى

النظام يعمل بشكل مستقل ويمكن دمجه مع:
- React/Vue/Angular
- أي framework
- أنظمة إدارة المحتوى

## 📝 إضافة صفحة جديدة يدوياً

1. أنشئ ملف HTML جديد (مثلاً `new-page.html`)
2. أضف الملفات المشتركة في `<head>`
3. أضف container للتنقل: `<div id="nav-menu-container"></div>`
4. أضف زر اللغة: `<button class="lang-toggle" id="lang-toggle-btn">`
5. في `common/navigation.js`، أضف الصفحة في `NAVIGATION_CONFIG.pages`

أو استخدم `NavigationSystem.addPage()` برمجياً.

## 🎨 التخصيص

### تغيير موضع التنقل

```javascript
NAVIGATION_CONFIG.position = 'top'; // أو 'bottom'
```

### تغيير الأنماط

عدّل `common/navigation.css` أو أضف أنماط مخصصة.

## ✅ المميزات

- ✅ مركزي: ملفات مشتركة واحدة
- ✅ قابل للتوسع: إضافة صفحات بسهولة
- ✅ متكامل: يعمل مع أي نظام
- ✅ متجاوب: يعمل على جميع الأجهزة
- ✅ سهل الاستخدام: API بسيط

