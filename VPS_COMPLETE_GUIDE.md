# 🚀 دليل شامل لإدارة VPS Hostinger

## 📋 نظرة عامة

هذا الدليل يحتوي على جميع الأدوات والسيناريوهات لإدارة VPS Hostinger بشكل احترافي وآمن.

---

## 🔧 الأدوات المتاحة

### 1. **`vps-manager.sh`** ⭐ (الأفضل - مدير شامل)
مدير متكامل يوفر جميع الوظائف في واجهة واحدة:
```bash
./vps-manager.sh
```

**المميزات:**
- ✅ واجهة تفاعلية سهلة
- ✅ جميع الوظائف في مكان واحد
- ✅ إدارة الخدمات والملفات
- ✅ نسخ احتياطي
- ✅ فحص أمني
- ✅ عرض السجلات

---

### 2. **`setup-ssh-keys.sh`** 🔐 (الأمان)
إعداد SSH Keys للاتصال بدون كلمة مرور:
```bash
./setup-ssh-keys.sh
```

**المميزات:**
- ✅ إنشاء SSH keys تلقائياً
- ✅ نسخ المفتاح إلى الخادم
- ✅ اختبار الاتصال
- ✅ أكثر أماناً من كلمة المرور

**بعد الإعداد:**
```bash
ssh root@147.93.120.99  # بدون كلمة مرور!
```

---

### 3. **`vps-monitor.sh`** 📊 (المراقبة)
مراقبة متقدمة للحالة والموارد:
```bash
# فحص واحد
./vps-monitor.sh

# مراقبة مستمرة (كل 5 ثوان)
./vps-monitor.sh --continuous
```

**المميزات:**
- ✅ فحص شامل للموارد
- ✅ تحذيرات تلقائية
- ✅ مراقبة مستمرة
- ✅ عرض أعلى العمليات

---

### 4. **`vps-backup.sh`** 💾 (النسخ الاحتياطي)
نسخ احتياطي شامل للملفات وقواعد البيانات:
```bash
./vps-backup.sh
```

**الخيارات:**
- نسخ احتياطي للملفات المهمة
- نسخ احتياطي لقواعد البيانات
- نسخ احتياطي كامل
- نسخ احتياطي للإعدادات

**النسخ الاحتياطي محفوظ في:** `./backups/`

---

### 5. **`vps-status.sh`** ⚡ (فحص سريع)
فحص سريع للحالة:
```bash
./vps-status.sh
```

---

### 6. **`connect-vps.sh`** 🔌 (اتصال تفاعلي)
اتصال تفاعلي مع قائمة خيارات:
```bash
./connect-vps.sh
```

---

### 7. **`vps-quick-commands.sh`** ⚡ (أوامر سريعة)
أوامر سريعة من سطر الأوامر:
```bash
./vps-quick-commands.sh status    # فحص الحالة
./vps-quick-commands.sh top       # عرض العمليات
./vps-quick-commands.sh logs      # السجلات
./vps-quick-commands.sh disk      # استخدام القرص
./vps-quick-commands.sh connect   # اتصال SSH
```

---

## 🔐 إعداد SSH Config (اختياري)

للاستخدام الأسهل، أضف إعدادات SSH:

```bash
# نسخ الإعدادات
cat ssh-config-vps >> ~/.ssh/config

# أو يدوياً
nano ~/.ssh/config
```

ثم أضف:
```
Host vps-hostinger
    HostName 147.93.120.99
    User root
    IdentityFile ~/.ssh/id_rsa
```

**الاستخدام بعد الإعداد:**
```bash
ssh vps-hostinger  # بدلاً من ssh root@147.93.120.99
```

---

## 📝 سيناريوهات الاستخدام

### السيناريو 1: الإعداد الأولي
```bash
# 1. إعداد SSH Keys (أكثر أماناً)
./setup-ssh-keys.sh

# 2. فحص الحالة
./vps-status.sh

# 3. إعداد SSH Config (اختياري)
cat ssh-config-vps >> ~/.ssh/config
```

### السيناريو 2: فحص يومي
```bash
# فحص سريع
./vps-status.sh

# أو مراقبة مستمرة
./vps-monitor.sh --continuous
```

### السيناريو 3: نسخ احتياطي أسبوعي
```bash
# نسخ احتياطي كامل
./vps-backup.sh
# اختر الخيار 3 (نسخ احتياطي كامل)
```

### السيناريو 4: حل مشكلة
```bash
# استخدام المدير الشامل
./vps-manager.sh

# أو فحص السجلات مباشرة
./vps-quick-commands.sh logs
```

### السيناريو 5: إدارة يومية
```bash
# استخدام المدير الشامل (الأفضل)
./vps-manager.sh
```

---

## 🔒 الأمان

### ✅ أفضل الممارسات:

1. **استخدم SSH Keys بدلاً من كلمة المرور:**
   ```bash
   ./setup-ssh-keys.sh
   ```

2. **تعطيل تسجيل الدخول بكلمة المرور (في الخادم):**
   ```bash
   ssh root@147.93.120.99
   # في الخادم:
   nano /etc/ssh/sshd_config
   # غيّر: PasswordAuthentication no
   systemctl restart sshd
   ```

3. **فحص الأمان بانتظام:**
   ```bash
   ./vps-manager.sh
   # اختر: 8) فحص الأمان
   ```

4. **تغيير كلمة المرور بانتظام**

---

## 📊 معلومات الخادم

- **IP**: 147.93.120.99
- **User**: root
- **System**: Linux (cPanel)
- **RAM**: 15 GB
- **Disk**: 199 GB (190 GB متاح)
- **Services**: Apache, cPanel, MySQL, Email, DNS

---

## 🛠️ استكشاف الأخطاء

### مشكلة: "sshpass غير مثبت"
```bash
sudo apt-get update && sudo apt-get install -y sshpass
```

### مشكلة: "Permission denied"
```bash
# تأكد من صلاحيات الملفات
chmod +x *.sh

# أو استخدم SSH Keys
./setup-ssh-keys.sh
```

### مشكلة: "Connection refused"
- تحقق من أن الخادم يعمل
- تحقق من جدار الحماية
- تحقق من IP Address

---

## 📚 الملفات المرجعية

- **`vps-connection-info.txt`** - معلومات الاتصال (محمي في .gitignore)
- **`VPS_CONNECTION_README.md`** - دليل الاتصال الأساسي
- **`VPS_COMPLETE_GUIDE.md`** - هذا الدليل الشامل

---

## 💡 نصائح

1. **استخدم `vps-manager.sh`** للاستخدام اليومي (الأسهل والأفضل)
2. **أعد نسخ احتياطي بانتظام** (أسبوعياً على الأقل)
3. **راقب الموارد** باستخدام `vps-monitor.sh`
4. **استخدم SSH Keys** للأمان الأفضل
5. **احفظ النسخ الاحتياطي** في مكان آمن خارج الخادم

---

## 🎯 الخلاصة

**للبدء السريع:**
```bash
./vps-manager.sh
```

**للإعداد الأولي:**
```bash
./setup-ssh-keys.sh
./vps-status.sh
```

**للمراقبة:**
```bash
./vps-monitor.sh --continuous
```

**للنسخ الاحتياطي:**
```bash
./vps-backup.sh
```

---

## 📞 الدعم

إذا واجهت أي مشاكل:
1. تحقق من السجلات: `./vps-quick-commands.sh logs`
2. فحص الحالة: `./vps-status.sh`
3. فحص الأمان: `./vps-manager.sh` → خيار 8

---

**تم التحديث:** 2026-01-02  
**الإصدار:** 2.0 (محسّن ومتقدم)
