#!/bin/bash

################################################################################
# Final Deployment Script for Hostinger VPS
# User: wasalstor-web
# Timestamp: 2025-10-20 04:00:22
# Full automation for Hostinger VPS setup
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DEPLOY_USER="wasalstor-web"
DEPLOY_TIMESTAMP="2025-10-20 04:00:22"
PROJECT_NAME="AI-Agent-Platform"
DEPLOY_DIR="/var/www/${PROJECT_NAME}"
BACKUP_DIR="/var/backups/${PROJECT_NAME}"
LOG_DIR="/var/log/${PROJECT_NAME}"
NGINX_CONF="/etc/nginx/sites-available/${PROJECT_NAME}"
NGINX_ENABLED="/etc/nginx/sites-enabled/${PROJECT_NAME}"
DOMAIN=""  # To be set during setup
EMAIL=""   # To be set during setup

# Log file
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${LOG_DIR}/deployment_${TIMESTAMP}.log"

################################################################################
# Logging Functions
################################################################################

log() {
    local message="$1"
    echo -e "${CYAN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $message" | tee -a "$LOG_FILE"
}

log_success() {
    local message="$1"
    echo -e "${GREEN}✓ $message${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    local message="$1"
    echo -e "${RED}✗ $message${NC}" | tee -a "$LOG_FILE"
}

log_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠ $message${NC}" | tee -a "$LOG_FILE"
}

log_info() {
    local message="$1"
    echo -e "${BLUE}ℹ $message${NC}" | tee -a "$LOG_FILE"
}

################################################################################
# Utility Functions
################################################################################

check_root() {
    if [ "$EUID" -ne 0 ]; then 
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

create_directories() {
    log "Creating necessary directories..."
    mkdir -p "$DEPLOY_DIR"
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$LOG_DIR"
    chown -R www-data:www-data "$DEPLOY_DIR"
    chown -R www-data:www-data "$BACKUP_DIR"
    log_success "Directories created"
}

################################################################################
# System Update and Package Installation
################################################################################

install_dependencies() {
    log "Installing required packages..."
    
    # Update package list
    apt-get update -y >> "$LOG_FILE" 2>&1
    
    # Install required packages
    apt-get install -y \
        nginx \
        certbot \
        python3-certbot-nginx \
        git \
        curl \
        wget \
        rsync \
        cron \
        ufw \
        fail2ban \
        >> "$LOG_FILE" 2>&1
    
    log_success "Dependencies installed"
}

################################################################################
# Firewall Configuration
################################################################################

configure_firewall() {
    log "Configuring firewall..."
    
    # Enable UFW
    ufw --force enable >> "$LOG_FILE" 2>&1
    
    # Allow SSH, HTTP, and HTTPS
    ufw allow 22/tcp >> "$LOG_FILE" 2>&1
    ufw allow 80/tcp >> "$LOG_FILE" 2>&1
    ufw allow 443/tcp >> "$LOG_FILE" 2>&1
    
    # Reload UFW
    ufw reload >> "$LOG_FILE" 2>&1
    
    log_success "Firewall configured"
}

################################################################################
# Nginx Configuration
################################################################################

configure_nginx() {
    log "Configuring Nginx..."
    
    # Backup existing configuration if it exists
    if [ -f "$NGINX_CONF" ]; then
        cp "$NGINX_CONF" "${NGINX_CONF}.backup.${TIMESTAMP}"
        log_info "Existing Nginx config backed up"
    fi
    
    # Create Nginx configuration
    cat > "$NGINX_CONF" << EOF
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    
    root ${DEPLOY_DIR};
    index index.html index.htm;
    
    # Logging
    access_log ${LOG_DIR}/nginx_access.log;
    error_log ${LOG_DIR}/nginx_error.log;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript application/json;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # Cache static files
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
    
    # Enable site
    ln -sf "$NGINX_CONF" "$NGINX_ENABLED"
    
    # Test Nginx configuration
    nginx -t >> "$LOG_FILE" 2>&1
    
    # Reload Nginx
    systemctl reload nginx >> "$LOG_FILE" 2>&1
    
    log_success "Nginx configured"
}

################################################################################
# SSL Certificate Configuration
################################################################################

setup_ssl() {
    log "Setting up SSL certificate with Let's Encrypt..."
    
    # Check if domain is set
    if [ -z "$DOMAIN" ]; then
        log_error "Domain not set. Skipping SSL setup."
        return 1
    fi
    
    # Check if email is set
    if [ -z "$EMAIL" ]; then
        log_error "Email not set. Skipping SSL setup."
        return 1
    fi
    
    # Obtain SSL certificate
    certbot --nginx \
        -d "$DOMAIN" \
        -d "www.$DOMAIN" \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --redirect \
        >> "$LOG_FILE" 2>&1
    
    log_success "SSL certificate installed"
}

################################################################################
# Automatic SSL Renewal Configuration
################################################################################

setup_ssl_renewal() {
    log "Configuring automatic SSL renewal..."
    
    # Test renewal process
    certbot renew --dry-run >> "$LOG_FILE" 2>&1
    
    # Create renewal cron job (runs twice daily)
    CRON_JOB="0 0,12 * * * certbot renew --quiet --post-hook 'systemctl reload nginx' >> ${LOG_DIR}/ssl_renewal.log 2>&1"
    
    # Check if cron job already exists
    if ! crontab -l 2>/dev/null | grep -q "certbot renew"; then
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        log_success "SSL auto-renewal cron job configured"
    else
        log_info "SSL auto-renewal cron job already exists"
    fi
}

################################################################################
# Backup System Configuration
################################################################################

setup_backup_system() {
    log "Setting up backup system..."
    
    # Create backup script
    BACKUP_SCRIPT="/usr/local/bin/${PROJECT_NAME}-backup.sh"
    cat > "$BACKUP_SCRIPT" << 'EOF'
#!/bin/bash

# Backup Configuration
PROJECT_NAME="AI-Agent-Platform"
DEPLOY_DIR="/var/www/${PROJECT_NAME}"
BACKUP_DIR="/var/backups/${PROJECT_NAME}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"
LOG_FILE="/var/log/${PROJECT_NAME}/backup_${TIMESTAMP}.log"
RETENTION_DAYS=30

# Create backup
echo "[$(date)] Starting backup..." >> "$LOG_FILE"
tar -czf "$BACKUP_FILE" -C "$DEPLOY_DIR" . >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "[$(date)] Backup created successfully: $BACKUP_FILE" >> "$LOG_FILE"
    
    # Remove old backups
    find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete
    echo "[$(date)] Old backups cleaned (retention: ${RETENTION_DAYS} days)" >> "$LOG_FILE"
else
    echo "[$(date)] Backup failed!" >> "$LOG_FILE"
    exit 1
fi
EOF
    
    chmod +x "$BACKUP_SCRIPT"
    
    # Create daily backup cron job (runs at 2 AM)
    BACKUP_CRON="0 2 * * * $BACKUP_SCRIPT >> ${LOG_DIR}/backup_cron.log 2>&1"
    
    if ! crontab -l 2>/dev/null | grep -q "${PROJECT_NAME}-backup.sh"; then
        (crontab -l 2>/dev/null; echo "$BACKUP_CRON") | crontab -
        log_success "Backup system configured (daily at 2 AM, 30-day retention)"
    else
        log_info "Backup cron job already exists"
    fi
}

################################################################################
# Deployment Status Monitoring
################################################################################

setup_monitoring() {
    log "Setting up deployment status monitoring..."
    
    # Create monitoring script
    MONITOR_SCRIPT="/usr/local/bin/${PROJECT_NAME}-monitor.sh"
    cat > "$MONITOR_SCRIPT" << 'EOF'
#!/bin/bash

# Monitoring Configuration
PROJECT_NAME="AI-Agent-Platform"
DOMAIN="${DOMAIN:-localhost}"
LOG_FILE="/var/log/${PROJECT_NAME}/monitoring.log"
STATUS_FILE="/var/log/${PROJECT_NAME}/status.json"

# Check Nginx status
NGINX_STATUS=$(systemctl is-active nginx)

# Check SSL certificate expiry (if SSL is configured)
if [ -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    SSL_EXPIRY=$(openssl x509 -enddate -noout -in "/etc/letsencrypt/live/${DOMAIN}/cert.pem" 2>/dev/null | cut -d= -f2)
    SSL_DAYS_LEFT=$(( ($(date -d "$SSL_EXPIRY" +%s) - $(date +%s)) / 86400 ))
else
    SSL_EXPIRY="N/A"
    SSL_DAYS_LEFT="N/A"
fi

# Check disk usage
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Check website accessibility
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://${DOMAIN}" 2>/dev/null || echo "000")

# Create status JSON
cat > "$STATUS_FILE" << EOJ
{
    "timestamp": "$(date -Iseconds)",
    "nginx_status": "${NGINX_STATUS}",
    "ssl_expiry": "${SSL_EXPIRY}",
    "ssl_days_left": ${SSL_DAYS_LEFT},
    "disk_usage_percent": ${DISK_USAGE},
    "http_status": ${HTTP_STATUS},
    "deployment_healthy": $([ "$NGINX_STATUS" = "active" ] && [ "$HTTP_STATUS" = "200" ] && echo "true" || echo "false")
}
EOJ

# Log status
echo "[$(date)] Status: Nginx=${NGINX_STATUS}, HTTP=${HTTP_STATUS}, Disk=${DISK_USAGE}%, SSL_Days=${SSL_DAYS_LEFT}" >> "$LOG_FILE"

# Alert if issues detected
if [ "$NGINX_STATUS" != "active" ] || [ "$HTTP_STATUS" != "200" ]; then
    echo "[$(date)] ALERT: Service health check failed!" >> "$LOG_FILE"
fi

if [ "$SSL_DAYS_LEFT" != "N/A" ] && [ "$SSL_DAYS_LEFT" -lt 30 ]; then
    echo "[$(date)] WARNING: SSL certificate expires in ${SSL_DAYS_LEFT} days" >> "$LOG_FILE"
fi
EOF
    
    chmod +x "$MONITOR_SCRIPT"
    
    # Create monitoring cron job (runs every 15 minutes)
    MONITOR_CRON="*/15 * * * * $MONITOR_SCRIPT"
    
    if ! crontab -l 2>/dev/null | grep -q "${PROJECT_NAME}-monitor.sh"; then
        (crontab -l 2>/dev/null; echo "$MONITOR_CRON") | crontab -
        log_success "Monitoring system configured (checks every 15 minutes)"
    else
        log_info "Monitoring cron job already exists"
    fi
}

################################################################################
# Health Check
################################################################################

health_check() {
    log "Running health check..."
    
    # Check Nginx
    if systemctl is-active --quiet nginx; then
        log_success "Nginx is running"
    else
        log_error "Nginx is not running"
        return 1
    fi
    
    # Check SSL certificate (if domain is configured)
    if [ -n "$DOMAIN" ] && [ -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
        SSL_DAYS=$(( ($(date -d "$(openssl x509 -enddate -noout -in "/etc/letsencrypt/live/${DOMAIN}/cert.pem" 2>/dev/null | cut -d= -f2)" +%s) - $(date +%s)) / 86400 ))
        log_success "SSL certificate valid for $SSL_DAYS days"
    fi
    
    # Check disk space
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$DISK_USAGE" -lt 90 ]; then
        log_success "Disk usage: ${DISK_USAGE}%"
    else
        log_warning "Disk usage high: ${DISK_USAGE}%"
    fi
    
    # Check backup directory
    if [ -d "$BACKUP_DIR" ]; then
        BACKUP_COUNT=$(find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f | wc -l)
        log_success "Backups available: $BACKUP_COUNT"
    fi
}

################################################################################
# Deployment Report
################################################################################

generate_deployment_report() {
    log "Generating deployment report..."
    
    REPORT_FILE="${LOG_DIR}/deployment_report_${TIMESTAMP}.txt"
    
    cat > "$REPORT_FILE" << EOF
================================================================================
AI Agent Platform - Deployment Report
================================================================================

Deployment Information:
-----------------------
User:           ${DEPLOY_USER}
Timestamp:      ${DEPLOY_TIMESTAMP}
Execution Time: $(date '+%Y-%m-%d %H:%M:%S')
Project:        ${PROJECT_NAME}
Domain:         ${DOMAIN:-Not configured}

Directory Structure:
--------------------
Deploy Dir:     ${DEPLOY_DIR}
Backup Dir:     ${BACKUP_DIR}
Log Dir:        ${LOG_DIR}
Nginx Config:   ${NGINX_CONF}

System Status:
--------------
Nginx:          $(systemctl is-active nginx)
Certbot:        $(command -v certbot &> /dev/null && echo "Installed" || echo "Not installed")
Firewall:       $(ufw status | head -1)
Disk Usage:     $(df -h / | awk 'NR==2 {print $5}')

Automated Tasks Configured:
---------------------------
✓ SSL Auto-renewal (twice daily)
✓ Daily Backups (2 AM, 30-day retention)
✓ Status Monitoring (every 15 minutes)

SSL Certificate:
----------------
$(if [ -n "$DOMAIN" ] && [ -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    echo "Status: Configured"
    echo "Domain: ${DOMAIN}"
    echo "Expiry: $(openssl x509 -enddate -noout -in "/etc/letsencrypt/live/${DOMAIN}/cert.pem" 2>/dev/null | cut -d= -f2)"
else
    echo "Status: Not configured"
fi)

Backup System:
--------------
Backup Script:  /usr/local/bin/${PROJECT_NAME}-backup.sh
Backup Dir:     ${BACKUP_DIR}
Schedule:       Daily at 2 AM
Retention:      30 days

Monitoring:
-----------
Monitor Script: /usr/local/bin/${PROJECT_NAME}-monitor.sh
Status File:    ${LOG_DIR}/status.json
Schedule:       Every 15 minutes

Log Files:
----------
Deployment:     ${LOG_FILE}
Nginx Access:   ${LOG_DIR}/nginx_access.log
Nginx Error:    ${LOG_DIR}/nginx_error.log
Backups:        ${LOG_DIR}/backup_cron.log
Monitoring:     ${LOG_DIR}/monitoring.log
SSL Renewal:    ${LOG_DIR}/ssl_renewal.log

Next Steps:
-----------
1. Deploy your application files to: ${DEPLOY_DIR}
2. Update DNS records to point to this server
3. Monitor status at: ${LOG_DIR}/status.json
4. Check logs regularly in: ${LOG_DIR}/

================================================================================
Deployment completed successfully!
================================================================================
EOF
    
    cat "$REPORT_FILE"
    log_success "Deployment report saved to: $REPORT_FILE"
}

################################################################################
# Main Deployment Process
################################################################################

main() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     AI Agent Platform - Final Deployment Script         ║${NC}"
    echo -e "${BLUE}║     User: ${DEPLOY_USER}                              ║${NC}"
    echo -e "${BLUE}║     Timestamp: ${DEPLOY_TIMESTAMP}                   ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Check root privileges
    check_root
    
    # Get domain and email if not set
    if [ -z "$DOMAIN" ]; then
        read -p "Enter your domain name (e.g., example.com): " DOMAIN
    fi
    
    if [ -z "$EMAIL" ]; then
        read -p "Enter your email for SSL notifications: " EMAIL
    fi
    
    # Create log directory first
    mkdir -p "$LOG_DIR"
    touch "$LOG_FILE"
    
    log "Starting deployment process..."
    log_info "Deploy User: $DEPLOY_USER"
    log_info "Deploy Timestamp: $DEPLOY_TIMESTAMP"
    log_info "Domain: $DOMAIN"
    
    # Step 1: Create directories
    create_directories
    
    # Step 2: Install dependencies
    install_dependencies
    
    # Step 3: Configure firewall
    configure_firewall
    
    # Step 4: Configure Nginx
    configure_nginx
    
    # Step 5: Setup SSL
    setup_ssl
    
    # Step 6: Configure SSL auto-renewal
    setup_ssl_renewal
    
    # Step 7: Setup backup system
    setup_backup_system
    
    # Step 8: Setup monitoring
    setup_monitoring
    
    # Step 9: Health check
    health_check
    
    # Step 10: Generate report
    generate_deployment_report
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          Deployment Completed Successfully!              ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log_success "Full deployment completed!"
}

# Run main function
main "$@"
