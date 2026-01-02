#!/bin/bash
# سكريبت النسخ الاحتياطي لـ VPS
# ===============================

VPS_HOST="147.93.120.99"
VPS_USER="root"
VPS_PASSWORD="9'hG8lV1RCU)sesnQ3hA"

# ألوان
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

# دالة الاتصال
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

# دالة النسخ
scp_vps() {
    if [ -f ~/.ssh/id_rsa ] && ssh -o ConnectTimeout=3 -o BatchMode=yes "$VPS_USER@$VPS_HOST" exit 2>/dev/null; then
        scp "$@"
    else
        if ! command -v sshpass &> /dev/null; then
            echo -e "${RED}❌ sshpass غير مثبت${NC}"
            exit 1
        fi
        sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@"
    fi
}

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  نسخ احتياطي لـ VPS Hostinger${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# إنشاء مجلد النسخ الاحتياطي
mkdir -p "$BACKUP_DIR"

# القائمة
echo -e "${GREEN}اختر نوع النسخ الاحتياطي:${NC}"
echo "1) نسخ احتياطي للملفات المهمة"
echo "2) نسخ احتياطي لقواعد البيانات"
echo "3) نسخ احتياطي كامل (ملفات + قواعد بيانات)"
echo "4) نسخ احتياطي للإعدادات"
echo "5) عرض قائمة الملفات المهمة"
echo ""
read -p "اختر (1-5): " choice

case $choice in
    1)
        echo -e "${YELLOW}جارٍ نسخ الملفات المهمة...${NC}"
        connect_vps "tar -czf /tmp/files_backup_$DATE.tar.gz /home /var/www /etc 2>/dev/null"
        scp_vps "$VPS_USER@$VPS_HOST:/tmp/files_backup_$DATE.tar.gz" "$BACKUP_DIR/"
        connect_vps "rm /tmp/files_backup_$DATE.tar.gz"
        echo -e "${GREEN}✅ تم النسخ الاحتياطي: $BACKUP_DIR/files_backup_$DATE.tar.gz${NC}"
        ;;
    2)
        echo -e "${YELLOW}جارٍ نسخ قواعد البيانات...${NC}"
        connect_vps << 'EOF'
            # إنشاء نسخة احتياطية لجميع قواعد البيانات
            mysqldump --all-databases > /tmp/databases_backup_$(date +%Y%m%d_%H%M%S).sql 2>/dev/null || {
                echo "⚠️  MySQL غير متاح، جارٍ البحث عن قواعد بيانات أخرى..."
            }
EOF
        DB_BACKUP=$(connect_vps "ls -t /tmp/databases_backup_*.sql 2>/dev/null | head -1")
        if [ -n "$DB_BACKUP" ]; then
            scp_vps "$VPS_USER@$VPS_HOST:$DB_BACKUP" "$BACKUP_DIR/"
            connect_vps "rm $DB_BACKUP"
            echo -e "${GREEN}✅ تم النسخ الاحتياطي لقواعد البيانات${NC}"
        else
            echo -e "${YELLOW}⚠️  لم يتم العثور على قواعد بيانات${NC}"
        fi
        ;;
    3)
        echo -e "${YELLOW}جارٍ النسخ الاحتياطي الكامل...${NC}"
        # ملفات
        connect_vps "tar -czf /tmp/files_backup_$DATE.tar.gz /home /var/www /etc 2>/dev/null"
        scp_vps "$VPS_USER@$VPS_HOST:/tmp/files_backup_$DATE.tar.gz" "$BACKUP_DIR/"
        connect_vps "rm /tmp/files_backup_$DATE.tar.gz"
        
        # قواعد بيانات
        connect_vps "mysqldump --all-databases > /tmp/databases_backup_$DATE.sql 2>/dev/null"
        if [ $? -eq 0 ]; then
            scp_vps "$VPS_USER@$VPS_HOST:/tmp/databases_backup_$DATE.sql" "$BACKUP_DIR/"
            connect_vps "rm /tmp/databases_backup_$DATE.sql"
        fi
        
        echo -e "${GREEN}✅ تم النسخ الاحتياطي الكامل${NC}"
        ;;
    4)
        echo -e "${YELLOW}جارٍ نسخ الإعدادات...${NC}"
        connect_vps "tar -czf /tmp/config_backup_$DATE.tar.gz /etc/ssh /etc/apache2 /etc/php* /etc/mysql 2>/dev/null"
        scp_vps "$VPS_USER@$VPS_HOST:/tmp/config_backup_$DATE.tar.gz" "$BACKUP_DIR/"
        connect_vps "rm /tmp/config_backup_$DATE.tar.gz"
        echo -e "${GREEN}✅ تم نسخ الإعدادات: $BACKUP_DIR/config_backup_$DATE.tar.gz${NC}"
        ;;
    5)
        echo -e "${BLUE}=== الملفات المهمة ===${NC}"
        connect_vps << 'EOF'
            echo "المجلدات المهمة:"
            echo "- /home (ملفات المستخدمين)"
            echo "- /var/www (مواقع الويب)"
            echo "- /etc (الإعدادات)"
            echo "- /opt (التطبيقات المثبتة)"
            echo ""
            echo "قواعد البيانات:"
            mysql -e "SHOW DATABASES;" 2>/dev/null || echo "MySQL غير متاح"
EOF
        ;;
    *)
        echo -e "${RED}❌ خيار غير صحيح${NC}"
        exit 1
        ;;
esac

# عرض حجم النسخ الاحتياطي
if [ -d "$BACKUP_DIR" ]; then
    echo ""
    echo -e "${BLUE}=== حجم النسخ الاحتياطي ===${NC}"
    du -sh "$BACKUP_DIR"/*
    echo ""
    echo -e "${YELLOW}💡 نصيحة: احفظ النسخ الاحتياطي في مكان آمن${NC}"
fi
