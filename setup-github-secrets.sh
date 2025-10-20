#!/bin/bash
################################################################################
# GitHub Secrets Setup Script for Hostinger Integration
# This script helps configure GitHub repository secrets for workflow execution
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_SERVER="72.61.178.135:8000"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo ""
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed"
        return 1
    fi
    return 0
}

################################################################################
# Main Script
################################################################################

print_header "GitHub Actions - Hostinger Integration Setup"

echo "This script will help you configure GitHub secrets for Hostinger server integration."
echo ""
echo "You will need:"
echo "  1. GitHub CLI (gh) installed and authenticated"
echo "  2. Repository owner and name"
echo "  3. Hostinger server details"
echo "  4. API key for authentication"
echo ""

# Check prerequisites
print_info "Checking prerequisites..."

if ! check_command "gh"; then
    print_error "GitHub CLI (gh) is required but not installed."
    echo ""
    echo "Install GitHub CLI:"
    echo "  macOS:   brew install gh"
    echo "  Linux:   See https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  Windows: See https://github.com/cli/cli/releases"
    echo ""
    exit 1
fi

print_success "GitHub CLI is installed"

# Check GitHub CLI authentication
if ! gh auth status &> /dev/null; then
    print_error "GitHub CLI is not authenticated"
    echo ""
    echo "Please authenticate with GitHub CLI:"
    echo "  gh auth login"
    echo ""
    exit 1
fi

print_success "GitHub CLI is authenticated"

################################################################################
# Get Repository Information
################################################################################

print_header "Repository Configuration"

# Try to detect current repository
if [ -d ".git" ]; then
    REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -n "$REPO_URL" ]; then
        # Extract owner/repo from URL
        if [[ "$REPO_URL" =~ github.com[:/]([^/]+)/([^/.]+) ]]; then
            DETECTED_OWNER="${BASH_REMATCH[1]}"
            DETECTED_REPO="${BASH_REMATCH[2]}"
            print_info "Detected repository: ${DETECTED_OWNER}/${DETECTED_REPO}"
        fi
    fi
fi

# Get repository owner
read -p "Repository owner [${DETECTED_OWNER:-wasalstor-web}]: " REPO_OWNER
REPO_OWNER=${REPO_OWNER:-${DETECTED_OWNER:-wasalstor-web}}

# Get repository name
read -p "Repository name [${DETECTED_REPO:-AI-Agent-Platform}]: " REPO_NAME
REPO_NAME=${REPO_NAME:-${DETECTED_REPO:-AI-Agent-Platform}}

REPO_FULL="${REPO_OWNER}/${REPO_NAME}"
print_success "Repository: ${REPO_FULL}"

# Verify repository access
print_info "Verifying repository access..."
if ! gh repo view "${REPO_FULL}" &> /dev/null; then
    print_error "Cannot access repository: ${REPO_FULL}"
    echo "Please check:"
    echo "  1. Repository exists"
    echo "  2. You have access to the repository"
    echo "  3. Repository name is correct"
    exit 1
fi

print_success "Repository access verified"

################################################################################
# Get Hostinger Server Configuration
################################################################################

print_header "Hostinger Server Configuration"

read -p "Hostinger server address [${DEFAULT_SERVER}]: " HOSTINGER_SERVER
HOSTINGER_SERVER=${HOSTINGER_SERVER:-${DEFAULT_SERVER}}

print_success "Server: ${HOSTINGER_SERVER}"

################################################################################
# Get API Key
################################################################################

print_header "API Key Configuration"

echo "You need an API key to authenticate with the Hostinger server."
echo ""
echo "Options:"
echo "  1. Use default development key (not recommended for production)"
echo "  2. Generate a new secure key"
echo "  3. Enter existing key"
echo ""

read -p "Choose option [1-3]: " KEY_OPTION

case $KEY_OPTION in
    1)
        API_KEY="aip_bb1dc27e182e83edcf6ea1e6b989d3c8d32d0e54a00b26f39cfda657fc493cea"
        print_warning "Using default development key"
        ;;
    2)
        API_KEY="aip_$(openssl rand -hex 32)"
        print_success "Generated new API key"
        echo ""
        echo "⚠️  IMPORTANT: Save this key securely!"
        echo "API Key: ${API_KEY}"
        echo ""
        echo "You will need to configure this key on your Hostinger server in:"
        echo "  - .env file: HOSTINGER_API_KEY=${API_KEY}"
        echo "  - Or in dlplus configuration"
        echo ""
        read -p "Press Enter to continue after saving the key..."
        ;;
    3)
        read -sp "Enter API key: " API_KEY
        echo ""
        print_success "API key entered"
        ;;
    *)
        print_error "Invalid option"
        exit 1
        ;;
esac

################################################################################
# Set GitHub Secrets
################################################################################

print_header "Setting GitHub Secrets"

print_info "Creating/updating repository secrets..."

# Set HOSTINGER_SERVER secret
echo "${HOSTINGER_SERVER}" | gh secret set HOSTINGER_SERVER \
    --repo "${REPO_FULL}" \
    && print_success "Set HOSTINGER_SERVER secret" \
    || print_error "Failed to set HOSTINGER_SERVER secret"

# Set HOSTINGER_API_KEY secret
echo "${API_KEY}" | gh secret set HOSTINGER_API_KEY \
    --repo "${REPO_FULL}" \
    && print_success "Set HOSTINGER_API_KEY secret" \
    || print_error "Failed to set HOSTINGER_API_KEY secret"

################################################################################
# Verify Secrets
################################################################################

print_header "Verifying Secrets"

print_info "Listing repository secrets..."
gh secret list --repo "${REPO_FULL}"

################################################################################
# Test Connection (Optional)
################################################################################

print_header "Connection Test (Optional)"

read -p "Do you want to test the connection to Hostinger server? [y/N]: " TEST_CONNECTION

if [[ "$TEST_CONNECTION" =~ ^[Yy]$ ]]; then
    print_info "Testing connection to ${HOSTINGER_SERVER}..."
    
    # Export environment variables for testing
    export HOSTINGER_SERVER="${HOSTINGER_SERVER}"
    export HOSTINGER_API_KEY="${API_KEY}"
    
    if [ -f "${SCRIPT_DIR}/github-commander.py" ]; then
        if command -v python3 &> /dev/null; then
            print_info "Installing Python dependencies..."
            python3 -m pip install --quiet requests
            
            print_info "Running health check..."
            if python3 "${SCRIPT_DIR}/github-commander.py" status_check '{}'; then
                print_success "Connection test successful!"
            else
                print_warning "Connection test failed. Please check:"
                echo "  1. Hostinger server is running"
                echo "  2. Server address is correct"
                echo "  3. API key is valid"
                echo "  4. Firewall allows connections"
            fi
        else
            print_warning "Python 3 not found, skipping connection test"
        fi
    else
        print_warning "github-commander.py not found, skipping connection test"
    fi
fi

################################################################################
# Display Summary
################################################################################

print_header "Setup Complete!"

echo "GitHub repository secrets have been configured successfully."
echo ""
echo "Configuration Summary:"
echo "  Repository:     ${REPO_FULL}"
echo "  Server:         ${HOSTINGER_SERVER}"
echo "  API Key:        ****${API_KEY: -8}"
echo ""
echo "Next Steps:"
echo "  1. Ensure Hostinger server is running with the same API key"
echo "  2. Test the workflow:"
echo "     gh workflow run hostinger-commands.yml \\"
echo "       --repo ${REPO_FULL} \\"
echo "       -f command_type=status_check \\"
echo "       -f payload='{}'"
echo "  3. View workflow runs:"
echo "     gh run list --workflow=hostinger-commands.yml --repo ${REPO_FULL}"
echo ""
echo "Available Commands:"
echo "  • file_create      - Create files on server"
echo "  • file_read        - Read files from server"
echo "  • file_update      - Update files on server"
echo "  • file_delete      - Delete files from server"
echo "  • service_restart  - Restart services"
echo "  • openwebui_manage - Manage OpenWebUI"
echo "  • log_view         - View server logs"
echo "  • status_check     - Check server status"
echo "  • backup_create    - Create backups"
echo ""
echo "For more information:"
echo "  • Documentation: GITHUB_INTEGRATION_GUIDE.md"
echo "  • Command Guide: HOSTINGER_COMMAND_EXECUTION.md"
echo "  • Workflow File: .github/workflows/hostinger-commands.yml"
echo ""

print_success "Setup script completed successfully!"
