#!/bin/bash

# Project Finalization Script
# This script handles the complete finalization of the AI Agent Platform project

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
FORCE_MODE=false
NO_CONFIRMATION=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_MODE=true
            shift
            ;;
        --no-confirmation)
            NO_CONFIRMATION=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force              Continue finalization even with warnings"
            echo "  --no-confirmation    Skip user confirmation prompt"
            echo "  --help, -h          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Interactive mode"
            echo "  $0 --force                           # Force mode with confirmation"
            echo "  $0 --no-confirmation                 # Auto mode without force"
            echo "  $0 --force --no-confirmation         # Fully automated mode"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Usage: $0 [--force] [--no-confirmation] [--help]"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        AI Agent Platform - Project Finalization         ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Confirmation prompt unless --no-confirmation is set
if [ "$NO_CONFIRMATION" = false ]; then
    echo -e "${YELLOW}⚠️  This will finalize the project and clean up resources.${NC}"
    read -p "Are you sure you want to continue? (yes/no): " confirmation
    if [ "$confirmation" != "yes" ]; then
        echo -e "${RED}❌ Finalization cancelled by user.${NC}"
        exit 0
    fi
fi

echo -e "${GREEN}✓ Starting project finalization process...${NC}"
echo ""

# Step 1: Check project status
echo -e "${BLUE}[1/6]${NC} Checking project status..."
if [ -f "README.md" ]; then
    echo -e "${GREEN}  ✓ Project documentation found${NC}"
else
    echo -e "${YELLOW}  ⚠  No README.md found${NC}"
fi

# Step 2: Validate git repository
echo -e "${BLUE}[2/6]${NC} Validating git repository..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Git repository valid${NC}"
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${YELLOW}  ⚠  Uncommitted changes detected${NC}"
        if [ "$FORCE_MODE" = true ]; then
            echo -e "${YELLOW}  ! Force mode: Proceeding anyway${NC}"
        fi
    else
        echo -e "${GREEN}  ✓ No uncommitted changes${NC}"
    fi
else
    echo -e "${RED}  ✗ Not a git repository${NC}"
    if [ "$FORCE_MODE" = false ]; then
        exit 1
    fi
fi

# Step 3: Archive project artifacts
echo -e "${BLUE}[3/6]${NC} Archiving project artifacts..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
# Use a more portable temp directory approach
if [ -d "/tmp" ]; then
    ARCHIVE_DIR="/tmp/ai-agent-platform-archive-${TIMESTAMP}"
else
    ARCHIVE_DIR="$(mktemp -d -t ai-agent-platform-archive-${TIMESTAMP}.XXXXXX)"
fi
mkdir -p "${ARCHIVE_DIR}"

if [ -d ".git" ]; then
    # Archive git information
    git --no-pager log --oneline -10 > "${ARCHIVE_DIR}/recent_commits.txt" 2>/dev/null || true
    git --no-pager status > "${ARCHIVE_DIR}/final_status.txt" 2>/dev/null || true
    echo -e "${GREEN}  ✓ Git history archived${NC}"
fi

# Copy key files excluding sensitive directories
mkdir -p "${ARCHIVE_DIR}/project_snapshot"
if command -v rsync &> /dev/null; then
    rsync -av --exclude='.git' --exclude='node_modules' --exclude='.env' --exclude='*.key' --exclude='*.pem' . "${ARCHIVE_DIR}/project_snapshot/" 2>/dev/null || true
else
    # Fallback to tar if rsync is not available
    tar --exclude='.git' --exclude='node_modules' --exclude='.env' --exclude='*.key' --exclude='*.pem' -cf - . 2>/dev/null | (cd "${ARCHIVE_DIR}/project_snapshot" && tar -xf -) 2>/dev/null || true
fi
echo -e "${GREEN}  ✓ Project snapshot created at: ${ARCHIVE_DIR}${NC}"

# Step 4: Generate finalization report
echo -e "${BLUE}[4/6]${NC} Generating finalization report..."
REPORT_FILE="${ARCHIVE_DIR}/finalization_report.txt"
cat > "${REPORT_FILE}" << EOF
AI Agent Platform - Project Finalization Report
================================================
Finalization Date: $(date)
Force Mode: ${FORCE_MODE}
Confirmation Skipped: ${NO_CONFIRMATION}

Project Status:
---------------
Repository: $(git remote get-url origin 2>/dev/null || echo "No remote configured")
Current Branch: $(git branch --show-current 2>/dev/null || echo "N/A")
Last Commit: $(git log -1 --oneline 2>/dev/null || echo "N/A")

Archive Location:
-----------------
${ARCHIVE_DIR}

Resources Cleaned:
------------------
- Temporary files checked
- Archive created successfully
- Project state preserved

EOF
echo -e "${GREEN}  ✓ Finalization report generated${NC}"

# Step 5: Clean up temporary resources
echo -e "${BLUE}[5/6]${NC} Cleaning up temporary resources..."
# Clean common temporary directories (if they exist) with safety checks
if [ -d "/tmp" ]; then
    # Only remove files matching our specific pattern and that we created
    find /tmp -maxdepth 1 -name "ai-agent-temp-*" -type f -mtime +7 -delete 2>/dev/null || true
fi
# Clean project-specific cache directories
[ -d ".pytest_cache" ] && rm -rf .pytest_cache 2>/dev/null || true
[ -d "__pycache__" ] && rm -rf __pycache__ 2>/dev/null || true
[ -d "node_modules/.cache" ] && rm -rf node_modules/.cache 2>/dev/null || true
echo -e "${GREEN}  ✓ Temporary resources cleaned${NC}"

# Step 6: Final verification
echo -e "${BLUE}[6/6]${NC} Final verification..."
if [ -d "${ARCHIVE_DIR}" ] && [ -f "${REPORT_FILE}" ]; then
    echo -e "${GREEN}  ✓ All finalization steps completed successfully${NC}"
else
    echo -e "${RED}  ✗ Some finalization steps may have failed${NC}"
    if [ "$FORCE_MODE" = false ]; then
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              Finalization Complete                      ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}📦 Archive Location:${NC} ${ARCHIVE_DIR}"
echo -e "${GREEN}📄 Report File:${NC} ${REPORT_FILE}"
echo ""
echo -e "${GREEN}✅ Project finalization completed successfully!${NC}"
echo -e "${BLUE}🎯 All resources have been cleaned and archived.${NC}"
echo ""

# Display the report
echo -e "${YELLOW}=== Finalization Report ===${NC}"
cat "${REPORT_FILE}"
