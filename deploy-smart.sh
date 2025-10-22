#!/bin/bash

# Default values
DOMAIN="tradd.space"
EMAIL="mubasatplatform@outlook.com"

# Show default values
echo "المعلومات الافتراضية المكتشفة:"
echo "النطاق: $DOMAIN"
echo "البريد: $EMAIL"
echo "اضغط Enter لاستخدام القيم الافتراضية أو أدخل قيم جديدة"

# Prompt for user input with defaults
read -p "Enter your domain (default: $DOMAIN): " user_domain
DOMAIN=${user_domain:-$DOMAIN}

read -p "Enter your email (default: $EMAIL): " user_email
EMAIL=${user_email:-$EMAIL}

# Rest of the script goes here...