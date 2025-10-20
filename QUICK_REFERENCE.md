# Quick Deployment Reference

## Main Deployment Command

```bash
sudo ./final-deploy.sh
```

## Pre-Deployment Checklist

- [ ] Server running Ubuntu 20.04+ or Debian-based Linux
- [ ] Root/sudo access available
- [ ] Domain name configured (A record pointing to server IP)
- [ ] Email address ready for SSL notifications
- [ ] Minimum 1GB RAM and 10GB disk space available

## Deployment Components

### 1. User & Timestamp
- **User**: wasalstor-web
- **Timestamp**: 2025-10-20 04:00:22

### 2. Automated Features

#### SSL Certificate (Let's Encrypt)
- Automatic installation via Certbot
- Auto-renewal: Twice daily (midnight and noon)
- Nginx automatically reloaded after renewal
- Logs: `/var/log/AI-Agent-Platform/ssl_renewal.log`

#### Backup System
- Schedule: Daily at 2:00 AM
- Retention: 30 days
- Format: Compressed tar.gz
- Location: `/var/backups/AI-Agent-Platform/`
- Logs: `/var/log/AI-Agent-Platform/backup_cron.log`

#### Status Monitoring
- Frequency: Every 15 minutes
- Monitors: Nginx, SSL, Disk, HTTP status
- Output: `/var/log/AI-Agent-Platform/status.json`
- Logs: `/var/log/AI-Agent-Platform/monitoring.log`

### 3. Directory Structure

```
/var/www/AI-Agent-Platform/          # Web root
/var/backups/AI-Agent-Platform/      # Backups
/var/log/AI-Agent-Platform/          # Logs
/etc/nginx/sites-available/          # Nginx config
/usr/local/bin/                      # Scripts
```

## Post-Deployment

### Deploy Your Application
```bash
sudo rsync -av /path/to/files/ /var/www/AI-Agent-Platform/
sudo chown -R www-data:www-data /var/www/AI-Agent-Platform/
sudo chmod -R 755 /var/www/AI-Agent-Platform/
```

### Check Status
```bash
# View JSON status
cat /var/log/AI-Agent-Platform/status.json

# Check Nginx
sudo systemctl status nginx

# Test website
curl -I https://yoursite.com
```

### Manual Operations

#### Trigger Backup
```bash
sudo /usr/local/bin/AI-Agent-Platform-backup.sh
```

#### Check Monitoring
```bash
sudo /usr/local/bin/AI-Agent-Platform-monitor.sh
cat /var/log/AI-Agent-Platform/status.json | python3 -m json.tool
```

#### Renew SSL
```bash
sudo certbot renew
sudo systemctl reload nginx
```

### View Logs
```bash
# Deployment log
sudo tail -f /var/log/AI-Agent-Platform/deployment_*.log

# Nginx access
sudo tail -f /var/log/AI-Agent-Platform/nginx_access.log

# Nginx errors
sudo tail -f /var/log/AI-Agent-Platform/nginx_error.log

# Monitoring
sudo tail -f /var/log/AI-Agent-Platform/monitoring.log

# Backups
sudo tail -f /var/log/AI-Agent-Platform/backup_cron.log

# SSL renewal
sudo tail -f /var/log/AI-Agent-Platform/ssl_renewal.log
```

## Troubleshooting

### Nginx Issues
```bash
sudo nginx -t                    # Test config
sudo systemctl restart nginx     # Restart
sudo tail -f /var/log/nginx/error.log
```

### SSL Issues
```bash
sudo certbot certificates        # List certificates
sudo certbot renew --dry-run     # Test renewal
```

### Firewall Issues
```bash
sudo ufw status                  # Check status
sudo ufw allow 80/tcp            # Allow HTTP
sudo ufw allow 443/tcp           # Allow HTTPS
```

### Restore from Backup
```bash
# List backups
ls -lh /var/backups/AI-Agent-Platform/

# Stop nginx
sudo systemctl stop nginx

# Restore
sudo tar -xzf /var/backups/AI-Agent-Platform/backup_YYYYMMDD_HHMMSS.tar.gz \
    -C /var/www/AI-Agent-Platform/

# Fix permissions
sudo chown -R www-data:www-data /var/www/AI-Agent-Platform/

# Start nginx
sudo systemctl start nginx
```

## Monitoring Status JSON Format

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

## Cron Jobs Configured

```bash
# SSL renewal (twice daily)
0 0,12 * * * certbot renew --quiet --post-hook 'systemctl reload nginx'

# Daily backup (2 AM)
0 2 * * * /usr/local/bin/AI-Agent-Platform-backup.sh

# Status monitoring (every 15 minutes)
*/15 * * * * /usr/local/bin/AI-Agent-Platform-monitor.sh
```

## Security Features

- UFW firewall enabled (ports 22, 80, 443)
- Security headers configured in Nginx
- SSL/TLS encryption with Let's Encrypt
- Fail2ban installed for brute-force protection
- Gzip compression enabled
- Static file caching configured

## Support Resources

- Full documentation: `DEPLOYMENT.md`
- Project README: `README.md`
- Deployment report: `/var/log/AI-Agent-Platform/deployment_report_*.txt`
- All logs directory: `/var/log/AI-Agent-Platform/`

## Alternative Deployment (Smart Deploy)

For step-by-step interactive deployment in Arabic:
```bash
./smart-deploy.sh
```
