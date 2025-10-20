# Deployment Guide for AI-Agent-Platform

## Overview

This guide provides comprehensive instructions for deploying the AI-Agent-Platform to a Hostinger VPS using the automated deployment scripts.

## Prerequisites

### Server Requirements
- Ubuntu 20.04 LTS or later (or Debian-based Linux)
- Minimum 1GB RAM
- At least 10GB free disk space
- Root access (sudo privileges)
- Domain name pointing to your server IP

### Before You Begin
1. **DNS Configuration**: Ensure your domain's A record points to your VPS IP address
2. **SSH Access**: Verify you can SSH into your VPS
3. **Email Address**: Have an email ready for SSL certificate notifications

## Deployment Scripts

### 1. Final Deployment Script (`final-deploy.sh`)

The comprehensive, fully automated deployment script for Hostinger VPS.

#### Features
- **Complete VPS Setup**: Installs and configures all required packages
- **Nginx Configuration**: Sets up web server with security headers
- **SSL Automation**: Installs and auto-renews Let's Encrypt certificates
- **Backup System**: Daily backups with 30-day retention
- **Monitoring**: Real-time status monitoring every 15 minutes
- **Security**: Firewall configuration and security best practices
- **Logging**: Comprehensive logging for all operations

#### Deployment Information
- **User**: wasalstor-web
- **Timestamp**: 2025-10-20 04:00:22
- **Target Platform**: Hostinger VPS
- **Web Server**: Nginx
- **SSL Provider**: Let's Encrypt (Certbot)

#### Usage

```bash
# 1. Transfer the script to your VPS
scp final-deploy.sh user@your-server-ip:/home/user/

# 2. SSH into your VPS
ssh user@your-server-ip

# 3. Make the script executable (if not already)
chmod +x final-deploy.sh

# 4. Run the deployment script as root
sudo ./final-deploy.sh
```

#### Interactive Prompts

The script will ask for:
1. **Domain Name**: Your website domain (e.g., example.com)
2. **Email Address**: For SSL certificate notifications

Example:
```
Enter your domain name (e.g., example.com): yoursite.com
Enter your email for SSL notifications: admin@yoursite.com
```

#### Deployment Process

The script performs these steps in order:

1. **Directory Creation**
   - `/var/www/AI-Agent-Platform` - Web root
   - `/var/backups/AI-Agent-Platform` - Backup storage
   - `/var/log/AI-Agent-Platform` - Log files

2. **Package Installation**
   - Nginx web server
   - Certbot for SSL
   - Git for version control
   - Security tools (UFW, Fail2ban)
   - System utilities

3. **Firewall Configuration**
   - Enable UFW firewall
   - Allow ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)
   - Apply security rules

4. **Nginx Setup**
   - Create server configuration
   - Enable gzip compression
   - Add security headers
   - Configure caching for static files

5. **SSL Certificate**
   - Request certificate from Let's Encrypt
   - Configure for domain and www subdomain
   - Enable HTTPS redirect

6. **SSL Auto-Renewal**
   - Set up cron job (runs twice daily)
   - Automatic nginx reload after renewal
   - Logging of renewal attempts

7. **Backup System**
   - Create backup script
   - Schedule daily backups (2 AM)
   - 30-day retention policy
   - Compressed tar.gz archives

8. **Monitoring Setup**
   - Create monitoring script
   - Check Nginx status
   - Monitor SSL certificate expiry
   - Track disk usage
   - Verify website accessibility
   - Status JSON output every 15 minutes

9. **Health Check**
   - Verify all services running
   - Check SSL certificate validity
   - Confirm disk space availability
   - Count available backups

10. **Deployment Report**
    - Generate comprehensive report
    - Document all configurations
    - List automated tasks
    - Provide next steps

#### Directory Structure After Deployment

```
/var/www/AI-Agent-Platform/          # Web root (deploy your files here)
/var/backups/AI-Agent-Platform/      # Backup storage
    └── backup_YYYYMMDD_HHMMSS.tar.gz
/var/log/AI-Agent-Platform/          # Log directory
    ├── deployment_YYYYMMDD_HHMMSS.log
    ├── deployment_report_YYYYMMDD_HHMMSS.txt
    ├── nginx_access.log
    ├── nginx_error.log
    ├── backup_cron.log
    ├── monitoring.log
    ├── ssl_renewal.log
    └── status.json
/etc/nginx/sites-available/AI-Agent-Platform  # Nginx config
/etc/nginx/sites-enabled/AI-Agent-Platform    # Enabled site
/usr/local/bin/AI-Agent-Platform-backup.sh    # Backup script
/usr/local/bin/AI-Agent-Platform-monitor.sh   # Monitoring script
```

#### Automated Tasks

##### SSL Renewal
- **Schedule**: Twice daily (midnight and noon)
- **Command**: `certbot renew --quiet --post-hook 'systemctl reload nginx'`
- **Log**: `/var/log/AI-Agent-Platform/ssl_renewal.log`

##### Daily Backups
- **Schedule**: Daily at 2:00 AM
- **Retention**: 30 days
- **Format**: Compressed tar.gz
- **Location**: `/var/backups/AI-Agent-Platform/`
- **Log**: `/var/log/AI-Agent-Platform/backup_cron.log`

##### Status Monitoring
- **Schedule**: Every 15 minutes
- **Checks**:
  - Nginx service status
  - SSL certificate expiry
  - Disk usage
  - Website HTTP response
  - Overall health status
- **Output**: `/var/log/AI-Agent-Platform/status.json`
- **Log**: `/var/log/AI-Agent-Platform/monitoring.log`

#### Status Monitoring JSON

The monitoring system creates a JSON file with real-time status:

```json
{
    "timestamp": "2025-10-20T04:00:22+00:00",
    "nginx_status": "active",
    "ssl_expiry": "Mar 20 04:00:22 2026 GMT",
    "ssl_days_left": 151,
    "disk_usage_percent": 45,
    "http_status": 200,
    "deployment_healthy": true
}
```

#### Post-Deployment Steps

1. **Deploy Your Application**
   ```bash
   # Transfer your files to the web root
   sudo rsync -av /path/to/your/files/ /var/www/AI-Agent-Platform/
   
   # Set proper permissions
   sudo chown -R www-data:www-data /var/www/AI-Agent-Platform/
   sudo chmod -R 755 /var/www/AI-Agent-Platform/
   ```

2. **Verify Deployment**
   ```bash
   # Check Nginx status
   sudo systemctl status nginx
   
   # Check SSL certificate
   sudo certbot certificates
   
   # Test website access
   curl -I https://yoursite.com
   ```

3. **Monitor Status**
   ```bash
   # View real-time status
   cat /var/log/AI-Agent-Platform/status.json
   
   # Check monitoring logs
   tail -f /var/log/AI-Agent-Platform/monitoring.log
   
   # View nginx access logs
   tail -f /var/log/AI-Agent-Platform/nginx_access.log
   ```

4. **Verify Automated Tasks**
   ```bash
   # List cron jobs
   sudo crontab -l
   
   # Manually trigger backup
   sudo /usr/local/bin/AI-Agent-Platform-backup.sh
   
   # Manually run monitoring
   sudo /usr/local/bin/AI-Agent-Platform-monitor.sh
   ```

### 2. Smart Deploy Script (`smart-deploy.sh`)

Interactive deployment menu in Arabic with manual control options.

#### Features
- Arabic language interface
- Step-by-step deployment control
- Manual intervention options
- Status checking capabilities

#### Usage
```bash
./smart-deploy.sh
```

#### Menu Options
1. التحقق من حالة النشر (Check deployment status)
2. نشر تلقائي باستخدام git pull (Auto deploy with git pull)
3. إعداد شهادة SSL باستخدام certbot (SSL setup with certbot)
4. تكوين webhooks على GitHub (Configure GitHub webhooks)
5. تكوين nginx (Configure nginx)
6. نظام النسخ الاحتياطي (Backup system)
7. مراقبة السجلات (Log monitoring)
8. فحص الأداء (Performance check)
9. فحص الأمان (Security scan)
10. العودة (Rollback)

## Troubleshooting

### Common Issues

#### Port 80/443 Already in Use
```bash
# Check what's using the ports
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443

# Stop conflicting service (e.g., Apache)
sudo systemctl stop apache2
sudo systemctl disable apache2
```

#### SSL Certificate Failure
```bash
# Check DNS resolution
nslookup yoursite.com

# Test certbot dry-run
sudo certbot certbot --nginx -d yoursite.com --dry-run

# Check nginx configuration
sudo nginx -t
```

#### Nginx Won't Start
```bash
# Check configuration syntax
sudo nginx -t

# View error logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/AI-Agent-Platform/nginx_error.log

# Check port availability
sudo netstat -tulpn | grep :80
```

#### Backup Not Running
```bash
# Check cron logs
sudo grep CRON /var/log/syslog

# Test backup script manually
sudo /usr/local/bin/AI-Agent-Platform-backup.sh

# Verify cron job exists
sudo crontab -l | grep backup
```

#### Disk Space Issues
```bash
# Check disk usage
df -h

# Find large files
sudo du -sh /var/* | sort -hr | head -10

# Clean old backups manually
sudo find /var/backups/AI-Agent-Platform/ -name "backup_*.tar.gz" -mtime +30 -delete
```

### Log Files for Debugging

```bash
# Deployment log
sudo tail -f /var/log/AI-Agent-Platform/deployment_*.log

# Nginx access log
sudo tail -f /var/log/AI-Agent-Platform/nginx_access.log

# Nginx error log
sudo tail -f /var/log/AI-Agent-Platform/nginx_error.log

# System log
sudo tail -f /var/log/syslog

# Certbot log
sudo tail -f /var/log/letsencrypt/letsencrypt.log
```

## Maintenance

### Regular Tasks

#### Check System Health
```bash
# View current status
cat /var/log/AI-Agent-Platform/status.json

# Check all services
sudo systemctl status nginx
sudo ufw status
```

#### Manual Backup
```bash
sudo /usr/local/bin/AI-Agent-Platform-backup.sh
```

#### Update SSL Certificate
```bash
sudo certbot renew
sudo systemctl reload nginx
```

#### View Logs
```bash
# All deployment logs
ls -lh /var/log/AI-Agent-Platform/

# Recent monitoring entries
tail -50 /var/log/AI-Agent-Platform/monitoring.log

# Recent backups
ls -lh /var/backups/AI-Agent-Platform/
```

### Updating Your Application

```bash
# 1. Create a backup first
sudo /usr/local/bin/AI-Agent-Platform-backup.sh

# 2. Deploy new files
sudo rsync -av /path/to/new/files/ /var/www/AI-Agent-Platform/

# 3. Set permissions
sudo chown -R www-data:www-data /var/www/AI-Agent-Platform/

# 4. Test nginx configuration
sudo nginx -t

# 5. Reload nginx
sudo systemctl reload nginx

# 6. Verify deployment
curl -I https://yoursite.com
```

### Rollback Procedure

If deployment fails, restore from backup:

```bash
# 1. Stop nginx
sudo systemctl stop nginx

# 2. List available backups
ls -lh /var/backups/AI-Agent-Platform/

# 3. Restore from backup
sudo tar -xzf /var/backups/AI-Agent-Platform/backup_YYYYMMDD_HHMMSS.tar.gz -C /var/www/AI-Agent-Platform/

# 4. Set permissions
sudo chown -R www-data:www-data /var/www/AI-Agent-Platform/

# 5. Start nginx
sudo systemctl start nginx

# 6. Verify
curl -I https://yoursite.com
```

## Security Best Practices

### After Deployment

1. **Change SSH Port** (optional but recommended)
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Change Port 22 to another port
   sudo systemctl restart sshd
   ```

2. **Disable Root Login**
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Set: PermitRootLogin no
   sudo systemctl restart sshd
   ```

3. **Configure Fail2ban**
   ```bash
   sudo systemctl enable fail2ban
   sudo systemctl start fail2ban
   ```

4. **Regular Updates**
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```

5. **Monitor Logs**
   ```bash
   # Set up log rotation if needed
   sudo nano /etc/logrotate.d/ai-agent-platform
   ```

## Support

### Getting Help

- Review deployment logs: `/var/log/AI-Agent-Platform/deployment_*.log`
- Check deployment report: `/var/log/AI-Agent-Platform/deployment_report_*.txt`
- Monitor real-time status: `/var/log/AI-Agent-Platform/status.json`

### Useful Commands

```bash
# Service management
sudo systemctl status nginx
sudo systemctl restart nginx
sudo systemctl reload nginx

# Certificate management
sudo certbot certificates
sudo certbot renew --dry-run

# Firewall management
sudo ufw status verbose
sudo ufw app list

# Monitoring
cat /var/log/AI-Agent-Platform/status.json | python3 -m json.tool
tail -f /var/log/AI-Agent-Platform/monitoring.log

# Backups
ls -lh /var/backups/AI-Agent-Platform/
```

## Conclusion

The final-deploy.sh script provides a complete, production-ready deployment solution for the AI-Agent-Platform on Hostinger VPS. With automated SSL renewal, daily backups, and continuous monitoring, your deployment will be secure, reliable, and easy to maintain.

For additional customization or advanced configurations, edit the script or Nginx configuration files as needed.
