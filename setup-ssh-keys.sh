#!/bin/bash
# سكريبت إعداد SSH Keys للاتصال الآمن
# ======================================

VPS_HOST="147.93.120.99"
VPS_USER="root"
VPS_PASSWORD="9'hG8lV1RCU)sesnQ3hA"

# ألوان
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  إعداد SSH Keys للاتصال الآمن${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# التحقق من وجود sshpass
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}جارٍ تثبيت sshpass...${NC}"
    sudo apt-get update && sudo apt-get install -y sshpass
fi

# إنشاء مجلد .ssh إذا لم يكن موجوداً
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# التحقق من وجود SSH key
if [ ! -f ~/.ssh/id_rsa ]; then
    echo -e "${YELLOW}جارٍ إنشاء SSH key جديد...${NC}"
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -C "vps-hostinger-$(date +%Y%m%d)"
    echo -e "${GREEN}✅ تم إنشاء SSH key${NC}"
else
    echo -e "${GREEN}✅ SSH key موجود بالفعل${NC}"
fi

# نسخ المفتاح إلى الخادم
echo -e "${YELLOW}جارٍ نسخ المفتاح إلى الخادم...${NC}"
sshpass -p "$VPS_PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$VPS_USER@$VPS_HOST" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ تم نسخ المفتاح بنجاح${NC}"
    echo ""
    echo -e "${GREEN}يمكنك الآن الاتصال بدون كلمة مرور:${NC}"
    echo "ssh $VPS_USER@$VPS_HOST"
    echo ""
    echo -e "${YELLOW}ملاحظة: يُنصح بتعطيل تسجيل الدخول بكلمة المرور في الخادم${NC}"
else
    echo -e "${RED}❌ فشل نسخ المفتاح. جارٍ المحاولة يدوياً...${NC}"
    
    # محاولة يدوية
    PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
    sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$VPS_USER@$VPS_HOST" "
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        echo '$PUB_KEY' >> ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys
    "
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ تم إعداد المفتاح يدوياً${NC}"
    else
        echo -e "${RED}❌ فشل الإعداد${NC}"
        exit 1
    fi
fi

# اختبار الاتصال بدون كلمة مرور
echo -e "${YELLOW}جارٍ اختبار الاتصال...${NC}"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 "$VPS_USER@$VPS_HOST" "echo '✅ الاتصال ناجح بدون كلمة مرور'" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ الاتصال يعمل بدون كلمة مرور${NC}"
else
    echo -e "${YELLOW}⚠️  الاتصال لا يزال يتطلب كلمة مرور${NC}"
fi
