#!/bin/bash
# سكريبت فحص حالة VPS Hostinger
# ===============================

VPS_HOST="147.93.120.99"
VPS_USER="root"
VPS_PASSWORD="9'hG8lV1RCU)sesnQ3hA"

# التحقق من وجود sshpass
if ! command -v sshpass &> /dev/null; then
    echo "جارٍ تثبيت sshpass..."
    sudo apt-get update && sudo apt-get install -y sshpass 2>/dev/null || {
        echo "خطأ: لا يمكن تثبيت sshpass. يرجى تثبيته يدوياً."
        exit 1
    }
fi

echo "=========================================="
echo "  تقرير حالة VPS Hostinger"
echo "=========================================="
echo ""

# فحص شامل للحالة
sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 "$VPS_USER@$VPS_HOST" << 'EOF'
    echo "=== معلومات النظام ==="
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Load Average: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
    echo ""
    
    echo "=== استخدام الذاكرة ==="
    free -h
    echo ""
    
    echo "=== استخدام القرص ==="
    df -h | grep -E '^/dev|Filesystem'
    echo ""
    
    echo "=== استخدام المعالج ==="
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU Idle: " 100 - $1"%"}'
    echo ""
    
    echo "=== الخدمات الرئيسية ==="
    echo "Apache: $(systemctl is-active httpd 2>/dev/null || echo 'غير متاح')"
    echo "cPanel: $(systemctl is-active cpanel 2>/dev/null || echo 'غير متاح')"
    echo "SSH: $(systemctl is-active sshd 2>/dev/null || echo 'غير متاح')"
    echo ""
    
    echo "=== المنافذ المفتوحة ==="
    netstat -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | sort -u | head -10
    echo ""
    
    echo "=== آخر تسجيلات الدخول ==="
    last | head -3
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ تم فحص الحالة بنجاح"
else
    echo ""
    echo "❌ فشل الاتصال بالخادم"
    exit 1
fi
