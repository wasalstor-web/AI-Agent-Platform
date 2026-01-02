#!/bin/bash
# أوامر سريعة لـ VPS
# ===================

VPS_HOST="147.93.120.99"
VPS_USER="root"

# دالة الاتصال
connect_vps() {
    if [ -f ~/.ssh/id_rsa ] && ssh -o ConnectTimeout=3 -o BatchMode=yes "$VPS_USER@$VPS_HOST" exit 2>/dev/null; then
        ssh "$VPS_USER@$VPS_HOST" "$@"
    else
        if [ -f vps-connection-info.txt ]; then
            VPS_PASSWORD=$(grep "^PASSWORD=" vps-connection-info.txt | cut -d'=' -f2)
            sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$VPS_USER@$VPS_HOST" "$@"
        else
            echo "❌ لا توجد معلومات اتصال"
            exit 1
        fi
    fi
}

# أوامر سريعة
case "$1" in
    status|s)
        connect_vps "uptime && free -h && df -h"
        ;;
    top|t)
        connect_vps "top -bn1 | head -20"
        ;;
    logs|l)
        connect_vps "tail -50 /var/log/apache2/error.log 2>/dev/null || tail -50 /var/log/httpd/error_log"
        ;;
    services|svc)
        connect_vps "systemctl list-units --type=service --state=running | head -20"
        ;;
    disk|d)
        connect_vps "df -h"
        ;;
    mem|m)
        connect_vps "free -h"
        ;;
    connect|c)
        connect_vps
        ;;
    *)
        echo "الاستخدام: $0 [command]"
        echo ""
        echo "الأوامر السريعة:"
        echo "  status, s    - فحص الحالة"
        echo "  top, t       - عرض العمليات"
        echo "  logs, l      - عرض السجلات"
        echo "  services, svc - الخدمات"
        echo "  disk, d      - استخدام القرص"
        echo "  mem, m       - استخدام الذاكرة"
        echo "  connect, c   - اتصال SSH"
        ;;
esac
