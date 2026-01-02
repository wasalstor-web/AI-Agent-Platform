#!/bin/bash
# سكريبت الاتصال السريع بـ VPS Hostinger (محسّن)
# ================================================

# معلومات الاتصال
VPS_HOST="147.93.120.99"
VPS_USER="root"
VPS_PASSWORD="9'hG8lV1RCU)sesnQ3hA"

# دالة الاتصال الذكية (تستخدم SSH keys إن وجدت)
connect_vps() {
    if [ -f ~/.ssh/id_rsa ] && ssh -o ConnectTimeout=3 -o BatchMode=yes "$VPS_USER@$VPS_HOST" exit 2>/dev/null; then
        ssh "$VPS_USER@$VPS_HOST" "$@"
    else
        if ! command -v sshpass &> /dev/null; then
            echo -e "${YELLOW}جارٍ تثبيت sshpass...${NC}"
            sudo apt-get update && sudo apt-get install -y sshpass
        fi
        sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$VPS_USER@$VPS_HOST" "$@"
    fi
}

# ألوان للواجهة
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  اتصال بـ VPS Hostinger${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# التحقق من وجود sshpass
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}جارٍ تثبيت sshpass...${NC}"
    sudo apt-get update && sudo apt-get install -y sshpass
fi

# عرض القائمة
echo -e "${GREEN}اختر الإجراء:${NC}"
echo "1) الاتصال بالخادم (SSH)"
echo "2) فحص حالة الخادم"
echo "3) فحص الموارد (RAM, Disk, CPU)"
echo "4) فحص الخدمات النشطة"
echo "5) عرض السجلات الأخيرة"
echo "6) تنفيذ أمر مخصص"
echo ""
read -p "اختر رقم الإجراء (1-6): " choice

case $choice in
    1)
        echo -e "${GREEN}جارٍ الاتصال بالخادم...${NC}"
        connect_vps
        ;;
    2)
        echo -e "${GREEN}فحص حالة الخادم...${NC}"
        connect_vps "
            echo '=== System Uptime ===' && uptime && 
            echo '' && echo '=== Disk Usage ===' && df -h && 
            echo '' && echo '=== Memory Usage ===' && free -h && 
            echo '' && echo '=== System Load ===' && cat /proc/loadavg
        "
        ;;
    3)
        echo -e "${GREEN}فحص الموارد...${NC}"
        connect_vps "
            echo '=== Memory ===' && free -h && 
            echo '' && echo '=== Disk ===' && df -h && 
            echo '' && echo '=== CPU ===' && top -bn1 | head -5
        "
        ;;
    4)
        echo -e "${GREEN}فحص الخدمات النشطة...${NC}"
        connect_vps "systemctl list-units --type=service --state=running | head -20"
        ;;
    5)
        echo -e "${GREEN}عرض السجلات الأخيرة...${NC}"
        connect_vps "
            echo '=== Recent Logins ===' && last | head -5 && 
            echo '' && echo '=== System Messages ===' && journalctl -n 20 --no-pager
        "
        ;;
    6)
        read -p "أدخل الأمر المراد تنفيذه: " custom_cmd
        echo -e "${GREEN}تنفيذ الأمر: $custom_cmd${NC}"
        connect_vps "$custom_cmd"
        ;;
    *)
        echo -e "${YELLOW}خيار غير صحيح${NC}"
        exit 1
        ;;
esac
