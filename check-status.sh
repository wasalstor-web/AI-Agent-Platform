#!/bin/bash

# Script للتحقق من حالة الخدمات والملفات

# الألوان
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
NC="\033[0m" # لا لون

# دالة لطباعة الرسائل الملونة
print_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# التحقق من حالة Nginx
check_nginx() {
    if systemctl is-active --quiet nginx; then
        print_message "$GREEN" "Nginx: يعمل"
    else
        print_message "$RED" "Nginx: غير مفعل"
    fi
}

# التحقق من حالة شهادة SSL
check_ssl() {
    if openssl s_client -connect tradd.space:443 -servername tradd.space < /dev/null 2>/dev/null | grep -q 'Verify return code: 0'; then
        print_message "$GREEN" "شهادة SSL: صالحة"
    else
        print_message "$RED" "شهادة SSL: غير صالحة"
    fi
}

# التحقق من وجود ملفات المشروع
check_files_exist() {
    if [ -d "/var/www/AI-Agent-Platform" ]; then
        print_message "$GREEN" "الملفات: موجودة"
    else
        print_message "$RED" "الملفات: غير موجودة"
    fi
}

# التحقق من أذونات الملفات
check_permissions() {
    if [ -r /var/www/AI-Agent-Platform ] && [ -w /var/www/AI-Agent-Platform ]; then
        print_message "$GREEN" "الأذونات: صحيحة"
    else
        print_message "$RED" "الأذونات: غير صحيحة"
    fi
}

# التحقق من حالة الجدار الناري
check_firewall() {
    if ufw status | grep -q 'Status: active'; then
        print_message "$GREEN" "الجدار الناري: مفعل"
    else
        print_message "$RED" "الجدار الناري: غير مفعل"
    fi
}

# التحقق من الوظائف المجدولة
check_cron_jobs() {
    if crontab -l | grep -q 'backup'; then
        print_message "$GREEN" "وظيفة النسخ الاحتياطي: موجودة"
    else
        print_message "$YELLOW" "وظيفة النسخ الاحتياطي: غير موجودة"
    fi

    if crontab -l | grep -q 'renew'; then
        print_message "$GREEN" "وظيفة تجديد SSL: موجودة"
    else
        print_message "$YELLOW" "وظيفة تجديد SSL: غير موجودة"
    fi
}

# التحقق من حالة PHP-FPM
check_php_fpm() {
    if systemctl is-active --quiet php7.4-fpm; then
        print_message "$GREEN" "PHP-FPM: يعمل"
    else
        print_message "$RED" "PHP-FPM: غير مفعل"
    fi
}

# التحقق من استجابة HTTP للموقع
check_http_response() {
    if curl -s -o /dev/null -w '%{http_code}' http://tradd.space | grep -q '200'; then
        print_message "$GREEN" "استجابة HTTP: 200"
    else
        print_message "$RED" "استجابة HTTP: خطأ"
    fi
}

# التحقق من استخدام القرص
check_disk_usage() {
    local usage=$(df / | grep / | awk '{ print $5 }')
    print_message "$YELLOW" "استخدام القرص: $usage"
}

# تنفيذ جميع الفحوصات
check_nginx
check_ssl
check_files_exist
check_permissions
check_firewall
check_cron_jobs
check_php_fpm
check_http_response
check_disk_usage

# ملخص الفحص
print_message "$GREEN" "
فحص الحالة اكتمل"