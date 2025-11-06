#!/bin/bash

# سكربت النشر الشامل لمنصة AI-Agent-Platform على سيرفر هوستنقر
# تاريخ الإنشاء: 2025-10-20

# تعيين متغيرات البيئة
REPO_URL="https://github.com/wasalstor-web/AI-Agent-Platform.git"
DEPLOY_PATH="/var/www/html/AI-Agent-Platform"
NGINX_CONF="/etc/nginx/sites-available/ai-agent-platform"
DOMAIN="${DOMAIN:-your-domain.com}"  # قم بتغيير هذا بنطاقك أو تعيينه كمتغير بيئة
EMAIL="${EMAIL:-your-email@domain.com}"  # قم بتعيين البريد الإلكتروني كمتغير بيئة

# دالة عرض الحالة
show_status() {
    echo -e "\e[34m$1\e[0m"
}

# دالة عرض النجاح
show_success() {
    echo -e "\e[32m✓ $1\e[0m"
}

# دالة عرض الخطأ
show_error() {
    echo -e "\e[31m✗ $1\e[0m"
    exit 1
}

# التحقق من تعيين المتغيرات المطلوبة
if [ "$DOMAIN" = "your-domain.com" ]; then
    show_error "يجب تعيين متغير DOMAIN قبل التشغيل. مثال: export DOMAIN=example.com"
fi

if [ "$EMAIL" = "your-email@domain.com" ]; then
    show_error "يجب تعيين متغير EMAIL قبل التشغيل. مثال: export EMAIL=admin@example.com"
fi

# التحقق من صلاحيات المستخدم
if [ "$EUID" -ne 0 ]; then
    show_error "يجب تشغيل السكربت كمستخدم root"
fi

# تحديث النظام وتثبيت المتطلبات
show_status "جاري تحديث النظام وتثبيت المتطلبات..."
apt update || show_error "فشل تحديث قائمة الحزم"
apt upgrade -y || show_error "فشل في ترقية النظام"
apt install -y nginx certbot python3-certbot-nginx git || show_error "فشل في تثبيت المتطلبات"

# إنشاء مجلد النشر
show_status "جاري إعداد مجلد النشر..."
mkdir -p $DEPLOY_PATH
cd $DEPLOY_PATH || show_error "فشل الوصول إلى مجلد النشر"

# نسخ المستودع
show_status "جاري نسخ المستودع..."
if [ -d ".git" ]; then
    git pull origin main
else
    git clone $REPO_URL .
fi

# تكوين Nginx
show_status "جاري إعداد Nginx..."
cat > $NGINX_CONF << EOF
server {
    listen 80;
    server_name $DOMAIN;
    root $DEPLOY_PATH;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }

    access_log /var/log/nginx/$DOMAIN.access.log;
    error_log /var/log/nginx/$DOMAIN.error.log;
}
EOF

# إنشاء رابط رمزي وإعادة تحميل Nginx
ln -sf $NGINX_CONF /etc/nginx/sites-enabled/
nginx -t || show_error "فشل في تكوين Nginx"
systemctl reload nginx || show_error "فشل في إعادة تحميل Nginx"

# إعداد SSL
show_status "جاري إعداد شهادة SSL..."
certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email $EMAIL || show_error "فشل في إعداد شهادة SSL"

# إعداد النسخ الاحتياطي
show_status "جاري إعداد نظام النسخ الاحتياطي..."
BACKUP_DIR="/var/backups/ai-agent-platform"
mkdir -p $BACKUP_DIR

# إنشاء سكربت النسخ الاحتياطي
cat > /usr/local/bin/backup-ai-platform << EOF
#!/bin/bash
TIMESTAMP=\$(date +%Y%m%d_%H%M%S)
tar -czf $BACKUP_DIR/backup_\$TIMESTAMP.tar.gz $DEPLOY_PATH
find $BACKUP_DIR -type f -mtime +7 -delete
EOF

chmod +x /usr/local/bin/backup-ai-platform

# إضافة مهمة النسخ الاحتياطي لـ cron
CRON_JOB="0 2 * * * /usr/local/bin/backup-ai-platform"
(crontab -l 2>/dev/null || true | grep -v "backup-ai-platform"; echo "$CRON_JOB") | crontab - || show_error "فشل في إضافة مهمة cron"

# تعيين الصلاحيات
show_status "جاري ضبط الصلاحيات..."
chown -R www-data:www-data $DEPLOY_PATH
chmod -R 755 $DEPLOY_PATH

# فحص الأمان
show_status "جاري إجراء فحص الأمان..."
# السماح بـ SSH أولاً لتجنب قطع الاتصال
ufw allow OpenSSH 2>/dev/null || ufw allow 22/tcp
ufw allow 'Nginx Full'
ufw --force enable

# إظهار معلومات النشر
show_success "تم نشر المنصة بنجاح!"
echo "------------------------------------"
echo "معلومات المنصة:"
echo "- الموقع: https://$DOMAIN"
echo "- مجلد النشر: $DEPLOY_PATH"
echo "- ملف تكوين Nginx: $NGINX_CONF"
echo "- سجلات النظام: /var/log/nginx/$DOMAIN.access.log"
echo "- النسخ الاحتياطي: $BACKUP_DIR"
echo "------------------------------------"

# مراقبة الحالة
show_status "جاري التحقق من حالة الخدمات..."
systemctl status nginx | grep Active
curl -Is https://$DOMAIN | head -n 1
