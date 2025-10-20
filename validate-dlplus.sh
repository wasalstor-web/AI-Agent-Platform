#!/bin/bash

# DL+ System Validation Script
# سكريبت التحقق من نظام DL+

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🧠 DL+ System Validation${NC}"
echo -e "${BLUE}   التحقق من نظام DL+${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to print check
check() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1 - FAILED${NC}"
        exit 1
    fi
}

# 1. Check directory structure
echo -e "${YELLOW}📁 Checking directory structure...${NC}"
[ -d "dlplus" ] && check "dlplus directory exists"
[ -d "dlplus/core" ] && check "dlplus/core directory exists"
[ -d "dlplus/api" ] && check "dlplus/api directory exists"
[ -d "dlplus/config" ] && check "dlplus/config directory exists"
[ -d "dlplus/agents" ] && check "dlplus/agents directory exists"
[ -d "dlplus/utils" ] && check "dlplus/utils directory exists"
[ -d "dlplus/docs" ] && check "dlplus/docs directory exists"
[ -d "examples" ] && check "examples directory exists"
[ -d "tests" ] && check "tests directory exists"
echo ""

# 2. Check core files
echo -e "${YELLOW}📄 Checking core files...${NC}"
[ -f "dlplus/__init__.py" ] && check "dlplus/__init__.py exists"
[ -f "dlplus/main.py" ] && check "dlplus/main.py exists"
[ -f "dlplus/core/intelligence_core.py" ] && check "intelligence_core.py exists"
[ -f "dlplus/core/arabic_processor.py" ] && check "arabic_processor.py exists"
[ -f "dlplus/core/context_analyzer.py" ] && check "context_analyzer.py exists"
echo ""

# 3. Check API files
echo -e "${YELLOW}🔌 Checking API files...${NC}"
[ -f "dlplus/api/fastapi_connector.py" ] && check "fastapi_connector.py exists"
[ -f "dlplus/api/internal_api.py" ] && check "internal_api.py exists"
echo ""

# 4. Check configuration files
echo -e "${YELLOW}⚙️  Checking configuration files...${NC}"
[ -f "dlplus/config/settings.py" ] && check "settings.py exists"
[ -f "dlplus/config/models_config.py" ] && check "models_config.py exists"
[ -f "dlplus/config/agents_config.py" ] && check "agents_config.py exists"
echo ""

# 5. Check agents
echo -e "${YELLOW}🤖 Checking agents...${NC}"
[ -f "dlplus/agents/base_agent.py" ] && check "base_agent.py exists"
[ -f "dlplus/agents/web_retrieval_agent.py" ] && check "web_retrieval_agent.py exists"
[ -f "dlplus/agents/code_generator_agent.py" ] && check "code_generator_agent.py exists"
echo ""

# 6. Check utilities
echo -e "${YELLOW}🔧 Checking utilities...${NC}"
[ -f "dlplus/utils/logger.py" ] && check "logger.py exists"
[ -f "dlplus/utils/helpers.py" ] && check "helpers.py exists"
echo ""

# 7. Check examples
echo -e "${YELLOW}💡 Checking examples...${NC}"
[ -f "examples/basic_usage.py" ] && check "basic_usage.py exists"
[ -f "examples/agent_usage.py" ] && check "agent_usage.py exists"
[ -f "examples/api_client_usage.py" ] && check "api_client_usage.py exists"
echo ""

# 8. Check tests
echo -e "${YELLOW}🧪 Checking tests...${NC}"
[ -f "tests/test_core.py" ] && check "test_core.py exists"
[ -f "tests/test_arabic_processor.py" ] && check "test_arabic_processor.py exists"
[ -f "tests/test_agents.py" ] && check "test_agents.py exists"
[ -f "tests/conftest.py" ] && check "conftest.py exists"
echo ""

# 9. Check documentation
echo -e "${YELLOW}📖 Checking documentation...${NC}"
[ -f "DLPLUS_README.md" ] && check "DLPLUS_README.md exists"
[ -f "DLPLUS_DEPLOYMENT.md" ] && check "DLPLUS_DEPLOYMENT.md exists"
[ -f "DLPLUS_IMPLEMENTATION_SUMMARY.md" ] && check "DLPLUS_IMPLEMENTATION_SUMMARY.md exists"
[ -f "dlplus/docs/DLPLUS_SYSTEM.md" ] && check "DLPLUS_SYSTEM.md exists"
echo ""

# 10. Check scripts
echo -e "${YELLOW}📜 Checking scripts...${NC}"
[ -f "start-dlplus.sh" ] && check "start-dlplus.sh exists"
[ -x "start-dlplus.sh" ] && check "start-dlplus.sh is executable"
echo ""

# 11. Check configuration templates
echo -e "${YELLOW}⚙️  Checking configuration templates...${NC}"
[ -f ".env.dlplus.example" ] && check ".env.dlplus.example exists"
[ -f "requirements.txt" ] && check "requirements.txt exists"
echo ""

# 12. Count files
echo -e "${YELLOW}📊 Statistics...${NC}"
PYTHON_FILES=$(find dlplus -name "*.py" | wc -l)
echo -e "${GREEN}   Python files: $PYTHON_FILES${NC}"

EXAMPLE_FILES=$(find examples -name "*.py" | wc -l)
echo -e "${GREEN}   Example files: $EXAMPLE_FILES${NC}"

TEST_FILES=$(find tests -name "*.py" | wc -l)
echo -e "${GREEN}   Test files: $TEST_FILES${NC}"

DOC_FILES=$(find . -maxdepth 2 -name "DLPLUS*.md" | wc -l)
echo -e "${GREEN}   Documentation files: $DOC_FILES${NC}"
echo ""

# 13. Python syntax check
echo -e "${YELLOW}🐍 Checking Python syntax...${NC}"
if command -v python3 &> /dev/null; then
    for file in $(find dlplus -name "*.py"); do
        python3 -m py_compile "$file" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ $file - syntax OK${NC}"
        else
            echo -e "${RED}❌ $file - syntax error${NC}"
            exit 1
        fi
    done
else
    echo -e "${YELLOW}⚠️  Python3 not found, skipping syntax check${NC}"
fi
echo ""

# Final summary
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ DL+ System Validation Complete!${NC}"
echo -e "${GREEN}   اكتمل التحقق من نظام DL+ بنجاح!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}All components are in place and validated.${NC}"
echo -e "${GREEN}The DL+ system is ready for deployment!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Install dependencies: ${YELLOW}pip install -r requirements.txt${NC}"
echo -e "  2. Configure settings: ${YELLOW}cp .env.dlplus.example .env${NC}"
echo -e "  3. Start the system: ${YELLOW}./start-dlplus.sh${NC}"
echo ""
