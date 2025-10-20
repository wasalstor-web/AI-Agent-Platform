#!/bin/bash

#############################################################################
# AI Agent Platform - Full Deployment Script
#############################################################################
# Smart one-command deployment script with auto-detection, interactive setup,
# full logging, backups, SSL, Nginx configuration, health checks and rollback
#############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${LOG_DIR:-/var/log/ai-agent-platform}"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/ai-agent-platform}"
DEPLOY_USER="${DEPLOY_USER:-$(whoami)}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/deploy_${TIMESTAMP}.log"

# Default configuration
DEFAULT_DOMAIN="localhost"
DEFAULT_PORT="8080"
GITHUB_PAGES_BRANCH="main"

#############################################################################
# Helper Functions
#############################################################################

# Print colored messages
print_info() {
    echo -e "${BLUE}ℹ [INFO]${NC} $1" | tee -a "${LOG_FILE}"
}

print_success() {
    echo -e "${GREEN}✓ [SUCCESS]${NC} $1" | tee -a "${LOG_FILE}"
}

print_warning() {
    echo -e "${YELLOW}⚠ [WARNING]${NC} $1" | tee -a "${LOG_FILE}"
}

print_error() {
    echo -e "${RED}✗ [ERROR]${NC} $1" | tee -a "${LOG_FILE}"
}

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Initialize logging
init_logging() {
    mkdir -p "${LOG_DIR}" 2>/dev/null || true
    touch "${LOG_FILE}" 2>/dev/null || LOG_FILE="/tmp/deploy_${TIMESTAMP}.log"
    print_info "Logging to: ${LOG_FILE}"
}

# Create backup
create_backup() {
    print_header "Creating Backup"
    
    mkdir -p "${BACKUP_DIR}" 2>/dev/null || BACKUP_DIR="/tmp/backups"
    BACKUP_PATH="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"
    
    print_info "Creating backup at: ${BACKUP_PATH}"
    
    if tar -czf "${BACKUP_PATH}" \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='*.log' \
        --exclude='.env' \
        --exclude='*.key' \
        --exclude='*.pem' \
        --exclude='*.p12' \
        --exclude='*.pfx' \
        -C "${SCRIPT_DIR}" . 2>/dev/null; then
        print_success "Backup created successfully"
        echo "${BACKUP_PATH}" > "${SCRIPT_DIR}/.last_backup"
    else
        print_warning "Backup creation failed, continuing anyway"
    fi
}

# Detect environment
detect_environment() {
    print_header "Detecting Environment"
    
    # Check for Hostinger VPS indicators
    if [ -d "/home" ] && [ -d "/var/www" ] && command -v nginx >/dev/null 2>&1; then
        ENV_TYPE="hostinger_vps"
        print_info "Environment: Hostinger VPS"
    # Check for GitHub Actions
    elif [ -n "${GITHUB_ACTIONS}" ]; then
        ENV_TYPE="github_actions"
        print_info "Environment: GitHub Actions"
    # Check for local web server
    elif command -v nginx >/dev/null 2>&1 || command -v apache2 >/dev/null 2>&1; then
        ENV_TYPE="local_server"
        print_info "Environment: Local Server"
    else
        ENV_TYPE="local_dev"
        print_info "Environment: Local Development"
    fi
    
    export ENV_TYPE
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    local missing_deps=()
    
    # Check for git
    if ! command -v git >/dev/null 2>&1; then
        missing_deps+=("git")
    fi
    
    # Check for required tools based on environment
    case "${ENV_TYPE}" in
        hostinger_vps|local_server)
            if ! command -v nginx >/dev/null 2>&1 && ! command -v apache2 >/dev/null 2>&1; then
                missing_deps+=("nginx or apache2")
            fi
            ;;
    esac
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install missing dependencies and try again"
        exit 1
    fi
    
    print_success "All prerequisites met"
}

# Deploy to GitHub Pages
deploy_github_pages() {
    print_header "Deploying to GitHub Pages"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not a git repository"
        return 1
    fi
    
    # Ensure we're on the right branch
    CURRENT_BRANCH=$(git branch --show-current)
    print_info "Current branch: ${CURRENT_BRANCH}"
    
    # Add and commit if there are changes
    if [ -n "$(git status --porcelain)" ]; then
        print_info "Uncommitted changes detected"
        read -p "Commit changes? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add .
            git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
            print_success "Changes committed"
        fi
    fi
    
    # Push to GitHub
    print_info "Pushing to GitHub..."
    if git push origin "${CURRENT_BRANCH}"; then
        print_success "Successfully pushed to GitHub"
        print_info "GitHub Pages will deploy automatically"
        print_info "Visit: https://$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/' | sed 's/\//.github.io\//')"
    else
        print_error "Failed to push to GitHub"
        return 1
    fi
}

# Deploy to Hostinger VPS
deploy_hostinger_vps() {
    print_header "Deploying to Hostinger VPS"
    
    # Get configuration
    read -p "Enter domain name [${DEFAULT_DOMAIN}]: " DOMAIN
    DOMAIN=${DOMAIN:-$DEFAULT_DOMAIN}
    
    read -p "Enter port [${DEFAULT_PORT}]: " PORT
    PORT=${PORT:-$DEFAULT_PORT}
    
    # Update from git
    print_info "Updating from git repository..."
    if git pull origin main 2>/dev/null; then
        print_success "Code updated successfully"
    else
        print_warning "Git pull failed or not configured"
    fi
    
    # Configure Nginx
    configure_nginx "${DOMAIN}" "${PORT}"
    
    # Setup SSL if domain is not localhost
    if [ "${DOMAIN}" != "localhost" ] && [ "${DOMAIN}" != "127.0.0.1" ]; then
        setup_ssl "${DOMAIN}"
    fi
    
    # Restart services
    restart_services
    
    # Run health check
    health_check "${DOMAIN}" "${PORT}"
}

# Configure Nginx
configure_nginx() {
    local domain=$1
    local port=$2
    
    print_header "Configuring Nginx"
    
    local nginx_conf="/etc/nginx/sites-available/ai-agent-platform"
    
    if [ ! -w "/etc/nginx/sites-available" ]; then
        print_warning "No write access to Nginx config directory"
        print_info "Please run with sudo or configure manually"
        return 0
    fi
    
    print_info "Creating Nginx configuration..."
    
    cat > "${nginx_conf}" <<EOF
server {
    listen 80;
    server_name ${domain};
    
    root ${SCRIPT_DIR};
    index index.html;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Logging
    access_log ${LOG_DIR}/nginx_access.log;
    error_log ${LOG_DIR}/nginx_error.log;
}
EOF
    
    # Enable site
    if [ ! -e "/etc/nginx/sites-enabled/ai-agent-platform" ]; then
        ln -s "${nginx_conf}" "/etc/nginx/sites-enabled/" 2>/dev/null || true
    fi
    
    # Test configuration
    if nginx -t 2>/dev/null; then
        print_success "Nginx configuration valid"
    else
        print_warning "Nginx configuration test failed"
    fi
}

# Setup SSL with certbot
setup_ssl() {
    local domain=$1
    
    print_header "Setting up SSL Certificate"
    
    if ! command -v certbot >/dev/null 2>&1; then
        print_warning "Certbot not installed. Skipping SSL setup"
        print_info "Install certbot: sudo apt-get install certbot python3-certbot-nginx"
        return 0
    fi
    
    print_info "Setting up SSL for domain: ${domain}"
    
    read -p "Setup SSL certificate with Let's Encrypt? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if sudo certbot --nginx -d "${domain}" --non-interactive --agree-tos --email "admin@${domain}" 2>/dev/null; then
            print_success "SSL certificate installed successfully"
        else
            print_warning "SSL setup failed. You may need to configure it manually"
        fi
    fi
}

# Restart services
restart_services() {
    print_header "Restarting Services"
    
    if command -v systemctl >/dev/null 2>&1; then
        if systemctl is-active --quiet nginx; then
            print_info "Restarting Nginx..."
            sudo systemctl reload nginx 2>/dev/null || print_warning "Failed to reload Nginx"
            print_success "Nginx reloaded"
        fi
    else
        print_warning "systemctl not available, skipping service restart"
    fi
}

# Health check
health_check() {
    local domain=$1
    local port=$2
    
    print_header "Running Health Check"
    
    local url="http://${domain}:${port}"
    if [ "${domain}" != "localhost" ] && [ "${domain}" != "127.0.0.1" ]; then
        url="http://${domain}"
    fi
    
    print_info "Checking: ${url}"
    
    if command -v curl >/dev/null 2>&1; then
        if curl -f -s -o /dev/null "${url}"; then
            print_success "Health check passed - site is accessible"
        else
            print_warning "Health check failed - site may not be accessible"
        fi
    else
        print_warning "curl not available, skipping health check"
    fi
}

# Deploy locally
deploy_local() {
    print_header "Deploying Locally"
    
    read -p "Enter port [${DEFAULT_PORT}]: " PORT
    PORT=${PORT:-$DEFAULT_PORT}
    
    print_info "Starting local server on port ${PORT}..."
    
    # Try Python 3 HTTP server
    if command -v python3 >/dev/null 2>&1; then
        print_success "Starting Python HTTP server..."
        print_info "Access the site at: http://localhost:${PORT}"
        print_info "Press Ctrl+C to stop the server"
        python3 -m http.server "${PORT}"
    # Try Python 2
    elif command -v python >/dev/null 2>&1; then
        print_success "Starting Python HTTP server..."
        print_info "Access the site at: http://localhost:${PORT}"
        print_info "Press Ctrl+C to stop the server"
        python -m SimpleHTTPServer "${PORT}"
    # Try Node.js http-server
    elif command -v npx >/dev/null 2>&1; then
        print_success "Starting Node.js HTTP server..."
        print_info "Access the site at: http://localhost:${PORT}"
        npx http-server -p "${PORT}"
    else
        print_error "No suitable HTTP server found"
        print_info "Please install Python 3 or Node.js"
        return 1
    fi
}

# Rollback to previous version
rollback() {
    print_header "Rolling Back Deployment"
    
    if [ ! -f "${SCRIPT_DIR}/.last_backup" ]; then
        print_error "No backup found for rollback"
        return 1
    fi
    
    BACKUP_PATH=$(cat "${SCRIPT_DIR}/.last_backup")
    
    if [ ! -f "${BACKUP_PATH}" ]; then
        print_error "Backup file not found: ${BACKUP_PATH}"
        return 1
    fi
    
    print_warning "This will restore from: ${BACKUP_PATH}"
    read -p "Continue with rollback? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Restoring from backup..."
        if tar -xzf "${BACKUP_PATH}" -C "${SCRIPT_DIR}"; then
            print_success "Rollback completed successfully"
            restart_services
        else
            print_error "Rollback failed"
            return 1
        fi
    else
        print_info "Rollback cancelled"
    fi
}

# Check deployment status
check_status() {
    print_header "Deployment Status Check"
    
    # Git status
    if git rev-parse --git-dir > /dev/null 2>&1; then
        print_info "Git Branch: $(git branch --show-current)"
        print_info "Last Commit: $(git log -1 --pretty=format:'%h - %s (%ar)')"
        print_info "Remote Status: $(git status -sb | head -1)"
    fi
    
    # Server status
    if command -v systemctl >/dev/null 2>&1; then
        if systemctl is-active --quiet nginx; then
            print_success "Nginx is running"
        else
            print_warning "Nginx is not running"
        fi
    fi
    
    # Recent backups
    if [ -d "${BACKUP_DIR}" ]; then
        print_info "Recent backups:"
        ls -lht "${BACKUP_DIR}" 2>/dev/null | head -5 | tail -4 || print_info "No backups found"
    fi
    
    # Log file
    if [ -f "${LOG_FILE}" ]; then
        print_info "Current log: ${LOG_FILE}"
    fi
}

# Display help
show_help() {
    cat <<EOF
AI Agent Platform - Full Deployment Script
==========================================

Usage: $0 [OPTION]

Options:
    --github-pages     Deploy to GitHub Pages
    --hostinger        Deploy to Hostinger VPS
    --local            Deploy locally (development server)
    --status           Check deployment status
    --rollback         Rollback to previous deployment
    --help             Display this help message

Environment Variables:
    LOG_DIR           Directory for logs (default: /var/log/ai-agent-platform)
    BACKUP_DIR        Directory for backups (default: /var/backups/ai-agent-platform)
    DEPLOY_USER       User for deployment (default: current user)

Examples:
    $0 --github-pages              # Deploy to GitHub Pages
    $0 --hostinger                 # Deploy to Hostinger VPS
    $0 --local                     # Run local development server
    $0 --status                    # Check deployment status
    $0 --rollback                  # Rollback to previous version

EOF
}

#############################################################################
# Main Script
#############################################################################

main() {
    # Initialize
    init_logging
    
    print_header "AI Agent Platform - Full Deployment"
    print_info "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    print_info "User: ${DEPLOY_USER}"
    print_info "Directory: ${SCRIPT_DIR}"
    
    # Parse command line arguments
    case "${1:-}" in
        --github-pages)
            create_backup
            detect_environment
            check_prerequisites
            deploy_github_pages
            ;;
        --hostinger)
            create_backup
            detect_environment
            check_prerequisites
            deploy_hostinger_vps
            ;;
        --local)
            detect_environment
            deploy_local
            ;;
        --status)
            check_status
            ;;
        --rollback)
            rollback
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            # Interactive mode
            print_info "Running in interactive mode"
            echo
            echo "Select deployment target:"
            echo "1) GitHub Pages"
            echo "2) Hostinger VPS"
            echo "3) Local Development Server"
            echo "4) Check Status"
            echo "5) Rollback"
            echo "6) Exit"
            echo
            read -p "Enter your choice (1-6): " choice
            
            case $choice in
                1)
                    create_backup
                    detect_environment
                    check_prerequisites
                    deploy_github_pages
                    ;;
                2)
                    create_backup
                    detect_environment
                    check_prerequisites
                    deploy_hostinger_vps
                    ;;
                3)
                    detect_environment
                    deploy_local
                    ;;
                4)
                    check_status
                    ;;
                5)
                    rollback
                    ;;
                6)
                    print_info "Exiting..."
                    exit 0
                    ;;
                *)
                    print_error "Invalid choice"
                    exit 1
                    ;;
            esac
            ;;
    esac
    
    print_success "Deployment process completed"
    print_info "Log file: ${LOG_FILE}"
}

# Run main function
main "$@"
