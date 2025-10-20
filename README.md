# AI-Agent-Platform

An AI Agent Platform infrastructure project with automated finalization capabilities.

## Overview

This project provides a platform for building, deploying, and managing AI agents with built-in project lifecycle management tools.

## Web Interface

The platform now includes a comprehensive HTML interface that provides:
- **Bilingual Support**: Full Arabic and English interface with real-time language switching
- **Interactive Documentation**: Visual representation of all features and workflows
- **Command Reference**: Easy-to-copy commands for all operations
- **Modern Design**: Responsive, mobile-friendly interface with gradient styling

### Accessing the Web Interface

#### Online (GitHub Pages)

The platform is hosted on GitHub Pages and can be accessed at:

**🌐 [https://wasalstor-web.github.io/AI-Agent-Platform/](https://wasalstor-web.github.io/AI-Agent-Platform/)**

The site is automatically deployed when changes are pushed to the main branch.

#### Local Access

You can also open `index.html` in your web browser locally:

```bash
# Open directly in browser
open index.html  # macOS
xdg-open index.html  # Linux
start index.html  # Windows

# Or serve it with a local server
python3 -m http.server 8080
# Then navigate to http://localhost:8080/index.html
```

The web interface includes:
- Project overview and features showcase
- Step-by-step finalization workflow visualization
- Command examples with copy-to-clipboard functionality
- Quick action buttons for GitHub repository and documentation
- Benefits and security information

## Project Finalization

The platform includes automated scripts for finalizing projects with proper resource cleanup and archival.

### Finalization Scripts

#### 1. Directive Script (`directive_finalize.sh`)

The main directive script that initiates the finalization process. This script:
- Displays administrative directives in both Arabic and English
- Calls the finalization script with appropriate parameters
- Provides clear status messages throughout the process

**Usage:**
```bash
./directive_finalize.sh
```

#### 2. Finalization Script (`finalize_project.sh`)

The core finalization script that handles:
- Project status validation
- Git repository checks
- Artifact archival
- Report generation
- Resource cleanup
- Final verification

**Usage:**
```bash
# Interactive mode (with confirmation prompt)
./finalize_project.sh

# Force mode (skip checks but proceed anyway)
./finalize_project.sh --force

# No confirmation mode (skip user prompt)
./finalize_project.sh --no-confirmation

# Combined mode (force + no confirmation)
./finalize_project.sh --force --no-confirmation
```

### Finalization Process

The finalization script performs the following steps:

1. **Project Status Check** - Validates project documentation and structure
2. **Git Repository Validation** - Checks repository status and uncommitted changes
3. **Artifact Archival** - Creates timestamped archives of project state
4. **Report Generation** - Generates comprehensive finalization report
5. **Resource Cleanup** - Removes temporary files and caches
6. **Final Verification** - Confirms all steps completed successfully

### Archive Contents

After finalization, an archive is created in `/tmp/ai-agent-platform-archive-[TIMESTAMP]` containing:
- `recent_commits.txt` - Last 10 git commits
- `final_status.txt` - Final git status
- `project_snapshot/` - Complete project snapshot
- `finalization_report.txt` - Detailed finalization report

### Options

- `--force` - Continue finalization even if warnings are detected
- `--no-confirmation` - Skip user confirmation prompt

## Deployment

The platform includes a comprehensive deployment system with support for multiple deployment targets.

📖 **[Quick Reference Guide](DEPLOYMENT.md)** - Essential deployment commands and troubleshooting

### Deployment Script (`full-deploy.sh`)

A production-ready deployment script with the following features:
- **Auto-detection** - Automatically detects environment (Hostinger VPS, GitHub Pages, Local)
- **Interactive Setup** - Guided configuration for easy deployment
- **Full Logging** - Complete logging of all deployment steps
- **Backup System** - Automatic backup before deployment with rollback capability
- **SSL Setup** - Automated SSL certificate configuration with Let's Encrypt
- **Nginx Configuration** - Automatic web server configuration
- **Health Checks** - Post-deployment verification
- **Status Monitoring** - Check deployment status and health

### Prerequisites

Before deploying, ensure you have:

**For all deployments:**
- Git installed and configured
- Repository cloned locally

**For Hostinger VPS deployment:**
- Nginx or Apache web server installed
- Sudo access for SSL and Nginx configuration
- Domain name configured (optional for SSL)

**For GitHub Pages deployment:**
- GitHub repository with Pages enabled
- Push access to the repository

**For local development:**
- Python 3 or Node.js installed

### Quick Start

#### Interactive Mode

```bash
# Make the script executable (first time only)
chmod +x full-deploy.sh

# Run in interactive mode
./full-deploy.sh
```

Select your deployment target:
1. **GitHub Pages** - Deploy to GitHub Pages
2. **Hostinger VPS** - Deploy to Hostinger VPS with Nginx
3. **Local Development Server** - Run local web server
4. **Check Status** - View deployment status and health
5. **Rollback** - Restore previous deployment

#### Command Line Mode

```bash
# Deploy to GitHub Pages
./full-deploy.sh --github-pages

# Deploy to Hostinger VPS
./full-deploy.sh --hostinger

# Run local development server
./full-deploy.sh --local

# Check deployment status
./full-deploy.sh --status

# Rollback to previous deployment
./full-deploy.sh --rollback

# Show help
./full-deploy.sh --help
```

### Deployment Workflows

#### GitHub Pages Deployment

The script will:
1. Create a backup of current state
2. Check if there are uncommitted changes
3. Commit changes if confirmed
4. Push to GitHub
5. GitHub Pages will auto-deploy (via `.github/workflows/deploy-pages.yml`)

**Access your site at:**
`https://[username].github.io/[repository-name]/`

#### Hostinger VPS Deployment

The script will:
1. Create a backup of current state
2. Pull latest changes from Git
3. Configure Nginx web server
4. Setup SSL certificate (if domain is provided)
5. Restart services
6. Run health checks

**Configuration prompts:**
- Domain name (e.g., `example.com` or `localhost`)
- Port number (default: 80)
- SSL setup confirmation

#### Local Development

The script will:
1. Detect available HTTP server (Python or Node.js)
2. Start web server on specified port
3. Display access URL

**Access at:** `http://localhost:[port]`

### Advanced Usage

#### Custom Log Directory

```bash
LOG_DIR=/custom/log/path ./full-deploy.sh --github-pages
```

#### Custom Backup Directory

```bash
BACKUP_DIR=/custom/backup/path ./full-deploy.sh --hostinger
```

#### Non-Interactive Deployment (CI/CD)

```bash
# GitHub Pages deployment (auto-commit enabled)
./full-deploy.sh --github-pages <<EOF
y
EOF
```

### Deployment Status Checks

Check your deployment status at any time:

```bash
./full-deploy.sh --status
```

This displays:
- Current Git branch and last commit
- Remote repository status
- Web server status (Nginx/Apache)
- Recent backups list
- Current log file location

### Rollback Procedure

If a deployment fails or causes issues:

```bash
./full-deploy.sh --rollback
```

This will:
1. Restore files from the last backup
2. Restart services
3. Verify restoration

**Note:** Backups are created automatically before each deployment.

### Troubleshooting

#### Permission Denied

```bash
chmod +x full-deploy.sh
```

#### Nginx Configuration Failed

Run with sudo for system configuration:
```bash
sudo ./full-deploy.sh --hostinger
```

#### Git Push Failed

Ensure you have push access to the repository:
```bash
git remote -v
git config --list | grep user
```

#### SSL Setup Failed

Ensure certbot is installed:
```bash
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx
```

#### Port Already in Use

Choose a different port when prompted or kill the process:
```bash
# Find process using the port
sudo lsof -i :8080

# Kill the process
sudo kill -9 [PID]
```

### Log Files

All deployment operations are logged:
- **Default location:** `/var/log/ai-agent-platform/deploy_[timestamp].log`
- **Fallback location:** `/tmp/deploy_[timestamp].log`

View recent logs:
```bash
tail -f /var/log/ai-agent-platform/deploy_*.log
```

### Backup Management

Backups are stored in:
- **Default location:** `/var/backups/ai-agent-platform/backup_[timestamp].tar.gz`
- **Fallback location:** `/tmp/backups/backup_[timestamp].tar.gz`

List backups:
```bash
ls -lht /var/backups/ai-agent-platform/
```

Restore manually:
```bash
tar -xzf /var/backups/ai-agent-platform/backup_[timestamp].tar.gz
```

### Security Considerations

The deployment script follows security best practices:
- ✅ Excludes sensitive files from backups (.env, .git, keys)
- ✅ Creates secure Nginx configurations with security headers
- ✅ Supports SSL/TLS with Let's Encrypt
- ✅ Validates all inputs
- ✅ Logs all operations for audit trail
- ✅ Runs with minimal required permissions

### Integration with CI/CD

Example GitHub Actions workflow for automated deployment:

```yaml
name: Deploy Platform

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to GitHub Pages
        run: |
          chmod +x full-deploy.sh
          ./full-deploy.sh --github-pages
```

## Security and Best Practices

Following the platform's security guidelines:
- ✅ No sensitive data committed to repository
- ✅ Proper error handling implemented
- ✅ Resource cleanup automated
- ✅ Comprehensive logging and reporting
- ✅ Clear user communication in multiple languages
- ✅ Automated deployment with rollback capability
- ✅ SSL/TLS support for secure communications
- ✅ Security headers in web server configuration

## License

AI-Agent-Platform © 2025