# Deployment Quick Reference

## Quick Start Commands

### Deploy to GitHub Pages
```bash
./full-deploy.sh --github-pages
```

### Deploy to Hostinger VPS
```bash
./full-deploy.sh --hostinger
```

### Run Local Development Server
```bash
./full-deploy.sh --local
```

### Check Deployment Status
```bash
./full-deploy.sh --status
```

### Rollback to Previous Version
```bash
./full-deploy.sh --rollback
```

## Common Scenarios

### First Time Setup

1. **Make script executable:**
   ```bash
   chmod +x full-deploy.sh
   ```

2. **Run in interactive mode:**
   ```bash
   ./full-deploy.sh
   ```

3. **Select your deployment target from the menu**

### Updating a Live Deployment

```bash
# Pull latest changes
git pull origin main

# Deploy with automatic backup
./full-deploy.sh --github-pages  # or --hostinger
```

### Emergency Rollback

If something goes wrong:
```bash
./full-deploy.sh --rollback
```

This restores the last backup automatically.

## Deployment Targets

### 1. GitHub Pages
- **Best for:** Public documentation, static sites
- **Requirements:** GitHub repository with Pages enabled
- **URL:** `https://[username].github.io/[repository]/`
- **Auto-deploy:** Yes (via GitHub Actions)

### 2. Hostinger VPS
- **Best for:** Production deployments, custom domains
- **Requirements:** VPS access, Nginx/Apache, domain (optional)
- **Features:** SSL setup, Nginx config, health checks
- **Access:** Via configured domain or IP

### 3. Local Development
- **Best for:** Testing, development
- **Requirements:** Python 3 or Node.js
- **Access:** `http://localhost:[port]`

## Troubleshooting

### Script Not Executable
```bash
chmod +x full-deploy.sh
```

### Permission Denied (Nginx/SSL)
```bash
sudo ./full-deploy.sh --hostinger
```

### Port Already in Use
```bash
# Kill process on port 8080
sudo lsof -i :8080
sudo kill -9 [PID]
```

### Git Push Failed
```bash
# Check git credentials
git config --list | grep user
git remote -v
```

### Backup Failed
The script continues even if backup fails. You can:
- Check disk space: `df -h`
- Manually create backup: `tar -czf backup.tar.gz .`

## Logs and Backups

### View Recent Logs
```bash
# View latest log
tail -f /tmp/deploy_*.log

# Or if using system directory
tail -f /var/log/ai-agent-platform/deploy_*.log
```

### List Backups
```bash
ls -lht /tmp/backups/ | head -10
# or
ls -lht /var/backups/ai-agent-platform/ | head -10
```

### Manual Restore
```bash
tar -xzf /tmp/backups/backup_[timestamp].tar.gz
```

## Environment Variables

Customize deployment behavior:

```bash
# Custom log directory
LOG_DIR=/custom/path ./full-deploy.sh --status

# Custom backup directory
BACKUP_DIR=/custom/backups ./full-deploy.sh --hostinger

# Custom deployment user
DEPLOY_USER=admin ./full-deploy.sh --status
```

## Status Checks

The status check shows:
- ✅ Git branch and last commit
- ✅ Remote repository status
- ✅ Web server status (Nginx/Apache)
- ✅ Recent backups
- ✅ Current log file

Run anytime:
```bash
./full-deploy.sh --status
```

## Security Features

The deployment script:
- ✅ Excludes sensitive files from backups
- ✅ Adds security headers to Nginx
- ✅ Supports SSL/TLS certificates
- ✅ Logs all operations
- ✅ Validates inputs
- ✅ Creates automatic backups

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy
on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: |
          chmod +x full-deploy.sh
          ./full-deploy.sh --github-pages
```

## Support

For detailed documentation, see:
- **README.md** - Complete deployment guide
- **./full-deploy.sh --help** - Script help
- **Logs** - Check deployment logs for errors

## Version Information

- **Script:** full-deploy.sh
- **Platform:** AI-Agent-Platform
- **Documentation:** README.md
- **Status Checks:** `.github/workflows/deployment-status.yml`
