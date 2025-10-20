#!/bin/bash
################################################################################
# GitHub Actions Integration Verification Script
# Tests the integration setup and validates configuration
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}GitHub Actions Integration${NC}"
echo -e "${CYAN}Verification Script${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Track test results
TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -ne "Testing: ${test_name}... "
    
    if eval "$test_command" &>/dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
}

echo -e "${BLUE}Phase 1: File Validation${NC}"
echo "================================"

run_test "Workflow file exists" "test -f .github/workflows/hostinger-commands.yml"
run_test "Setup script exists" "test -f setup-github-secrets.sh"
run_test "Commander script exists" "test -f github-commander.py"
run_test "Integration guide exists" "test -f GITHUB_ACTIONS_INTEGRATION.md"
run_test "Examples exist" "test -f examples/github_actions_examples.py"
run_test "Tests exist" "test -f tests/test_github_commander.py"

echo ""
echo -e "${BLUE}Phase 2: Script Validation${NC}"
echo "================================"

run_test "Setup script is executable" "test -x setup-github-secrets.sh"
run_test "Bash syntax valid" "bash -n setup-github-secrets.sh"
run_test "Python syntax valid" "python3 -m py_compile github-commander.py"
run_test "YAML syntax valid" "python3 -c 'import yaml; yaml.safe_load(open(\".github/workflows/hostinger-commands.yml\"))'"

echo ""
echo -e "${BLUE}Phase 3: Dependencies Check${NC}"
echo "================================"

run_test "Python 3 installed" "command -v python3"
run_test "Requests module available" "python3 -c 'import requests'"
run_test "PyYAML module available" "python3 -c 'import yaml'"

# Optional dependencies
echo -ne "Checking: GitHub CLI... "
if command -v gh &>/dev/null; then
    echo -e "${GREEN}✓ Available${NC}"
    
    echo -ne "Checking: GitHub CLI authenticated... "
    if gh auth status &>/dev/null; then
        echo -e "${GREEN}✓ Authenticated${NC}"
    else
        echo -e "${YELLOW}⚠ Not authenticated${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Not installed (optional)${NC}"
fi

echo ""
echo -e "${BLUE}Phase 4: Configuration Check${NC}"
echo "================================"

echo -ne "Checking: HOSTINGER_SERVER env var... "
if [ -n "$HOSTINGER_SERVER" ]; then
    echo -e "${GREEN}✓ Set${NC}"
else
    echo -e "${YELLOW}⚠ Not set (will use default)${NC}"
fi

echo -ne "Checking: HOSTINGER_API_KEY env var... "
if [ -n "$HOSTINGER_API_KEY" ]; then
    echo -e "${GREEN}✓ Set${NC}"
else
    echo -e "${YELLOW}⚠ Not set${NC}"
fi

echo ""
echo -e "${BLUE}Phase 5: Test Suite${NC}"
echo "================================"

if command -v pytest &>/dev/null; then
    echo "Running test suite..."
    if python3 -m pytest tests/test_github_commander.py -v --tb=short; then
        echo -e "${GREEN}✓ All tests passed${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        ((TESTS_FAILED++))
    fi
else
    echo -e "${YELLOW}⚠ pytest not installed, skipping tests${NC}"
fi

echo ""
echo -e "${BLUE}Phase 6: GitHub Secrets Check${NC}"
echo "================================"

if command -v gh &>/dev/null && gh auth status &>/dev/null; then
    echo -ne "Checking: GitHub secrets configured... "
    
    # Try to list secrets (this will work if user has access)
    if gh secret list &>/dev/null; then
        echo -e "${GREEN}✓ Can access secrets${NC}"
        gh secret list
    else
        echo -e "${YELLOW}⚠ Cannot access secrets (may not be configured)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ GitHub CLI not available or not authenticated${NC}"
    echo "  Run: gh auth login"
fi

echo ""
echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}Verification Results${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

echo -e "Tests Passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Tests Failed: ${RED}${TESTS_FAILED}${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Next Steps:"
    echo "  1. Configure GitHub secrets (if not done):"
    echo "     ./setup-github-secrets.sh"
    echo ""
    echo "  2. Test workflow execution:"
    echo "     gh workflow run hostinger-commands.yml \\"
    echo "       -f command_type=status_check \\"
    echo "       -f payload='{}'"
    echo ""
    echo "  3. Monitor workflow runs:"
    echo "     gh run list --workflow=hostinger-commands.yml"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some checks failed${NC}"
    echo ""
    echo "Please address the failed checks above."
    echo ""
    echo "For help, see:"
    echo "  - GITHUB_ACTIONS_INTEGRATION.md"
    echo "  - .github/workflows/README.md"
    echo ""
    exit 1
fi
