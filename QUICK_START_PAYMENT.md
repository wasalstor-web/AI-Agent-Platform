# Quick Start Guide - Payment System
# دليل البدء السريع - نظام الدفع

## تشغيل النظام | Running the System

### 1. تثبيت المتطلبات | Install Dependencies

```bash
pip install flask flask-cors requests
```

أو استخدم ملف المتطلبات:
```bash
pip install -r requirements.txt
```

### 2. تشغيل خادم API | Start the API Server

```bash
cd api
python server.py
```

سيعمل الخادم على: `http://localhost:5000`

### 3. فتح واجهة الدفع | Open Payment Interface

افتح الملف في المتصفح:
```
payment-confirmation.html
```

أو استخدم خادم محلي:
```bash
python -m http.server 8080
# ثم افتح http://localhost:8080/payment-confirmation.html
```

### 4. تجربة النظام | Test the System

#### الطريقة 1: الواجهة الرسومية | Method 1: Web Interface

1. افتح `payment-confirmation.html`
2. اختر خطة (أساسي، احترافي، مؤسسات)
3. أدخل معرف المستخدم
4. انقر "إنشاء طلب الدفع"
5. انقر "تأكيد الدفع"
6. ✅ تم تفعيل المميزات المتقدمة!

#### الطريقة 2: سطر الأوامر | Method 2: Command Line

```bash
# تشغيل الاختبارات التلقائية
python test_payment.py

# أو استخدم curl مباشرة
# 1. الحصول على الخطط
curl http://localhost:5000/api/payment/plans

# 2. إنشاء طلب دفع
curl -X POST http://localhost:5000/api/payment/create \
  -H "Content-Type: application/json" \
  -d '{"user_id": "khalid123", "plan": "pro", "amount": 29.99}'

# 3. تأكيد الدفع (استخدم payment_id من الخطوة 2)
curl -X POST http://localhost:5000/api/payment/confirm \
  -H "Content-Type: application/json" \
  -d '{"payment_id": "YOUR_PAYMENT_ID", "transaction_ref": "txn_123"}'

# 4. التحقق من حالة الاشتراك المميز
curl http://localhost:5000/api/premium/status/khalid123
```

## اختبار النظام | Testing

### اختبارات الوحدة | Unit Tests

```bash
python tests/test_payment_processor.py
```

يجب أن تظهر:
```
Ran 11 tests in 0.003s
OK
```

### اختبارات التكامل | Integration Tests

```bash
# تأكد من تشغيل الخادم أولاً
cd api && python server.py &

# ثم شغل الاختبارات
python test_payment.py
```

## الخطط المتاحة | Available Plans

### 🥉 أساسي | Basic - $9.99/شهر
- حدود معززة لمعدل API
- معالجة الطلبات ذات الأولوية
- تحليلات أساسية

### 🥈 احترافي | Professional - $29.99/شهر
- جميع مميزات الخطة الأساسية
- تحليلات وسجلات متقدمة
- دعم الضبط الدقيق للنماذج المخصصة
- دعم على مدار الساعة

### 🥇 مؤسسات | Enterprise - $99.99/شهر
- جميع مميزات الخطة الاحترافية
- حدود غير محدودة لمعدل API
- فريق دعم مخصص
- تكاملات مخصصة
- ضمانات SLA

## نقاط النهاية للAPI | API Endpoints

| الطريقة | المسار | الوصف |
|---------|--------|-------|
| GET | `/api/payment/plans` | الحصول على الخطط المتاحة |
| POST | `/api/payment/create` | إنشاء طلب دفع |
| POST | `/api/payment/confirm` | تأكيد الدفع |
| GET | `/api/payment/status/<id>` | حالة الدفع |
| GET | `/api/premium/status/<user_id>` | حالة الاشتراك المميز |

## استكشاف الأخطاء | Troubleshooting

### المشكلة: لا يمكن الاتصال بـ API
```bash
# تأكد من تشغيل الخادم
cd api
python server.py
```

### المشكلة: خطأ في الاستيراد
```bash
# ثبت المتطلبات
pip install flask flask-cors requests
```

### المشكلة: CORS error في المتصفح
- تأكد من أن الخادم يعمل على localhost:5000
- أو استخدم خادم محلي للواجهة أيضاً

## الأمان | Security

⚠️ **هام:** هذا مثال تعليمي

في بيئة الإنتاج:
- استخدم بوابة دفع حقيقية (Stripe, PayPal)
- نفذ المصادقة والتفويض
- استخدم HTTPS
- احفظ البيانات بشكل آمن
- التزم بمعايير PCI DSS

## الدعم | Support

للمساعدة:
- راجع [PAYMENT_SYSTEM.md](PAYMENT_SYSTEM.md) للوثائق الكاملة
- افتح issue على GitHub
- راجع ملف test_payment.py للأمثلة

---

**نصيحة:** ابدأ بالخطة الأساسية وترقى حسب الحاجة! 🚀
