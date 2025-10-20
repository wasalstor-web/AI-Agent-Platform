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

## VPS Connection Check

The platform includes comprehensive VPS connection verification tools.

### Deploy Script (`deploy.sh`)

A bilingual (Arabic/English) script for checking VPS connectivity:

**Features:**
- DNS resolution check
- SSH connection test
- HTTP/HTTPS connectivity verification
- Response time measurement
- Comprehensive port scanning (SSH, HTTP, HTTPS, databases)
- Colored output for better readability
- Configurable timeouts

**Usage:**

```bash
# Basic usage with command line arguments
./deploy.sh --host your-vps.com

# With custom SSH settings
./deploy.sh --host your-vps.com --user admin --port 2222

# Using environment variables
VPS_HOST=your-vps.com ./deploy.sh

# Configure via .env file
cp .env.example .env
# Edit .env with your VPS details
source .env
./deploy.sh

# Show help
./deploy.sh --help
```

**Configuration Options:**

- `--host, -h` : VPS hostname or IP address
- `--user, -u` : SSH username (default: root)
- `--port, -p` : SSH port (default: 22)
- `--timeout, -t` : Connection timeout in seconds (default: 5)

**Environment Variables:**

- `VPS_HOST` : Server hostname
- `VPS_USER` : SSH username
- `VPS_PORT` : SSH port
- `HTTP_PORT` : HTTP port (default: 80)
- `HTTPS_PORT` : HTTPS port (default: 443)
- `TIMEOUT` : Connection timeout

### Smart Deploy Script (`smart-deploy.sh`)

Interactive menu-driven deployment tool with Arabic interface. The first option now integrates with the comprehensive VPS connection check.

**Usage:**
```bash
./smart-deploy.sh
```

**Features:**
1. Check deployment status (VPS connection check)
2. Automated git pull deployment
3. SSL certificate setup
4. GitHub webhooks configuration
5. Nginx configuration
6. Backup system
7. Log monitoring
8. Performance checks
9. Security scanning
10. Rollback capability

### Connection Check Output

The VPS connection check provides detailed information:

```
✓ DNS Resolution: Shows IP address resolution
✓ SSH Connection: Tests SSH connectivity
✓ HTTP/HTTPS: Checks web server status
✓ Response Time: Measures ping and HTTP response times
✓ Port Scanning: Checks common service ports
```

**Output Example:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  فحص شامل لاتصال VPS / Comprehensive VPS Connection Check
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ DNS resolved: your-vps.com → 123.456.789.0
✓ SSH connection successful
✓ HTTP server is responding
✓ Average response time: 45ms
✓ Port 22 is open
```

## Security and Best Practices

Following the platform's security guidelines:
- ✅ No sensitive data committed to repository
- ✅ Proper error handling implemented
- ✅ Resource cleanup automated
- ✅ Comprehensive logging and reporting
- ✅ Clear user communication in multiple languages
- ✅ Secure VPS connection verification
- ✅ Environment variable support for sensitive configuration

**Security Notes:**
- Never commit `.env` file to the repository
- Use SSH keys for authentication instead of passwords
- Configure firewall rules to restrict SSH access
- Use non-standard SSH ports when possible
- Keep SSH and web server software up to date

## License

AI-Agent-Platform © 2025