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

The platform includes comprehensive deployment automation for Hostinger VPS.

### Production Deployment Script (`final-deploy.sh`)

Full automation script for Hostinger VPS deployment with:

**Features:**
- ✅ Complete VPS setup and configuration
- ✅ Nginx web server installation and configuration
- ✅ Automatic SSL certificate with Let's Encrypt
- ✅ SSL auto-renewal (twice daily)
- ✅ Automated backup system (daily at 2 AM)
- ✅ Deployment status monitoring (every 15 minutes)
- ✅ Firewall configuration (UFW)
- ✅ Security headers and best practices
- ✅ Comprehensive logging and reporting

**Configuration:**
- User: wasalstor-web
- Timestamp: 2025-10-20 04:00:22
- Automated monitoring and maintenance

**Usage:**
```bash
# Run with sudo (requires root access)
sudo ./final-deploy.sh
```

The script will:
1. Install required dependencies (Nginx, Certbot, etc.)
2. Configure firewall rules
3. Set up Nginx with security headers
4. Install SSL certificate from Let's Encrypt
5. Configure automatic SSL renewal
6. Set up daily backup system (30-day retention)
7. Configure status monitoring
8. Generate comprehensive deployment report

**Automated Tasks:**
- SSL renewal: Runs twice daily (midnight and noon)
- Backups: Daily at 2 AM with 30-day retention
- Monitoring: Status checks every 15 minutes

**Log Files:**
All logs are stored in `/var/log/AI-Agent-Platform/`:
- `deployment_[timestamp].log` - Deployment process log
- `nginx_access.log` - Nginx access log
- `nginx_error.log` - Nginx error log
- `backup_cron.log` - Backup execution log
- `monitoring.log` - Status monitoring log
- `ssl_renewal.log` - SSL renewal log

**Status Monitoring:**
Real-time status available at: `/var/log/AI-Agent-Platform/status.json`

Contains:
- Nginx service status
- SSL certificate expiry
- Disk usage
- HTTP status code
- Overall deployment health

### Smart Deploy Script (`smart-deploy.sh`)

Interactive deployment menu in Arabic with options for:
1. Deployment status checking
2. Git pull automation
3. SSL certificate setup
4. GitHub webhooks configuration
5. Nginx configuration
6. Backup system
7. Log monitoring
8. Performance checks
9. Security scanning
10. Rollback capability

**Usage:**
```bash
./smart-deploy.sh
```

## Security and Best Practices

Following the platform's security guidelines:
- ✅ No sensitive data committed to repository
- ✅ Proper error handling implemented
- ✅ Resource cleanup automated
- ✅ Comprehensive logging and reporting
- ✅ Clear user communication in multiple languages
- ✅ Automated SSL certificate management
- ✅ Security headers configured
- ✅ Firewall rules implemented
- ✅ Regular backups with retention policy

## License

AI-Agent-Platform © 2025