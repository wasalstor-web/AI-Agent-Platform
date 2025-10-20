#!/bin/bash

# Variables
DOMAIN="your_domain_here"
EMAIL="your_email_here"

# Pull code from GitHub repository
git pull origin main

# Setup Nginx
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure SSL with auto-renewal
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email

# Setup backups
mkdir -p ~/backups
tar -czf ~/backups/backup_$(date +%Y-%m-%d).tar.gz /path/to/your/application

# Configure monitoring
sudo apt install htop -y

# Messages in Arabic
echo "تم سحب الكود بنجاح."
echo "تم إعداد Nginx."
echo "تم تكوين SSL."
echo "تم إعداد النسخ الاحتياطي."
echo "تم إعداد المراقبة."