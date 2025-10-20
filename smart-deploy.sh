#!/bin/bash

# Function to display the menu
display_menu() {
    echo "اختر خيارًا:"
    echo "1) التحقق من حالة النشر"
    echo "2) نشر تلقائي باستخدام git pull"
    echo "3) إعداد شهادة SSL باستخدام certbot"
    echo "4) تكوين webhooks على GitHub"
    echo "5) تكوين nginx"
    echo "6) نظام النسخ الاحتياطي"
    echo "7) مراقبة السجلات"
    echo "8) فحص الأداء"
    echo "9) فحص الأمان"
    echo "10) إدارة OpenWebUI"
    echo "11) العودة"
}

# Function to check deployment status
check_deployment() {
    echo "التحقق من حالة النشر..."
    echo "Checking deployment status..."
    echo ""
    
    # Check if VPS_HOST is configured
    if [ -z "$VPS_HOST" ]; then
        echo "⚠ لم يتم تكوين عنوان VPS"
        echo "⚠ VPS host not configured"
        echo ""
        read -p "أدخل عنوان VPS / Enter VPS host: " VPS_HOST
        export VPS_HOST
    fi
    
    # Check if deploy.sh exists and is executable
    if [ -f "./deploy.sh" ]; then
        # Make it executable if needed
        chmod +x ./deploy.sh
        
        # Run the comprehensive VPS check
        ./deploy.sh
    else
        echo "✗ ملف deploy.sh غير موجود"
        echo "✗ deploy.sh script not found"
        echo ""
        echo "يرجى التأكد من وجود ملف deploy.sh في نفس المجلد"
        echo "Please ensure deploy.sh exists in the same directory"
    fi
    
    echo ""
    read -p "اضغط Enter للمتابعة / Press Enter to continue..."
}

# Function for automated git pull deployment
git_pull_deployment() {
    echo "تنفيذ git pull للنشر..."
    git pull origin main || { echo "فشل في تنفيذ git pull"; exit 1; }
}

# Function for SSL certificate setup
setup_ssl() {
    echo "إعداد شهادة SSL باستخدام certbot..."
    sudo certbot --nginx || { echo "فشل في إعداد شهادة SSL"; exit 1; }
}

# Function for GitHub webhooks configuration
configure_webhooks() {
    echo "تكوين webhooks على GitHub..."
    # Add your webhook configuration commands here
}

# Function for nginx configuration
configure_nginx() {
    echo "تكوين nginx..."
    # Add your nginx configuration commands here
}

# Function for backup system
setup_backup() {
    echo "إعداد نظام النسخ الاحتياطي..."
    # Add your backup commands here
}

# Function for log monitoring
monitor_logs() {
    echo "مراقبة السجلات..."
    # Add your log monitoring commands here
}

# Function for performance checks
performance_checks() {
    echo "فحص الأداء..."
    # Add your performance check commands here
}

# Function for security scanning
security_scanning() {
    echo "فحص الأمان..."
    # Add your security scanning commands here
}

# Function for rollback capability
rollback() {
    echo "تنفيذ عملية الرجوع..."
    # Add your rollback commands here
}

# Function for OpenWebUI management
manage_openwebui() {
    echo "إدارة OpenWebUI / Managing OpenWebUI..."
    echo ""
    
    # Check if setup-openwebui.sh exists
    if [ -f "./setup-openwebui.sh" ]; then
        # Make it executable if needed
        chmod +x ./setup-openwebui.sh
        
        # Run the OpenWebUI management script
        ./setup-openwebui.sh
    else
        echo "✗ ملف setup-openwebui.sh غير موجود"
        echo "✗ setup-openwebui.sh script not found"
        echo ""
        echo "يرجى التأكد من وجود ملف setup-openwebui.sh في نفس المجلد"
        echo "Please ensure setup-openwebui.sh exists in the same directory"
    fi
    
    echo ""
    read -p "اضغط Enter للمتابعة / Press Enter to continue..."
}

# Main program loop
while true; do
    display_menu
    read -p "اختر خيارك: " option
    case $option in
        1) check_deployment ;; 
        2) git_pull_deployment ;; 
        3) setup_ssl ;; 
        4) configure_webhooks ;; 
        5) configure_nginx ;; 
        6) setup_backup ;; 
        7) monitor_logs ;; 
        8) performance_checks ;; 
        9) security_scanning ;; 
        10) manage_openwebui ;;
        11) echo "إنهاء... / Exiting..."; exit 0 ;; 
        *) echo "خيار غير صالح. حاول مرة أخرى." ;;
    esac
done
