#!/bin/bash
# مدير VPS متقدم - جميع الوظائف في مكان واحد
# ============================================

VPS_HOST="147.93.120.99"
VPS_USER="root"
VPS_PASSWORD="9'hG8lV1RCU)sesnQ3hA"

# ألوان
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# دالة الاتصال
connect_vps() {
    if [ -f ~/.ssh/id_rsa ] && ssh -o ConnectTimeout=3 -o BatchMode=yes "$VPS_USER@$VPS_HOST" exit 2>/dev/null; then
        ssh "$VPS_USER@$VPS_HOST" "$@"
    else
        if ! command -v sshpass &> /dev/null; then
            echo -e "${RED}❌ sshpass غير مثبت. جارٍ التثبيت...${NC}"
            sudo apt-get update && sudo apt-get install -y sshpass
        fi
        sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$VPS_USER@$VPS_HOST" "$@"
    fi
}

# دالة القائمة الرئيسية
show_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     مدير VPS Hostinger المتقدم      ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}1)${NC}  اتصال SSH"
    echo -e "${CYAN}2)${NC}  فحص الحالة السريع"
    echo -e "${CYAN}3)${NC}  مراقبة متقدمة"
    echo -e "${CYAN}4)${NC}  إدارة الخدمات"
    echo -e "${CYAN}5)${NC}  إدارة الملفات"
    echo -e "${CYAN}6)${NC}  النسخ الاحتياطي"
    echo -e "${CYAN}7)${NC}  إدارة المستخدمين"
    echo -e "${CYAN}8)${NC}  فحص الأمان"
    echo -e "${CYAN}9)${NC}  إدارة قواعد البيانات"
    echo -e "${CYAN}10)${NC} عرض السجلات"
    echo -e "${CYAN}11)${NC} إعدادات SSH"
    echo -e "${CYAN}12)${NC} معلومات النظام"
    echo -e "${CYAN}0)${NC}  خروج"
    echo ""
}

# إدارة الخدمات
manage_services() {
    echo -e "${BLUE}=== إدارة الخدمات ===${NC}"
    echo "1) عرض جميع الخدمات"
    echo "2) إعادة تشغيل Apache"
    echo "3) إعادة تشغيل MySQL"
    echo "4) إعادة تشغيل جميع الخدمات"
    echo "5) حالة خدمة محددة"
    read -p "اختر: " choice
    
    case $choice in
        1) connect_vps "systemctl list-units --type=service --state=running" ;;
        2) connect_vps "systemctl restart httpd && echo '✅ تم إعادة تشغيل Apache'" ;;
        3) connect_vps "systemctl restart mysql && echo '✅ تم إعادة تشغيل MySQL'" ;;
        4) connect_vps "systemctl restart httpd mysql dovecot exim && echo '✅ تم إعادة تشغيل الخدمات'" ;;
        5) read -p "اسم الخدمة: " service; connect_vps "systemctl status $service" ;;
    esac
}

# إدارة الملفات
manage_files() {
    echo -e "${BLUE}=== إدارة الملفات ===${NC}"
    echo "1) عرض مساحة القرص"
    echo "2) البحث عن ملفات كبيرة"
    echo "3) تنظيف الملفات المؤقتة"
    echo "4) عرض أكبر 10 ملفات"
    read -p "اختر: " choice
    
    case $choice in
        1) connect_vps "df -h" ;;
        2) connect_vps "find / -type f -size +100M 2>/dev/null | head -20" ;;
        3) connect_vps "rm -rf /tmp/* /var/tmp/* 2>/dev/null && echo '✅ تم التنظيف'" ;;
        4) connect_vps "du -ah / 2>/dev/null | sort -rh | head -10" ;;
    esac
}

# فحص الأمان
security_check() {
    echo -e "${BLUE}=== فحص الأمان ===${NC}"
    connect_vps << 'EOF'
        echo "=== محاولات تسجيل دخول فاشلة ==="
        grep "Failed password" /var/log/auth.log 2>/dev/null | tail -20 | wc -l | awk '{print "عدد المحاولات: " $1}'
        echo ""
        echo "=== آخر تسجيلات الدخول ==="
        last | head -10
        echo ""
        echo "=== المستخدمون الحاليون ==="
        who
        echo ""
        echo "=== المنافذ المفتوحة ==="
        netstat -tlnp | grep LISTEN
EOF
}

# إدارة قواعد البيانات
manage_databases() {
    echo -e "${BLUE}=== إدارة قواعد البيانات ===${NC}"
    echo "1) عرض قواعد البيانات"
    echo "2) إنشاء نسخة احتياطية"
    echo "3) استعادة نسخة احتياطية"
    read -p "اختر: " choice
    
    case $choice in
        1) connect_vps "mysql -e 'SHOW DATABASES;'" 2>/dev/null || echo "MySQL غير متاح" ;;
        2) 
            read -p "اسم قاعدة البيانات: " dbname
            connect_vps "mysqldump $dbname > /tmp/${dbname}_backup_$(date +%Y%m%d).sql && echo '✅ تم النسخ الاحتياطي'"
            ;;
        3) echo "استخدم: mysql -u root -p database_name < backup_file.sql" ;;
    esac
}

# عرض السجلات
view_logs() {
    echo -e "${BLUE}=== السجلات ===${NC}"
    echo "1) سجلات Apache"
    echo "2) سجلات النظام"
    echo "3) سجلات الأمان"
    echo "4) سجلات الأخطاء"
    read -p "اختر: " choice
    
    case $choice in
        1) connect_vps "tail -50 /var/log/apache2/error.log 2>/dev/null || tail -50 /var/log/httpd/error_log" ;;
        2) connect_vps "journalctl -n 50 --no-pager" ;;
        3) connect_vps "tail -50 /var/log/auth.log" ;;
        4) connect_vps "tail -50 /var/log/syslog" ;;
    esac
}

# الحلقة الرئيسية
while true; do
    show_menu
    read -p "اختر رقم الإجراء: " choice
    
    case $choice in
        1) connect_vps ;;
        2) ./vps-status.sh ;;
        3) ./vps-monitor.sh ;;
        4) manage_services ;;
        5) manage_files ;;
        6) ./vps-backup.sh ;;
        7) connect_vps "cat /etc/passwd | grep -v nologin" ;;
        8) security_check ;;
        9) manage_databases ;;
        10) view_logs ;;
        11) ./setup-ssh-keys.sh ;;
        12) connect_vps "uname -a && uptime && free -h && df -h" ;;
        0) echo -e "${GREEN}وداعاً!${NC}"; exit 0 ;;
        *) echo -e "${RED}❌ خيار غير صحيح${NC}"; sleep 2 ;;
    esac
    
    if [ "$choice" != "0" ]; then
        echo ""
        read -p "اضغط Enter للمتابعة..."
    fi
done
