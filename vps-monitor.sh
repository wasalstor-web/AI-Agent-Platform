#!/bin/bash
# سكريبت مراقبة متقدم لـ VPS
# ============================

VPS_HOST="147.93.120.99"
VPS_USER="root"
VPS_PASSWORD="9'hG8lV1RCU)sesnQ3hA"

# ألوان
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# دالة للاتصال
connect_vps() {
    if [ -f ~/.ssh/id_rsa ] && ssh -o ConnectTimeout=3 -o BatchMode=yes "$VPS_USER@$VPS_HOST" exit 2>/dev/null; then
        ssh "$VPS_USER@$VPS_HOST" "$@"
    else
        if ! command -v sshpass &> /dev/null; then
            echo -e "${RED}❌ sshpass غير مثبت${NC}"
            exit 1
        fi
        sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$VPS_USER@$VPS_HOST" "$@"
    fi
}

# دالة فحص الحالة
check_status() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  مراقبة VPS Hostinger${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    connect_vps << 'EOF'
        # معلومات النظام
        echo -e "\033[0;34m=== معلومات النظام ===\033[0m"
        echo "Hostname: $(hostname)"
        echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
        echo "Kernel: $(uname -r)"
        echo "Uptime: $(uptime -p)"
        echo "Load Average: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
        echo ""
        
        # الذاكرة
        echo -e "\033[0;34m=== الذاكرة ===\033[0m"
        free -h | awk 'NR==1{printf "%-10s %10s %10s %10s %10s\n", $1, $2, $3, $4, $5} NR==2{printf "%-10s %10s %10s %10s %10s\n", $1, $2, $3, $4, $5}'
        MEM_USED=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
        echo "استخدام الذاكرة: ${MEM_USED}%"
        if (( $(echo "$MEM_USED > 90" | bc -l) )); then
            echo -e "\033[0;31m⚠️  تحذير: استخدام الذاكرة عالي\033[0m"
        fi
        echo ""
        
        # القرص
        echo -e "\033[0;34m=== القرص ===\033[0m"
        df -h / | awk 'NR==1{print} NR==2{print; if($5+0 > 90) print "\033[0;31m⚠️  تحذير: استخدام القرص عالي\033[0m"}'
        echo ""
        
        # المعالج
        echo -e "\033[0;34m=== المعالج ===\033[0m"
        CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
        echo "استخدام المعالج: ${CPU_USAGE}%"
        if (( $(echo "$CPU_USAGE > 90" | bc -l) )); then
            echo -e "\033[0;31m⚠️  تحذير: استخدام المعالج عالي\033[0m"
        fi
        echo ""
        
        # أعلى العمليات
        echo -e "\033[0;34m=== أعلى 5 عمليات (CPU) ===\033[0m"
        ps aux --sort=-%cpu | head -6 | awk '{printf "%-8s %6.1f%% %s\n", $1, $3, $11}'
        echo ""
        
        # الخدمات
        echo -e "\033[0;34m=== حالة الخدمات ===\033[0m"
        SERVICES=("httpd" "cpanel" "sshd" "dovecot" "exim")
        for service in "${SERVICES[@]}"; do
            STATUS=$(systemctl is-active "$service" 2>/dev/null || echo "غير متاح")
            if [ "$STATUS" = "active" ]; then
                echo -e "✅ $service: $STATUS"
            else
                echo -e "❌ $service: $STATUS"
            fi
        done
        echo ""
        
        # الشبكة
        echo -e "\033[0;34m=== الاتصالات النشطة ===\033[0m"
        CONNECTIONS=$(netstat -an | grep ESTABLISHED | wc -l)
        echo "الاتصالات النشطة: $CONNECTIONS"
        echo ""
        
        # المنافذ المفتوحة
        echo -e "\033[0;34m=== المنافذ المفتوحة ===\033[0m"
        netstat -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | cut -d: -f2 | sort -u | head -10
        echo ""
        
        # آخر تحديث
        echo -e "\033[0;34m=== آخر تحديث ===\033[0m"
        if [ -f /var/log/apt/history.log ]; then
            grep "Start-Date" /var/log/apt/history.log | tail -1
        fi
        echo ""
        
        # تحذيرات
        echo -e "\033[0;34m=== تحذيرات ===\033[0m"
        if [ -f /var/log/auth.log ]; then
            FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log 2>/dev/null | tail -20 | wc -l)
            if [ "$FAILED_LOGINS" -gt 0 ]; then
                echo -e "\033[0;31m⚠️  محاولات تسجيل دخول فاشلة: $FAILED_LOGINS\033[0m"
            fi
        fi
EOF
}

# دالة المراقبة المستمرة
monitor_continuous() {
    while true; do
        clear
        check_status
        echo -e "${YELLOW}جارٍ التحديث... (Ctrl+C للإيقاف)${NC}"
        sleep 5
    done
}

# القائمة الرئيسية
case "${1:-}" in
    --continuous|-c)
        monitor_continuous
        ;;
    --help|-h)
        echo "الاستخدام: $0 [خيارات]"
        echo ""
        echo "خيارات:"
        echo "  (بدون خيارات)  عرض حالة واحدة"
        echo "  -c, --continuous  مراقبة مستمرة (كل 5 ثوان)"
        echo "  -h, --help        عرض هذه المساعدة"
        ;;
    *)
        check_status
        ;;
esac
