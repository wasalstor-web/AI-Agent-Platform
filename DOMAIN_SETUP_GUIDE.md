# دليل ربط النطاق المخصص مع Render
# Custom Domain Setup Guide for Render.com

## 📋 نظرة عامة | Overview

هذا الدليل يشرح خطوة بخطوة كيفية ربط نطاقك المخصص (مثل `ai.yourdomain.com` أو `yourdomain.com`) مع خدمة DL+ AI Agent Platform المنشورة على منصة Render.

This guide explains step-by-step how to connect your custom domain (like `ai.yourdomain.com` or `yourdomain.com`) with your DL+ AI Agent Platform service deployed on Render.

---

## 🎯 الخطوات الرئيسية | Main Steps

### الخطوة 1: إضافة النطاق في لوحة تحكم Render
### Step 1: Add Domain in Render Dashboard

1. **تسجيل الدخول إلى Render**
   - اذهب إلى [render.com](https://render.com)
   - سجل الدخول إلى حسابك

2. **اختيار الخدمة**
   - اذهب إلى الخدمة التي تريد ربط النطاق بها (DL+ AI Agent)
   - انقر على اسم الخدمة لفتح صفحة التفاصيل

3. **إضافة النطاق المخصص**
   - انقر على تبويب **"Settings"** (الإعدادات)
   - ابحث عن قسم **"Custom Domains"** (النطاقات المخصصة)
   - انقر على **"Add Custom Domain"** (إضافة نطاق مخصص)
   - أدخل نطاقك (مثل `ai.yourdomain.com` أو `www.yourdomain.com`)
   - انقر **"Save"** (حفظ)

4. **الحصول على معلومات DNS**
   - بعد إضافة النطاق، سيعرض لك Render المعلومات التي تحتاجها
   - احتفظ بهذه المعلومات للخطوة التالية

---

### الخطوة 2: إعداد سجلات DNS
### Step 2: Configure DNS Records

الآن تحتاج إلى إعداد سجلات DNS في موفر النطاق الخاص بك. نوع السجل يعتمد على نوع النطاق:

#### A. للنطاقات الفرعية (Subdomains) - مثل `ai.yourdomain.com`

**استخدم سجل CNAME:**

```
Type:    CNAME
Name:    ai (أو www أو أي نطاق فرعي تريده)
Value:   your-service-name.onrender.com
TTL:     3600 (أو الافتراضي)
```

**خطوات الإعداد:**

1. افتح لوحة تحكم موفر النطاق (GoDaddy, Namecheap, Cloudflare، إلخ)
2. اذهب إلى قسم **إدارة DNS** أو **DNS Management**
3. انقر **"إضافة سجل"** أو **"Add Record"**
4. اختر نوع السجل: **CNAME**
5. في حقل **Name/Host**:
   - أدخل النطاق الفرعي فقط (مثل `ai` أو `www`)
   - بعض الموفرين يطلبون `ai.yourdomain.com` كاملاً
6. في حقل **Value/Points to**:
   - أدخل `your-service-name.onrender.com`
   - استبدل `your-service-name` باسم خدمتك على Render
7. احفظ السجل

**مثال عملي:**
```
إذا كان نطاقك: example.com
وتريد استخدام: ai.example.com
واسم خدمتك على Render: dlplus-agent

السجل سيكون:
Type:  CNAME
Name:  ai
Value: dlplus-agent.onrender.com
```

---

#### B. للنطاق الجذر (Root Domain) - مثل `yourdomain.com`

للنطاق الجذر، لديك خياران:

**الخيار 1: سجل ANAME/ALIAS (الأفضل - إذا كان موفرك يدعمه)**

```
Type:    ANAME أو ALIAS
Name:    @ (أو اترك فارغاً)
Value:   your-service-name.onrender.com
TTL:     3600
```

**الموفرون الذين يدعمون ANAME/ALIAS:**
- DNSimple
- DNS Made Easy
- Name.com
- NS1
- Cloudflare (يسمونه CNAME Flattening)

**خطوات الإعداد:**
1. افتح لوحة تحكم DNS
2. أضف سجل جديد
3. اختر نوع **ANAME** أو **ALIAS**
4. في Name: استخدم `@` أو اتركه فارغاً
5. في Value: أدخل `your-service-name.onrender.com`
6. احفظ

---

**الخيار 2: سجل A (إذا لم يدعم موفرك ANAME/ALIAS)**

```
Type:    A
Name:    @ (أو اترك فارغاً)
Value:   216.24.57.1
TTL:     3600
```

⚠️ **مهم جداً:**
- استخدم عنوان IP الخاص بـ Render: **216.24.57.1**
- احذف أي سجلات **AAAA** (IPv6) موجودة - Render يستخدم IPv4 فقط
- سجلات AAAA قد تسبب مشاكل في الاتصال

**خطوات الإعداد:**
1. افتح لوحة تحكم DNS
2. أضف سجل جديد من نوع **A**
3. في Name: استخدم `@` أو اتركه فارغاً للنطاق الجذر
4. في Value/IP Address: أدخل `216.24.57.1`
5. احذف أي سجلات AAAA موجودة
6. احفظ

---

#### C. ملاحظة خاصة لمستخدمي Cloudflare
#### Special Note for Cloudflare Users

⚠️ **مهم لمستخدمي Cloudflare:**

إذا كنت تستخدم Cloudflare كموفر DNS:
- **دائماً** استخدم سجل **CNAME** (وليس A)
- حتى للنطاق الجذر، استخدم CNAME
- Cloudflare يدعم CNAME Flattening تلقائياً

**مثال لـ Cloudflare:**
```
Type:    CNAME
Name:    @ (للنطاق الجذر) أو www (للنطاق الفرعي)
Target:  your-service-name.onrender.com
Proxy:   🟠 DNS only (Proxied قد يسبب مشاكل)
TTL:     Auto
```

**خطوات إضافية لـ Cloudflare:**
1. تأكد من إيقاف الـ Proxy (اضغط على الغيمة البرتقالية 🟠)
2. اترك Cloudflare على وضع **DNS only**
3. هذا يضمن عمل SSL من Render بشكل صحيح

---

### الخطوة 3: التحقق من النطاق في Render
### Step 3: Verify Domain in Render

بعد إعداد سجلات DNS:

1. **ارجع إلى لوحة تحكم Render**
2. **اذهب إلى Custom Domains**
3. **انقر على "Verify"** بجانب نطاقك
4. **انتظر التحقق:**
   - قد يستغرق التحقق من **بضع دقائق إلى 48 ساعة**
   - انتشار DNS عادة يستغرق 5-30 دقيقة
   - بعض الموفرين أبطأ من غيرهم

5. **إذا فشل التحقق:**
   - انتظر 10-15 دقيقة إضافية
   - تأكد من صحة سجلات DNS
   - استخدم أدوات التحقق (انظر الخطوة 4)

---

### الخطوة 4: التحقق من سجلات DNS
### Step 4: Verify DNS Records

استخدم هذه الأدوات للتحقق من أن سجلات DNS تم إعدادها بشكل صحيح:

#### أ. استخدام أداة dig (في Terminal/Command Line)

**للتحقق من CNAME:**
```bash
dig ai.yourdomain.com CNAME
```

**للتحقق من A Record:**
```bash
dig yourdomain.com A
```

**النتيجة الصحيحة لـ CNAME:**
```
ai.yourdomain.com.    3600    IN    CNAME    your-service.onrender.com.
```

**النتيجة الصحيحة لـ A Record:**
```
yourdomain.com.    3600    IN    A    216.24.57.1
```

---

#### ب. استخدام أدوات الويب

**أدوات مجانية للتحقق من DNS:**

1. **DNS Checker**
   - الرابط: https://dnschecker.org/
   - أدخل نطاقك
   - اختر نوع السجل (CNAME أو A)
   - تحقق من الانتشار العالمي

2. **What's My DNS**
   - الرابط: https://www.whatsmydns.net/
   - يعرض حالة DNS من مواقع متعددة حول العالم

3. **MX Toolbox**
   - الرابط: https://mxtoolbox.com/DNSLookup.aspx
   - أداة شاملة للتحقق من DNS

---

### الخطوة 5: شهادة SSL التلقائية
### Step 5: Automatic SSL Certificate

بعد التحقق الناجح من النطاق:

✅ **Render سيقوم تلقائياً بـ:**
- إصدار شهادة SSL مجانية من Let's Encrypt
- تثبيت الشهادة على نطاقك
- تفعيل HTTPS تلقائياً
- تجديد الشهادة تلقائياً كل 90 يوم

🔒 **نطاقك سيصبح:**
- `https://ai.yourdomain.com` ← آمن ومشفر
- `http://` سيُحوّل تلقائياً إلى `https://`

**لا تحتاج لأي خطوات إضافية - كل شيء تلقائي!**

---

## 📊 جدول ملخص سجلات DNS
## DNS Records Summary Table

| نوع النطاق | Domain Type | نوع السجل | Record Type | Name | Value | TTL |
|------------|------------|----------|-------------|------|-------|-----|
| نطاق فرعي | Subdomain (ai.example.com) | CNAME | CNAME | ai | your-app.onrender.com | 3600 |
| نطاق جذر (خيار 1) | Root - Option 1 | ANAME/ALIAS | ANAME/ALIAS | @ | your-app.onrender.com | 3600 |
| نطاق جذر (خيار 2) | Root - Option 2 | A | A | @ | 216.24.57.1 | 3600 |
| Cloudflare - أي نطاق | Cloudflare - Any | CNAME | CNAME | @ or subdomain | your-app.onrender.com | Auto |

---

## 🔧 حل المشاكل الشائعة
## Common Troubleshooting

### المشكلة 1: "DNS verification failed"

**الحلول:**
1. ✅ انتظر 15-30 دقيقة إضافية (انتشار DNS)
2. ✅ تحقق من السجل في أدوات DNS Checker
3. ✅ تأكد من عدم وجود سجلات متضاربة
4. ✅ احذف أي سجلات AAAA للنطاق الجذر
5. ✅ تأكد من استخدام النوع الصحيح (CNAME للفرعي، ANAME/A للجذر)

---

### المشكلة 2: "SSL certificate not working"

**الحلول:**
1. ✅ انتظر 5-10 دقائق بعد التحقق الناجح
2. ✅ امسح cache المتصفح
3. ✅ جرب في وضع incognito/private
4. ✅ تحقق من أن DNS يشير بشكل صحيح
5. ✅ في Cloudflare: تأكد من إيقاف Proxy

---

### المشكلة 3: "Domain shows old content"

**الحلول:**
1. ✅ امسح DNS cache المحلي:
   - **Windows**: `ipconfig /flushdns`
   - **Mac**: `sudo dscacheutil -flushcache`
   - **Linux**: `sudo systemd-resolve --flush-caches`
2. ✅ امسح cache المتصفح
3. ✅ جرب من جهاز أو شبكة أخرى
4. ✅ انتظر انتشار DNS الكامل (حتى 48 ساعة)

---

### المشكلة 4: "Multiple DNS records conflict"

**الحلول:**
1. ✅ احذف جميع السجلات القديمة للنطاق نفسه
2. ✅ تأكد من وجود سجل واحد فقط لكل نطاق
3. ✅ لا تستخدم A و CNAME معاً لنفس النطاق
4. ✅ احذف سجلات AAAA (IPv6)

---

### المشكلة 5: "Cloudflare domain not working"

**الحلول Cloudflare-specific:**
1. ✅ استخدم **CNAME فقط** (ليس A)
2. ✅ أوقف الـ Proxy (🟠 DNS only)
3. ✅ انتظر بضع دقائق بعد التغيير
4. ✅ تحقق من إعدادات SSL في Cloudflare:
   - اذهب إلى SSL/TLS
   - اختر **"Full"** أو **"Full (strict)"**

---

## 📝 قائمة تحقق قبل البدء
## Pre-Setup Checklist

- [ ] لديك حساب على Render.com
- [ ] خدمتك منشورة ومفعّلة على Render
- [ ] لديك وصول إلى لوحة تحكم موفر النطاق
- [ ] تعرف نوع نطاقك (جذر أو فرعي)
- [ ] تعرف إذا كان موفرك يدعم ANAME/ALIAS
- [ ] لديك صلاحيات تعديل سجلات DNS

---

## ⏱️ الجدول الزمني المتوقع
## Expected Timeline

| الخطوة | Step | الوقت المتوقع | Expected Time |
|--------|------|---------------|---------------|
| إضافة النطاق في Render | Add domain in Render | فوري | Instant |
| إعداد DNS | Configure DNS | 5-10 دقائق | 5-10 minutes |
| انتشار DNS | DNS propagation | 5-30 دقيقة | 5-30 minutes |
| التحقق في Render | Render verification | 1-5 دقائق | 1-5 minutes |
| إصدار SSL | SSL issuance | 5-10 دقائق | 5-10 minutes |
| **الوقت الإجمالي** | **Total Time** | **15-60 دقيقة** | **15-60 minutes** |

*ملاحظة: في بعض الحالات النادرة، قد يستغرق انتشار DNS حتى 48 ساعة*

---

## 🎓 نصائح إضافية
## Additional Tips

### نصيحة 1: استخدم نطاقات فرعية للاختبار
ابدأ بنطاق فرعي (مثل `test.yourdomain.com`) للتجربة قبل ربط النطاق الرئيسي.

### نصيحة 2: احتفظ بنسخة احتياطية من إعدادات DNS
قبل التعديل، خذ لقطة شاشة أو اكتب سجلات DNS الحالية.

### نصيحة 3: راقب الانتشار
استخدم https://dnschecker.org/ لمراقبة انتشار DNS عالمياً.

### نصيحة 4: اختبر من مواقع متعددة
استخدم VPN أو اطلب من أصدقاء في دول أخرى اختبار النطاق.

### نصيحة 5: فعّل إشعارات Render
فعّل الإشعارات في Render لتلقي تنبيهات عن حالة النطاق و SSL.

---

## 📚 مصادر إضافية
## Additional Resources

### وثائق Render الرسمية
- [Custom Domains Guide](https://render.com/docs/custom-domains)
- [DNS Configuration](https://render.com/docs/configure-other-dns)
- [SSL Certificates](https://render.com/docs/tls)

### أدوات مفيدة
- **DNS Checker**: https://dnschecker.org/
- **What's My DNS**: https://www.whatsmydns.net/
- **MX Toolbox**: https://mxtoolbox.com/
- **SSL Labs Test**: https://www.ssllabs.com/ssltest/

### دعم موفري DNS الشائعين
- [GoDaddy DNS Setup](https://www.godaddy.com/help/manage-dns-records-680)
- [Namecheap DNS Setup](https://www.namecheap.com/support/knowledgebase/article.aspx/767/10/how-to-change-dns-for-a-domain/)
- [Cloudflare DNS Setup](https://developers.cloudflare.com/dns/manage-dns-records/how-to/create-dns-records/)

---

## 💬 الحصول على المساعدة
## Getting Help

إذا واجهت أي مشاكل:

1. **راجع قسم حل المشاكل** في هذا الدليل
2. **تحقق من وثائق Render** الرسمية
3. **اتصل بدعم موفر النطاق** للمساعدة في إعداد DNS
4. **افتح issue في GitHub** إذا كانت المشكلة تتعلق بالمشروع
5. **راجع سجلات Render** (Logs) لتشخيص المشاكل

---

## ✅ التحقق النهائي
## Final Verification

بعد إكمال جميع الخطوات، تأكد من:

- [ ] النطاق يفتح في المتصفح
- [ ] SSL يعمل (🔒 في شريط العنوان)
- [ ] لا توجد تحذيرات أمنية
- [ ] الموقع يحمّل بشكل صحيح
- [ ] جميع الروابط تعمل
- [ ] API endpoints تستجيب

**اختبار سريع:**
```bash
# اختبر النطاق
curl -I https://ai.yourdomain.com

# يجب أن ترى:
# HTTP/2 200
# والكثير من الرؤوس الأخرى
```

---

<div align="center">

## 🎉 تهانينا!
## Congratulations!

**نطاقك المخصص الآن مربوط بنجاح مع Render!**

**Your custom domain is now successfully connected to Render!**

---

**للرجوع إلى الصفحة الرئيسية:** [README.md](README.md)

**Back to main page:** [README.md](README.md)

</div>
