#!/bin/bash

################################################################################
# Backup Script - سكريبت النسخ الاحتياطي
# Supreme Agent - Backup Utility
#
# المؤلف / Author: wasalstor-web
# التاريخ / Date: 2025-10-20
################################################################################

set -e

# الألوان / Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║    Supreme Agent - Backup / النسخ الاحتياطي       ║
╚═══════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# دالة للطباعة / Print function
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_step() {
    echo -e "${BLUE}➜ $1${NC}"
}

# الانتقال إلى مجلد المشروع / Navigate to project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# إنشاء اسم النسخة الاحتياطية / Create backup name
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/supreme-agent-backup-$TIMESTAMP"
BACKUP_ARCHIVE="supreme-agent-backup-$TIMESTAMP.tar.gz"

print_info "مجلد المشروع / Project directory: $PROJECT_DIR"
print_info "مجلد النسخة الاحتياطية / Backup directory: $BACKUP_DIR"
echo

# إنشاء مجلد النسخة الاحتياطية / Create backup directory
print_step "إنشاء مجلد النسخة الاحتياطية / Creating backup directory..."
mkdir -p "$BACKUP_DIR"
print_success "تم إنشاء المجلد / Directory created"
echo

# 1. نسخ الإعدادات / Backup configurations
print_step "[1/6] نسخ الإعدادات / Backing up configurations..."
mkdir -p "$BACKUP_DIR/config"

# نسخ ملفات الإعدادات / Copy configuration files
if [ -f "config/settings.json" ]; then
    cp config/settings.json "$BACKUP_DIR/config/"
    print_success "settings.json"
fi

if [ -f ".env" ]; then
    cp .env "$BACKUP_DIR/config/"
    print_success ".env"
fi

if [ -f ".env.example" ]; then
    cp .env.example "$BACKUP_DIR/config/"
    print_success ".env.example"
fi

echo

# 2. نسخ النماذج المخصصة / Backup custom models
print_step "[2/6] نسخ النماذج المخصصة / Backing up custom models..."
mkdir -p "$BACKUP_DIR/models"

if [ -d "models" ]; then
    cp -r models/* "$BACKUP_DIR/models/" 2>/dev/null || true
    print_success "تم نسخ النماذج / Models backed up"
else
    print_info "لا توجد نماذج مخصصة / No custom models"
fi

echo

# 3. نسخ السجلات / Backup logs
print_step "[3/6] نسخ السجلات / Backing up logs..."
mkdir -p "$BACKUP_DIR/logs"

# نسخ سجلات Supreme Agent / Copy Supreme Agent logs
if [ -f "supreme_agent.log" ]; then
    cp supreme_agent.log "$BACKUP_DIR/logs/"
    print_success "supreme_agent.log"
fi

# نسخ سجلات API / Copy API logs
if [ -f "/tmp/supreme-api.log" ]; then
    cp /tmp/supreme-api.log "$BACKUP_DIR/logs/"
    print_success "API logs"
fi

# نسخ سجلات Web / Copy Web logs
if [ -f "/tmp/supreme-web.log" ]; then
    cp /tmp/supreme-web.log "$BACKUP_DIR/logs/"
    print_success "Web logs"
fi

echo

# 4. نسخ البيانات / Backup data
print_step "[4/6] نسخ البيانات / Backing up data..."
mkdir -p "$BACKUP_DIR/data"

# نسخ سجل المحادثات / Copy conversation history
if [ -f "conversation_history.json" ]; then
    cp conversation_history.json "$BACKUP_DIR/data/"
    print_success "conversation_history.json"
fi

echo

# 5. نسخ معلومات النماذج من Ollama / Backup Ollama model info
print_step "[5/6] نسخ معلومات النماذج / Backing up model information..."

if command -v ollama &> /dev/null; then
    # حفظ قائمة النماذج / Save model list
    ollama list > "$BACKUP_DIR/ollama_models.txt" 2>/dev/null || true
    print_success "قائمة النماذج / Model list saved"
    
    # حفظ معلومات supreme-executor / Save supreme-executor info
    ollama show supreme-executor > "$BACKUP_DIR/supreme-executor-info.txt" 2>/dev/null || true
else
    print_info "Ollama غير متوفر / Ollama not available"
fi

echo

# 6. إنشاء معلومات النسخة الاحتياطية / Create backup info
print_step "[6/6] إنشاء معلومات النسخة الاحتياطية / Creating backup information..."

cat > "$BACKUP_DIR/backup_info.txt" << EOF
Supreme Agent Backup Information
النسخة الاحتياطية للوكيل الأعلى

التاريخ / Date: $(date)
الوقت / Time: $(date +%H:%M:%S)
المجلد / Directory: $PROJECT_DIR
المستخدم / User: $(whoami)
النظام / System: $(uname -s)
الإصدار / Version: 1.0.0

الملفات المحفوظة / Backed up files:
- config/settings.json
- .env
- models/Modelfile
- logs/
- conversation_history.json
- ollama models list

الاستعادة / Restore:
1. Extract archive: tar -xzf $BACKUP_ARCHIVE
2. Copy files back to project
3. Restart services
EOF

print_success "تم إنشاء معلومات النسخة / Backup info created"
echo

# ضغط النسخة الاحتياطية / Compress backup
print_step "ضغط النسخة الاحتياطية / Compressing backup..."

cd /tmp
tar -czf "$BACKUP_ARCHIVE" "$(basename "$BACKUP_DIR")"

BACKUP_SIZE=$(du -h "$BACKUP_ARCHIVE" | cut -f1)
print_success "تم الضغط / Compressed: $BACKUP_SIZE"
echo

# حذف المجلد المؤقت / Remove temporary directory
rm -rf "$BACKUP_DIR"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  النسخ الاحتياطي مكتمل! / Backup Complete!      ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

cat << EOF
${YELLOW}معلومات النسخة الاحتياطية / Backup Information:${NC}

  ${BLUE}الملف / File:${NC}
    /tmp/$BACKUP_ARCHIVE
    
  ${BLUE}الحجم / Size:${NC}
    $BACKUP_SIZE
    
  ${BLUE}المحتويات / Contents:${NC}
    - Configuration files / ملفات الإعدادات
    - Custom models / النماذج المخصصة
    - Logs / السجلات
    - Data / البيانات
    - Model information / معلومات النماذج

${YELLOW}الاستعادة / Restore:${NC}

  ${BLUE}# استخراج الملفات / Extract files${NC}
  tar -xzf /tmp/$BACKUP_ARCHIVE -C /tmp
  
  ${BLUE}# نسخ الملفات / Copy files${NC}
  cp -r /tmp/supreme-agent-backup-$TIMESTAMP/config/* $PROJECT_DIR/config/
  cp -r /tmp/supreme-agent-backup-$TIMESTAMP/models/* $PROJECT_DIR/models/
  cp /tmp/supreme-agent-backup-$TIMESTAMP/data/* $PROJECT_DIR/
  
  ${BLUE}# إعادة تشغيل الخدمات / Restart services${NC}
  ./scripts/quick-start.sh

${YELLOW}نقل النسخة الاحتياطية / Move Backup:${NC}

  ${BLUE}# إلى مجلد المشروع / To project directory${NC}
  mv /tmp/$BACKUP_ARCHIVE $PROJECT_DIR/
  
  ${BLUE}# إلى مكان آمن / To safe location${NC}
  mv /tmp/$BACKUP_ARCHIVE ~/backups/

${GREEN}تم حفظ النسخة الاحتياطية بنجاح! 💾${NC}
${GREEN}Backup saved successfully! 💾${NC}
EOF
