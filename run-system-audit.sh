#!/bin/bash

# نظام فحص شامل للذكاء الاصطناعي
# Full AI System Audit Tool

# الألوان
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # لا لون

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}🔍 نظام فحص شامل للذكاء الاصطناعي${NC}"
echo -e "${BLUE}🔍 Full AI System Audit Tool${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# التحقق من Python
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 غير مثبت / Python 3 not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Python 3 موجود / Python 3 found${NC}"

# التحقق من pip
if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
    echo -e "${RED}❌ pip غير مثبت / pip not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ pip موجود / pip found${NC}"

# تثبيت المتطلبات إذا لزم الأمر
echo -e "\n${YELLOW}📦 التحقق من المتطلبات / Checking requirements...${NC}"

# قائمة المكتبات المطلوبة
REQUIRED_PACKAGES=(
    "psutil"
    "httpx"
    "aiohttp"
)

MISSING_PACKAGES=()

for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! python3 -c "import $package" &> /dev/null; then
        MISSING_PACKAGES+=("$package")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️ بعض المكتبات مفقودة / Some packages are missing${NC}"
    echo -e "${YELLOW}📥 جاري التثبيت / Installing: ${MISSING_PACKAGES[*]}${NC}"
    
    if command -v pip3 &> /dev/null; then
        pip3 install ${MISSING_PACKAGES[@]} --quiet
    else
        pip install ${MISSING_PACKAGES[@]} --quiet
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ تم تثبيت المكتبات بنجاح / Packages installed successfully${NC}"
    else
        echo -e "${RED}❌ فشل تثبيت المكتبات / Failed to install packages${NC}"
        echo -e "${YELLOW}⚠️ سيتم محاولة تشغيل الفحص على أي حال...${NC}"
    fi
else
    echo -e "${GREEN}✓ جميع المكتبات موجودة / All packages present${NC}"
fi

# تشغيل الفحص
echo -e "\n${BLUE}🚀 بدء الفحص الشامل / Starting audit...${NC}\n"

python3 system_audit.py

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "\n${GREEN}✅ الفحص اكتمل بنجاح / Audit completed successfully${NC}"
else
    echo -e "\n${RED}❌ حدث خطأ في الفحص / Audit failed with error code: $EXIT_CODE${NC}"
fi

exit $EXIT_CODE
