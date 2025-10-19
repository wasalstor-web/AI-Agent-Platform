# دليل النشر والاستضافة على Hostinger

## 📋 المحتويات
- [نظرة عامة](#نظرة-عامة)
- [المتطلبات الأساسية](#المتطلبات-الأساسية)
- [الطريقة الأولى: الرفع عبر FTP](#الطريقة-الأولى-الرفع-عبر-ftp)
- [الطريقة الثانية: مدير الملفات](#الطريقة-الثانية-مدير-الملفات)
- [إعداد بيئة النشر](#إعداد-بيئة-النشر)
- [ربط النطاق (Domain)](#ربط-النطاق-domain)
- [إعداد index.html كصفحة رئيسية](#إعداد-indexhtml-كصفحة-رئيسية)
- [إعداد Git على السيرفر (اختياري)](#إعداد-git-على-السيرفر-اختياري)
- [استكشاف الأخطاء وإصلاحها](#استكشاف-الأخطاء-وإصلاحها)
- [أفضل ممارسات الأمان](#أفضل-ممارسات-الأمان)

---

## 🌟 نظرة عامة

هذا الدليل يوفر تعليمات مفصلة خطوة بخطوة لنشر مشروع AI Agent Platform على سيرفر Hostinger. يتضمن الدليل طرقًا متعددة للنشر ويغطي جميع الجوانب من الرفع الأساسي للملفات إلى الإعداد المتقدم باستخدام Git.

### ما الذي ستتعلمه:
- كيفية رفع ملفات المشروع إلى Hostinger
- إعداد بيئة الاستضافة بشكل صحيح
- ربط النطاق الخاص بك
- إعداد التحديثات التلقائية من GitHub (اختياري)

---

## ⚙️ المتطلبات الأساسية

قبل البدء في عملية النشر، تأكد من توفر ما يلي:

### 1. حساب Hostinger
- ✅ حساب استضافة نشط على Hostinger
- ✅ خطة استضافة مناسبة (Shared Hosting، VPS، أو Cloud Hosting)
- ✅ الوصول إلى لوحة التحكم hPanel

### 2. معلومات الوصول
- ✅ اسم المستخدم وكلمة المرور لحساب Hostinger
- ✅ بيانات FTP (في حال استخدام FTP):
  - عنوان السيرفر (Server/Host)
  - المنفذ (Port) - عادةً 21 أو 22
  - اسم المستخدم وكلمة المرور

### 3. النطاق (Domain)
- ✅ نطاق مسجل (إما من Hostinger أو من مزود آخر)
- ✅ إذا كان النطاق من مزود آخر، تأكد من إمكانية تغيير DNS

### 4. ملفات المشروع
- ✅ نسخة من مستودع AI-Agent-Platform
- ✅ ملف index.html جاهز
- ✅ جميع الملفات الضرورية للمشروع

### 5. برامج إضافية (اختيارية)
- ✅ برنامج FTP Client مثل FileZilla أو WinSCP (للطريقة الأولى)
- ✅ Git (للتحديثات التلقائية)

---

## 📤 الطريقة الأولى: الرفع عبر FTP

FTP (File Transfer Protocol) هو بروتوكول نقل الملفات الأكثر شيوعًا لرفع ملفات المواقع.

### الخطوة 1: الحصول على بيانات FTP

1. **تسجيل الدخول إلى hPanel**
   - اذهب إلى [https://hpanel.hostinger.com](https://hpanel.hostinger.com)
   - أدخل بريدك الإلكتروني وكلمة المرور

2. **الوصول إلى إعدادات FTP**
   - من القائمة الجانبية، اختر **Files** (الملفات)
   - انقر على **FTP Accounts** (حسابات FTP)

3. **إنشاء حساب FTP (إذا لم يكن موجودًا)**
   - انقر على **Create FTP Account**
   - أدخل اسم المستخدم وكلمة مرور قوية
   - حدد المجلد الرئيسي (عادةً `/public_html`)
   - انقر على **Create**

4. **احفظ معلومات الاتصال**
   ```
   Server/Host: ftp.yourdomain.com أو IP الخاص بالسيرفر
   Username: اسم المستخدم الذي أنشأته
   Password: كلمة المرور
   Port: 21 (FTP) أو 22 (SFTP للأمان الأعلى)
   ```

### الخطوة 2: تثبيت وإعداد FileZilla

1. **تحميل FileZilla**
   - اذهب إلى [https://filezilla-project.org](https://filezilla-project.org)
   - حمّل النسخة المجانية من FileZilla Client
   - ثبّت البرنامج على جهازك

2. **إضافة موقعك في FileZilla**
   - افتح FileZilla
   - اذهب إلى **File** > **Site Manager** (مدير المواقع)
   - انقر على **New Site** (موقع جديد)
   - أدخل المعلومات التالية:
     ```
     Host: ftp.yourdomain.com
     Port: 21
     Protocol: FTP - File Transfer Protocol
     Encryption: Use explicit FTP over TLS if available
     Logon Type: Normal
     User: اسم المستخدم FTP
     Password: كلمة المرور
     ```
   - انقر على **Connect** (اتصال)

### الخطوة 3: رفع ملفات المشروع

1. **تجهيز الملفات للرفع**
   - افتح مجلد المشروع على جهازك
   - تأكد من وجود ملف `index.html` في المجلد الرئيسي
   - احذف أي ملفات غير ضرورية مثل `.git/`، `node_modules/`، `.env`

2. **الاتصال بالسيرفر**
   - في FileZilla، ستجد:
     - **الجانب الأيسر**: ملفات جهازك المحلي
     - **الجانب الأيمن**: ملفات السيرفر
   - في الجانب الأيمن، انتقل إلى مجلد `public_html`

3. **رفع الملفات**
   - من الجانب الأيسر، حدد جميع ملفات مشروعك
   - اسحبها إلى الجانب الأيمن (مجلد `public_html`)
   - أو انقر بالزر الأيمن واختر **Upload**
   - انتظر حتى يكتمل الرفع (يمكنك متابعة التقدم في الأسفل)

4. **التحقق من الرفع**
   - تأكد من وجود جميع الملفات في السيرفر
   - تحقق من أن `index.html` موجود في المجلد الرئيسي `public_html`

### الخطوة 4: اختبار الموقع

1. افتح متصفح الويب
2. اذهب إلى `http://yourdomain.com` أو `http://your-server-ip`
3. يجب أن تظهر صفحة `index.html` الخاصة بك

### نصائح للرفع عبر FTP:

✅ **استخدم SFTP للأمان**: استخدم المنفذ 22 وبروتوكول SFTP بدلاً من FTP العادي
✅ **ملفات .htaccess**: إذا كان لديك ملف `.htaccess`، تأكد من رفعه أيضًا
✅ **الصلاحيات**: تأكد من صلاحيات الملفات (عادةً 644 للملفات و755 للمجلدات)
✅ **النسخ الاحتياطية**: احتفظ بنسخة احتياطية من الملفات على جهازك

---

## 🗂️ الطريقة الثانية: مدير الملفات

مدير الملفات هو أداة مدمجة في hPanel تتيح لك رفع وإدارة الملفات مباشرة من المتصفح.

### الخطوة 1: الوصول إلى مدير الملفات

1. **تسجيل الدخول إلى hPanel**
   - اذهب إلى [https://hpanel.hostinger.com](https://hpanel.hostinger.com)
   - أدخل بياناتك

2. **فتح مدير الملفات**
   - من القائمة الجانبية، اختر **Files** (الملفات)
   - انقر على **File Manager** (مدير الملفات)
   - سيفتح مدير الملفات في نافذة جديدة

### الخطوة 2: التنقل إلى المجلد الصحيح

1. في مدير الملفات، ستجد قائمة بالمجلدات
2. افتح مجلد **public_html** (هذا هو المجلد الذي يحتوي على ملفات الموقع العامة)
3. إذا كان المجلد يحتوي على ملفات افتراضية (مثل `index.html` أو `default.html`)، يمكنك حذفها أو الاحتفاظ بنسخة احتياطية منها

### الخطوة 3: رفع الملفات

#### الطريقة أ: رفع ملفات فردية

1. انقر على زر **Upload** (رفع) في الشريط العلوي
2. اختر الملفات من جهازك:
   - `index.html`
   - أي ملفات HTML أخرى
   - ملفات CSS وJavaScript
   - الصور والملفات الأخرى
3. انقر على **Open** لبدء الرفع
4. انتظر حتى يكتمل الرفع (ستظهر نسبة التقدم)

#### الطريقة ب: رفع ملف مضغوط (موصى به للملفات الكثيرة)

1. **على جهازك المحلي:**
   - ضغط مجلد المشروع إلى ملف `.zip`
   - تأكد من أن الملفات في المستوى الأعلى من ملف ZIP (وليس داخل مجلد فرعي)

2. **في مدير الملفات:**
   - انقر على **Upload**
   - اختر ملف `.zip` من جهازك
   - انتظر حتى يكتمل الرفع

3. **فك الضغط:**
   - بعد اكتمال الرفع، انقر بالزر الأيمن على ملف `.zip`
   - اختر **Extract** (استخراج)
   - تأكد من أن المسار هو `/public_html`
   - انقر على **Extract**
   - بعد فك الضغط، يمكنك حذف ملف `.zip`

### الخطوة 4: تنظيم الملفات

1. تأكد من أن `index.html` موجود مباشرة في مجلد `public_html`
2. تنظيم الملفات الأخرى في مجلدات فرعية إذا لزم الأمر:
   ```
   public_html/
   ├── index.html
   ├── css/
   │   └── styles.css
   ├── js/
   │   └── scripts.js
   └── images/
       └── logo.png
   ```

### الخطوة 5: ضبط صلاحيات الملفات

1. انقر بالزر الأيمن على الملف أو المجلد
2. اختر **Permissions** (الصلاحيات)
3. الصلاحيات الموصى بها:
   - **الملفات**: 644 (rw-r--r--)
   - **المجلدات**: 755 (rwxr-xr-x)
   - **ملف .htaccess**: 644
4. انقر على **Change** (تغيير)

### الخطوة 6: اختبار الموقع

1. افتح متصفح الويب
2. اذهب إلى نطاقك `http://yourdomain.com`
3. تحقق من ظهور الموقع بشكل صحيح

### مزايا استخدام مدير الملفات:

✅ **لا حاجة لبرامج إضافية**: يعمل مباشرة من المتصفح
✅ **سهل الاستخدام**: واجهة بسيطة وبديهية
✅ **آمن**: اتصال مشفر HTTPS
✅ **رفع ملفات كبيرة**: يدعم ملفات حتى 256 ميجابايت
✅ **تحرير مباشر**: يمكنك تحرير الملفات مباشرة في المتصفح

---

## 🔧 إعداد بيئة النشر

بعد رفع الملفات، تحتاج إلى إعداد بيئة النشر بشكل صحيح.

### 1. فحص إصدار PHP (إذا كان المشروع يستخدم PHP)

1. في hPanel، اذهب إلى **Advanced** > **PHP Configuration**
2. اختر إصدار PHP المناسب (يُنصح بـ PHP 8.0 أو أحدث)
3. احفظ التغييرات

### 2. إعداد متغيرات البيئة (Environment Variables)

إذا كان مشروعك يحتاج إلى متغيرات بيئة:

1. **إنشاء ملف .env** (غير موصى به للإنتاج):
   ```
   # لا تضع هذا الملف في public_html
   # بدلاً من ذلك، استخدم إعدادات PHP أو ملف خارج public_html
   ```

2. **الطريقة الآمنة**:
   - أنشئ ملف `config.php` خارج `public_html`
   - أو استخدم إعدادات PHP Configuration في hPanel

### 3. إعداد قاعدة البيانات (إذا لزم الأمر)

1. **إنشاء قاعدة بيانات:**
   - في hPanel، اذهب إلى **Databases** > **MySQL Databases**
   - انقر على **Create New Database**
   - أدخل اسم قاعدة البيانات
   - انقر على **Create**

2. **إنشاء مستخدم قاعدة البيانات:**
   - في نفس الصفحة، قسم **MySQL Users**
   - انقر على **Create New User**
   - أدخل اسم المستخدم وكلمة مرور قوية
   - انقر على **Create**

3. **ربط المستخدم بقاعدة البيانات:**
   - في قسم **Add User to Database**
   - اختر المستخدم وقاعدة البيانات
   - حدد الصلاحيات (عادةً All Privileges)
   - انقر على **Add**

4. **حفظ معلومات الاتصال:**
   ```php
   Database Host: localhost
   Database Name: اسم قاعدة البيانات
   Database User: اسم المستخدم
   Database Password: كلمة المرور
   ```

### 4. تفعيل HTTPS (SSL)

1. **في hPanel، اذهب إلى Security > SSL**
2. تفعيل Let's Encrypt SSL (مجاني):
   - اختر النطاق
   - انقر على **Install SSL**
   - انتظر بضع دقائق حتى يتم التفعيل

3. **إجبار HTTPS:**
   - أنشئ أو عدّل ملف `.htaccess` في `public_html`
   - أضف الكود التالي:
   ```apache
   # Redirect HTTP to HTTPS
   RewriteEngine On
   RewriteCond %{HTTPS} off
   RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
   ```

### 5. ضبط ملف .htaccess

إنشاء أو تحديث ملف `.htaccess` لتحسين الأداء والأمان:

```apache
# تفعيل محرك إعادة الكتابة
RewriteEngine On

# إعادة توجيه HTTP إلى HTTPS
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# إعادة توجيه www إلى non-www (اختياري)
RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
RewriteRule ^(.*)$ https://%1/$1 [L,R=301]

# صفحة الخطأ المخصصة
ErrorDocument 404 /404.html
ErrorDocument 403 /403.html

# منع الوصول إلى ملفات معينة
<FilesMatch "\.(htaccess|htpasswd|ini|log|sh|inc|bak|env)$">
  Order Allow,Deny
  Deny from all
</FilesMatch>

# تفعيل الضغط
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
</IfModule>

# تفعيل التخزين المؤقت
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/jpg "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/gif "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType text/css "access plus 1 month"
  ExpiresByType application/javascript "access plus 1 month"
</IfModule>
```

### 6. اختبار البيئة

1. **اختبر الصفحة الرئيسية:** `https://yourdomain.com`
2. **اختبر صفحة 404:** `https://yourdomain.com/nonexistent`
3. **اختبر HTTPS:** تأكد من ظهور القفل الأخضر في المتصفح
4. **اختبر السرعة:** استخدم أدوات مثل [Google PageSpeed Insights](https://pagespeed.web.dev/)

---

## 🌐 ربط النطاق (Domain)

### السيناريو 1: النطاق مسجل في Hostinger

إذا كان نطاقك مسجلاً بالفعل في Hostinger، فهو مربوط تلقائيًا بالاستضافة.

1. **التحقق من الربط:**
   - اذهب إلى hPanel > **Domains**
   - تأكد من أن النطاق يشير إلى خطة الاستضافة الصحيحة

2. **إذا لم يكن مربوطًا:**
   - انقر على **Manage** بجانب النطاق
   - اختر **Point Domain** أو **Connect Domain**
   - اختر خطة الاستضافة
   - احفظ التغييرات

### السيناريو 2: النطاق مسجل في مزود آخر

إذا كان نطاقك مسجلاً في GoDaddy أو Namecheap أو أي مزود آخر:

#### الطريقة أ: تغيير Name Servers (موصى به)

1. **الحصول على Name Servers من Hostinger:**
   - في hPanel، اذهب إلى **Domains** > **DNS**
   - ستجد Name Servers مثل:
     ```
     ns1.dns-parking.com
     ns2.dns-parking.com
     ```

2. **تحديث Name Servers في مزود النطاق:**
   - سجّل الدخول إلى حساب مزود النطاق
   - اذهب إلى إعدادات DNS/Name Servers
   - استبدل Name Servers الحالية بـ Name Servers من Hostinger
   - احفظ التغييرات

3. **الانتظار للانتشار:**
   - قد يستغرق الانتشار من 4 إلى 48 ساعة
   - عادةً ما يكتمل في غضون بضع ساعات

#### الطريقة ب: تعديل A Record

1. **الحصول على IP من Hostinger:**
   - في hPanel، اذهب إلى **Hosting** > **Details**
   - انسخ عنوان IP الخاص بالسيرفر

2. **تحديث A Record في مزود النطاق:**
   - سجّل الدخول إلى حساب مزود النطاق
   - اذهب إلى إدارة DNS
   - أضف أو عدّل A Record:
     ```
     Type: A
     Host: @ (للنطاق الأساسي)
     Value: IP الخاص بسيرفر Hostinger
     TTL: 3600 أو Auto
     ```
   - أضف أيضًا record لـ www:
     ```
     Type: A
     Host: www
     Value: IP الخاص بسيرفر Hostinger
     TTL: 3600 أو Auto
     ```
   - احفظ التغييرات

3. **الانتظار للانتشار:**
   - عادةً ما يستغرق من 1 إلى 6 ساعات

### التحقق من الربط

1. **استخدام أدوات الفحص:**
   - [DNS Checker](https://dnschecker.org/)
   - [What's My DNS](https://www.whatsmydns.net/)
   
2. **استخدام Command Line:**
   ```bash
   # على Windows
   nslookup yourdomain.com
   
   # على Mac/Linux
   dig yourdomain.com
   ```

3. **اختبار في المتصفح:**
   - اذهب إلى `http://yourdomain.com`
   - تأكد من ظهور موقعك

### إضافة نطاقات فرعية (Subdomains)

1. **في hPanel، اذهب إلى Domains > Subdomains**
2. انقر على **Create Subdomain**
3. أدخل اسم النطاق الفرعي (مثل `blog` لـ `blog.yourdomain.com`)
4. اختر المجلد الذي سيشير إليه النطاق الفرعي
5. انقر على **Create**

---

## 📄 إعداد index.html كصفحة رئيسية

### ما هو index.html؟

`index.html` هو الملف الافتراضي الذي يظهر عند زيارة النطاق. عندما يدخل زائر إلى `http://yourdomain.com`، يبحث السيرفر تلقائيًا عن هذا الملف.

### الخطوات:

### 1. التأكد من موقع الملف

```
public_html/
└── index.html  ← يجب أن يكون هنا مباشرة
```

**❌ خطأ شائع:**
```
public_html/
└── my-project/
    └── index.html  ← هذا خطأ!
```

إذا كان الملف داخل مجلد فرعي، انقله إلى `public_html` مباشرة.

### 2. التحقق من اسم الملف

- يجب أن يكون الاسم بالضبط `index.html` (بأحرف صغيرة)
- **ليس:** `Index.html` أو `INDEX.HTML` أو `home.html`

### 3. إعداد ملف index.html للمشروع

ملف `index.html` الحالي في المشروع جاهز للاستخدام، ولكن إليك النصائح لتحسينه:

```html
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="منصة وكيل الذكاء الاصطناعي - بنية تحتية متقدمة">
    <meta name="keywords" content="AI, Agent, Platform, ذكاء اصطناعي, منصة">
    <title>منصة وكيل الذكاء الاصطناعي - AI Agent Platform</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="/favicon.png">
    
    <!-- أي ملفات CSS -->
    <!-- <link rel="stylesheet" href="css/styles.css"> -->
</head>
<body>
    <!-- محتوى الصفحة الحالي -->
    
    <!-- أي ملفات JavaScript -->
    <!-- <script src="js/scripts.js"></script> -->
</body>
</html>
```

### 4. إعداد ترتيب أولوية الملفات (DirectoryIndex)

إذا كنت تريد تخصيص ترتيب الملفات الافتراضية، أضف هذا إلى `.htaccess`:

```apache
# ترتيب أولوية الملفات الافتراضية
DirectoryIndex index.html index.php index.htm default.html
```

### 5. إنشاء صفحات خطأ مخصصة

أنشئ صفحات خطأ مخصصة لتحسين تجربة المستخدم:

**404.html** (صفحة غير موجودة):
```html
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - الصفحة غير موجودة</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        h1 { font-size: 100px; margin: 0; }
        p { font-size: 24px; }
        a { color: white; text-decoration: underline; }
    </style>
</head>
<body>
    <h1>404</h1>
    <p>عذراً، الصفحة التي تبحث عنها غير موجودة</p>
    <p><a href="/">العودة إلى الصفحة الرئيسية</a></p>
</body>
</html>
```

ثم أضف إلى `.htaccess`:
```apache
ErrorDocument 404 /404.html
```

### 6. اختبار الصفحة الرئيسية

1. افتح `http://yourdomain.com` في المتصفح
2. تأكد من:
   - ✅ ظهور المحتوى بشكل صحيح
   - ✅ عمل الأزرار والروابط
   - ✅ تحميل الصور والأنماط
   - ✅ عمل JavaScript
   - ✅ التبديل بين اللغات (عربي/إنجليزي)

### 7. تحسينات إضافية

#### إضافة Google Analytics (اختياري)
```html
<!-- قبل إغلاق </head> -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

#### إضافة Open Graph للمشاركة على وسائل التواصل
```html
<meta property="og:title" content="منصة وكيل الذكاء الاصطناعي">
<meta property="og:description" content="بنية تحتية متقدمة لبناء وإدارة وكلاء الذكاء الاصطناعي">
<meta property="og:image" content="https://yourdomain.com/images/preview.jpg">
<meta property="og:url" content="https://yourdomain.com">
```

---

## 🔄 إعداد Git على السيرفر (اختياري)

هذا القسم للمستخدمين المتقدمين الذين يريدون سحب التحديثات تلقائيًا من GitHub.

### المتطلبات

- ✅ وصول SSH إلى السيرفر (متاح في خطط VPS وبعض خطط Shared Hosting)
- ✅ Git مثبت على السيرفر (عادةً متوفر افتراضيًا)
- ✅ مستودع GitHub للمشروع

### الخطوة 1: تفعيل SSH

1. **في hPanel، اذهب إلى Advanced > SSH Access**
2. انقر على **Enable SSH**
3. احفظ معلومات الاتصال:
   ```
   Host: yourdomain.com أو IP
   Port: 22 (أو المنفذ المخصص)
   Username: اسم المستخدم
   Password: كلمة المرور (أو استخدم SSH Key)
   ```

### الخطوة 2: الاتصال بالسيرفر عبر SSH

#### على Windows (استخدام PuTTY):
1. حمّل وثبّت [PuTTY](https://www.putty.org/)
2. افتح PuTTY
3. أدخل Host Name (IP أو النطاق)
4. Port: 22
5. انقر على **Open**
6. أدخل اسم المستخدم وكلمة المرور

#### على Mac/Linux (استخدام Terminal):
```bash
ssh username@yourdomain.com
# أدخل كلمة المرور عند الطلب
```

### الخطوة 3: التحقق من Git

```bash
# التحقق من تثبيت Git
git --version

# إذا لم يكن مثبتًا، اتصل بدعم Hostinger
```

### الخطوة 4: إعداد SSH Key لـ GitHub

1. **إنشاء SSH Key على السيرفر:**
```bash
# إنشاء SSH Key
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# اضغط Enter لقبول المسار الافتراضي
# أدخل passphrase (اختياري)

# عرض المفتاح العام
cat ~/.ssh/id_rsa.pub
```

2. **إضافة المفتاح إلى GitHub:**
   - انسخ محتوى المفتاح العام
   - اذهب إلى GitHub > Settings > SSH and GPG keys
   - انقر على **New SSH key**
   - الصق المفتاح وانقر على **Add SSH key**

### الخطوة 5: استنساخ المستودع

```bash
# الانتقال إلى مجلد الموقع
cd ~/public_html

# نسخ احتياطية للملفات الحالية (اختياري)
mkdir ~/backup
cp -r * ~/backup/

# حذف الملفات القديمة (احذر!)
rm -rf *

# استنساخ المستودع من GitHub
git clone git@github.com:wasalstor-web/AI-Agent-Platform.git .

# ملاحظة: النقطة في النهاية مهمة لاستنساخ الملفات مباشرة في المجلد الحالي
```

### الخطوة 6: إعداد التحديث التلقائي

#### الطريقة أ: سكريبت تحديث بسيط

1. **إنشاء سكريبت تحديث:**
```bash
# إنشاء ملف السكريبت
nano ~/update-site.sh
```

2. **محتوى السكريبت:**
```bash
#!/bin/bash

# الانتقال إلى مجلد الموقع
cd ~/public_html

# سحب آخر التحديثات
git pull origin main

# إذا كانت هناك تبعيات (مثل npm)
# npm install

echo "✅ تم تحديث الموقع بنجاح!"
```

3. **جعل السكريبت قابلاً للتنفيذ:**
```bash
chmod +x ~/update-site.sh
```

4. **تشغيل السكريبت:**
```bash
~/update-site.sh
```

#### الطريقة ب: Webhook التلقائي (متقدم)

1. **إنشاء سكريبت webhook:**
```php
<?php
// webhook.php - ضعه خارج public_html
$secret = 'YOUR_SECRET_KEY'; // غيّر هذا إلى مفتاح سري قوي

$headers = getallheaders();
$hubSignature = $headers['X-Hub-Signature'] ?? '';

$payload = file_get_contents('php://input');
$signature = 'sha1=' . hash_hmac('sha1', $payload, $secret);

if (hash_equals($signature, $hubSignature)) {
    $output = shell_exec('cd ~/public_html && git pull origin main 2>&1');
    echo $output;
    
    // سجل العملية
    file_put_contents('webhook.log', date('Y-m-d H:i:s') . " - Update: " . $output . "\n", FILE_APPEND);
} else {
    http_response_code(403);
    echo 'Invalid signature';
}
?>
```

2. **إعداد Webhook في GitHub:**
   - اذهب إلى مستودعك على GitHub
   - Settings > Webhooks > Add webhook
   - Payload URL: `https://yourdomain.com/webhook.php`
   - Content type: `application/json`
   - Secret: نفس المفتاح في السكريبت
   - Which events: `Just the push event`
   - انقر على **Add webhook**

3. **اختبار Webhook:**
   - قم بعمل push إلى المستودع
   - تحقق من تحديث الموقع تلقائيًا

### الخطوة 7: إعداد Cron Job للتحديث المجدول (اختياري)

إذا كنت تريد تحديث الموقع تلقائيًا كل فترة:

1. **في hPanel، اذهب إلى Advanced > Cron Jobs**
2. انقر على **Create Cron Job**
3. إعداد Cron Job:
   ```
   Schedule: اختر الفترة (مثلاً: كل ساعة)
   Command: /home/username/update-site.sh
   ```
4. احفظ

### نصائح مهمة لاستخدام Git:

⚠️ **تحذيرات:**
- لا ترفع ملف `.env` أو أي ملفات تحتوي على معلومات حساسة إلى GitHub
- استخدم `.gitignore` لاستبعاد الملفات الحساسة
- تأكد من تشفير أي معلومات حساسة

✅ **أفضل الممارسات:**
- استخدم branch منفصل للإنتاج (production)
- اختبر التحديثات في بيئة تطوير أولاً
- احتفظ بنسخ احتياطية قبل التحديثات الكبيرة
- راجع السجلات (logs) بانتظام

---

## 🔍 استكشاف الأخطاء وإصلاحها

### المشكلة 1: الموقع لا يظهر (404 Not Found)

**الأسباب المحتملة:**
- ملف `index.html` غير موجود في `public_html`
- اسم الملف خاطئ
- صلاحيات الملف غير صحيحة

**الحلول:**
1. تحقق من وجود `index.html` في المجلد الصحيح
2. تأكد من اسم الملف بالضبط (أحرف صغيرة)
3. تحقق من صلاحيات الملف (644)
4. امسح الكاش في المتصفح (Ctrl+F5)

### المشكلة 2: الصفحة تظهر بدون تنسيق (CSS)

**الأسباب المحتملة:**
- روابط CSS غير صحيحة
- ملفات CSS غير مرفوعة
- مشاكل في المسارات

**الحلول:**
1. تحقق من رفع جميع ملفات CSS
2. تأكد من صحة المسارات في `<link>` tags:
   ```html
   <!-- صحيح -->
   <link rel="stylesheet" href="/css/styles.css">
   <!-- أو -->
   <link rel="stylesheet" href="css/styles.css">
   ```
3. تحقق من رابط CSS في أدوات المطور (F12)
4. تأكد من صلاحيات ملفات CSS (644)

### المشكلة 3: SSL غير نشط أو يظهر "Not Secure"

**الأسباب المحتملة:**
- SSL غير مفعل
- محتوى مختلط (Mixed Content)
- انتهاء صلاحية الشهادة

**الحلول:**
1. فعّل SSL من hPanel > Security > SSL
2. تأكد من أن جميع الروابط تستخدم HTTPS
3. أضف كود إعادة التوجيه في `.htaccess`:
   ```apache
   RewriteEngine On
   RewriteCond %{HTTPS} off
   RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
   ```
4. امسح الكاش وأعد تحميل الصفحة

### المشكلة 4: FTP لا يتصل

**الأسباب المحتملة:**
- بيانات اتصال خاطئة
- جدار ناري يحجب المنفذ
- حساب FTP معطل

**الحلول:**
1. تحقق من صحة:
   - عنوان السيرفر
   - اسم المستخدم
   - كلمة المرور
   - المنفذ (21 أو 22)
2. جرب SFTP بدلاً من FTP
3. عطّل جدار الحماية مؤقتًا للاختبار
4. أنشئ حساب FTP جديد من hPanel

### المشكلة 5: النطاق لا يعمل بعد الربط

**الأسباب المحتملة:**
- لم يكتمل انتشار DNS
- إعدادات DNS غير صحيحة
- مشكلة في Name Servers

**الحلول:**
1. انتظر من 4 إلى 48 ساعة للانتشار الكامل
2. تحقق من DNS باستخدام [DNS Checker](https://dnschecker.org/)
3. تأكد من صحة Name Servers أو A Records
4. امسح الكاش DNS على جهازك:
   ```bash
   # Windows
   ipconfig /flushdns
   
   # Mac
   sudo killall -HUP mDNSResponder
   
   # Linux
   sudo systemd-resolve --flush-caches
   ```

### المشكلة 6: صلاحيات الملفات

**الأعراض:**
- خطأ 403 Forbidden
- الملفات لا تظهر
- لا يمكن الكتابة على الملفات

**الحلول:**
1. الصلاحيات الصحيحة:
   - الملفات: 644 (rw-r--r--)
   - المجلدات: 755 (rwxr-xr-x)
2. تغيير الصلاحيات عبر FTP:
   - انقر بالزر الأيمن > Properties/Permissions
3. أو عبر SSH:
   ```bash
   chmod 644 *.html
   chmod 755 */
   ```

### المشكلة 7: موقع بطيء

**الأسباب المحتملة:**
- صور كبيرة الحجم
- عدم وجود تخزين مؤقت
- عدم تفعيل الضغط

**الحلول:**
1. ضغط الصور قبل الرفع
2. تفعيل التخزين المؤقت في `.htaccess` (راجع قسم إعداد بيئة النشر)
3. تفعيل ضغط Gzip
4. استخدام CDN لتسريع التحميل
5. تحسين الكود (تصغير CSS/JS)

### المشكلة 8: Git Pull لا يعمل

**الأسباب المحتملة:**
- تعارضات في الملفات
- مشاكل في الصلاحيات
- SSH Key غير صحيح

**الحلول:**
1. تحقق من الحالة:
   ```bash
   git status
   ```
2. إعادة تعيين التغييرات المحلية:
   ```bash
   git reset --hard HEAD
   git pull origin main
   ```
3. حل التعارضات يدويًا:
   ```bash
   git pull origin main
   # حل التعارضات في الملفات
   git add .
   git commit -m "Resolved conflicts"
   ```
4. تحقق من SSH Key:
   ```bash
   ssh -T git@github.com
   ```

---

## 🔒 أفضل ممارسات الأمان

### 1. حماية الملفات الحساسة

**ملفات يجب عدم رفعها:**
- ❌ `.env` (متغيرات البيئة)
- ❌ `.git/` (مجلد Git)
- ❌ `node_modules/` (تبعيات Node.js)
- ❌ `*.key`, `*.pem` (مفاتيح التشفير)
- ❌ `config.php` (إذا احتوى على كلمات مرور)
- ❌ `.htpasswd` (ملفات المصادقة)

**استخدم `.gitignore`:**
```
# ملفات البيئة
.env
.env.local
.env.production

# مجلد Git
.git/

# التبعيات
node_modules/
vendor/

# الملفات الحساسة
*.key
*.pem
config.php
database.php

# ملفات النظام
.DS_Store
Thumbs.db
```

### 2. حماية ملف .htaccess

أضف إلى `.htaccess`:

```apache
# منع الوصول إلى ملفات حساسة
<FilesMatch "\.(htaccess|htpasswd|ini|log|sh|inc|bak|env|git)$">
  Order Allow,Deny
  Deny from all
</FilesMatch>

# حماية wp-config.php إذا كنت تستخدم WordPress
<files wp-config.php>
  order allow,deny
  deny from all
</files>

# منع عرض قائمة المجلدات
Options -Indexes

# حماية من XSS
<IfModule mod_headers.c>
  Header set X-XSS-Protection "1; mode=block"
  Header set X-Content-Type-Options "nosniff"
  Header set X-Frame-Options "SAMEORIGIN"
</IfModule>
```

### 3. كلمات مرور قوية

- ✅ استخدم كلمات مرور طويلة (12+ حرف)
- ✅ مزيج من الأحرف الكبيرة والصغيرة والأرقام والرموز
- ✅ لا تستخدم نفس كلمة المرور لخدمات مختلفة
- ✅ استخدم مدير كلمات مرور (مثل LastPass أو 1Password)
- ✅ غيّر كلمات المرور بشكل دوري

### 4. المصادقة الثنائية (2FA)

- فعّل 2FA على حساب Hostinger
- فعّل 2FA على حساب GitHub
- استخدم تطبيق مثل Google Authenticator

### 5. النسخ الاحتياطية

**النسخ الاحتياطية التلقائية:**
1. في hPanel > Files > Backups
2. فعّل النسخ الاحتياطية التلقائية (إذا متوفرة)
3. أو استخدم Cron Job للنسخ الاحتياطي:
```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d)
tar -czf ~/backups/backup-$DATE.tar.gz ~/public_html
```

**النسخ الاحتياطية اليدوية:**
- احفظ نسخة من الموقع على جهازك المحلي
- احفظ نسخة من قواعد البيانات
- احفظ نسخة من ملفات الإعداد

### 6. تحديثات الأمان

- ✅ حدّث البرمجيات بانتظام (PHP، WordPress، إلخ)
- ✅ راقب تنبيهات الأمان من Hostinger
- ✅ راجع سجلات الأخطاء بشكل دوري
- ✅ استخدم أدوات فحص الأمان

### 7. مراقبة السيرفر

**في hPanel:**
- راقب استخدام الموارد (CPU، RAM، Disk)
- راجع سجلات الوصول (Access Logs)
- راجع سجلات الأخطاء (Error Logs)
- راقب حركة المرور (Bandwidth)

**استخدم أدوات مراقبة:**
- [UptimeRobot](https://uptimerobot.com/) - مراقبة وقت التشغيل
- [Google Search Console](https://search.google.com/search-console) - مراقبة SEO والأمان
- Cloudflare - الحماية من الهجمات وتسريع الموقع

### 8. حماية من الهجمات الشائعة

**حماية من SQL Injection:**
```php
// استخدم Prepared Statements
$stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$email]);
```

**حماية من XSS:**
```php
// تنظيف المدخلات
$clean_input = htmlspecialchars($_POST['user_input'], ENT_QUOTES, 'UTF-8');
```

**حماية من CSRF:**
```html
<!-- استخدم CSRF tokens -->
<input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
```

### 9. استخدام HTTPS فقط

- ✅ فعّل SSL/TLS
- ✅ أجبر HTTPS في `.htaccess`
- ✅ استخدم HSTS (HTTP Strict Transport Security):
```apache
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

### 10. قائمة فحص الأمان

قبل النشر:
- [ ] حذف جميع الملفات الحساسة
- [ ] تحديث `.gitignore`
- [ ] تفعيل SSL
- [ ] إعداد `.htaccess` للأمان
- [ ] اختبار صلاحيات الملفات
- [ ] تفعيل المصادقة الثنائية
- [ ] إعداد النسخ الاحتياطية
- [ ] اختبار الموقع للثغرات
- [ ] مراجعة سجلات الأخطاء
- [ ] توثيق جميع الإعدادات

---

## 📞 الدعم والمساعدة

### موارد Hostinger

- **مركز المساعدة:** [https://support.hostinger.com](https://support.hostinger.com)
- **الدردشة المباشرة:** متوفرة 24/7 من hPanel
- **قاعدة المعرفة:** [https://support.hostinger.com/kb/](https://support.hostinger.com/kb/)
- **المنتديات:** [https://www.hostinger.com/forum](https://www.hostinger.com/forum)

### مستودع المشروع

- **GitHub Repository:** [https://github.com/wasalstor-web/AI-Agent-Platform](https://github.com/wasalstor-web/AI-Agent-Platform)
- **Issues:** [https://github.com/wasalstor-web/AI-Agent-Platform/issues](https://github.com/wasalstor-web/AI-Agent-Platform/issues)
- **Documentation:** راجع README.md و FINALIZATION.md

### أدوات مفيدة

- **DNS Checker:** [https://dnschecker.org](https://dnschecker.org)
- **SSL Checker:** [https://www.sslshopper.com/ssl-checker.html](https://www.sslshopper.com/ssl-checker.html)
- **PageSpeed Insights:** [https://pagespeed.web.dev](https://pagespeed.web.dev)
- **W3C Validator:** [https://validator.w3.org](https://validator.w3.org)

---

## 📝 ملاحظات ختامية

### قائمة تحقق النشر النهائية

قبل اعتبار النشر مكتملاً:

- [ ] رفع جميع الملفات بنجاح
- [ ] `index.html` في المكان الصحيح
- [ ] SSL مفعّل ويعمل
- [ ] النطاق مربوط ويعمل
- [ ] صفحات الخطأ مخصصة
- [ ] `.htaccess` معد بشكل صحيح
- [ ] صلاحيات الملفات صحيحة
- [ ] الموقع يعمل على جميع الأجهزة
- [ ] السرعة مقبولة
- [ ] النسخ الاحتياطية معدة
- [ ] الأمان محسّن
- [ ] SEO أساسي معد
- [ ] Git معد (إن أردت)
- [ ] التوثيق محفوظ

### التحسينات المستقبلية

بعد النشر الأولي، فكر في:

- 📊 إضافة Google Analytics لتتبع الزوار
- 🚀 استخدام CDN لتسريع الموقع
- 🔍 تحسين SEO للظهور في محركات البحث
- 📧 إعداد البريد الإلكتروني للنطاق
- 💬 إضافة نظام تعليقات أو دردشة
- 🌍 توسيع دعم اللغات
- 📱 تحسين تجربة الموبايل
- ⚡ تحسين الأداء والسرعة

### شكرًا!

نأمل أن يكون هذا الدليل قد ساعدك في نشر مشروع AI Agent Platform على Hostinger بنجاح. إذا واجهت أي مشاكل أو كان لديك أسئلة، لا تتردد في فتح Issue على GitHub أو الاتصال بدعم Hostinger.

**بالتوفيق! 🚀**

---

**آخر تحديث:** 2025-10-19
**الإصدار:** 1.0.0
