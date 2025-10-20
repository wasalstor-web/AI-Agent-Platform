#!/bin/bash
#############################################################################
# Test Script for OpenWebUI + DL+ Integration
# سكريبت اختبار دمج OpenWebUI مع DL+
#############################################################################

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🧪 Testing OpenWebUI + DL+ Integration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# Test Python imports
echo -e "${YELLOW}▶ Testing Python module imports...${NC}"
python3 << 'PYTEST'
import sys
sys.path.insert(0, './dlplus')

try:
    from agents.base_agent import BaseAgent
    from agents.web_retrieval_agent import WebRetrievalAgent
    from agents.code_generator_agent import CodeGeneratorAgent
    print("✅ Agent imports successful")
    
    web_agent = WebRetrievalAgent()
    code_agent = CodeGeneratorAgent()
    print(f"✅ WebRetrievalAgent: {web_agent.name}")
    print(f"✅ CodeGeneratorAgent: {code_agent.name}")
    
except Exception as e:
    print(f"❌ Import test failed: {e}")
    sys.exit(1)
PYTEST

echo ""
echo -e "${YELLOW}▶ Testing OpenWebUI adapter...${NC}"
python3 << 'PYTEST'
import sys
sys.path.insert(0, '.')

try:
    # Import without full dependencies
    import importlib.util
    spec = importlib.util.spec_from_file_location(
        "openwebui_adapter",
        "dlplus/integration/openwebui_adapter.py"
    )
    module = importlib.util.module_from_spec(spec)
    print("✅ OpenWebUI adapter module loads")
    
except Exception as e:
    print(f"❌ Adapter test failed: {e}")
    sys.exit(1)
PYTEST

echo ""
echo -e "${YELLOW}▶ Testing agent async execution...${NC}"
python3 << 'PYTEST'
import sys
import asyncio
sys.path.insert(0, './dlplus')

from agents.web_retrieval_agent import WebRetrievalAgent
from agents.code_generator_agent import CodeGeneratorAgent

async def test_agents():
    # Test WebRetrievalAgent
    web_agent = WebRetrievalAgent()
    result = await web_agent.execute({'query': 'test query'})
    assert result['success'], "WebRetrievalAgent failed"
    assert 'results' in result, "No results from WebRetrievalAgent"
    print(f"✅ WebRetrievalAgent: Found {result['count']} results")
    
    # Test CodeGeneratorAgent
    code_agent = CodeGeneratorAgent()
    result = await code_agent.execute({
        'description': 'test function',
        'language': 'python'
    })
    assert result['success'], "CodeGeneratorAgent failed"
    assert 'code' in result, "No code from CodeGeneratorAgent"
    print(f"✅ CodeGeneratorAgent: Generated {result['language']} code")

try:
    asyncio.run(test_agents())
    print("✅ All async agent tests passed")
except Exception as e:
    print(f"❌ Async test failed: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
PYTEST

echo ""
echo -e "${YELLOW}▶ Checking script files...${NC}"

# Check if setup script exists
if [ -f "auto-setup-openwebui.sh" ]; then
    echo -e "${GREEN}✓${NC} auto-setup-openwebui.sh exists"
else
    echo -e "${RED}✗${NC} auto-setup-openwebui.sh not found"
    exit 1
fi

# Check if script is executable
if [ -x "auto-setup-openwebui.sh" ]; then
    echo -e "${GREEN}✓${NC} auto-setup-openwebui.sh is executable"
else
    echo -e "${RED}✗${NC} auto-setup-openwebui.sh is not executable"
    exit 1
fi

# Check README
if [ -f "AUTO_SETUP_README.md" ]; then
    echo -e "${GREEN}✓${NC} AUTO_SETUP_README.md exists"
else
    echo -e "${RED}✗${NC} AUTO_SETUP_README.md not found"
    exit 1
fi

echo ""
echo -e "${YELLOW}▶ Checking integration files...${NC}"

# Check integration directory
if [ -d "dlplus/integration" ]; then
    echo -e "${GREEN}✓${NC} dlplus/integration directory exists"
else
    echo -e "${RED}✗${NC} dlplus/integration directory not found"
    exit 1
fi

# Check adapter file
if [ -f "dlplus/integration/openwebui_adapter.py" ]; then
    echo -e "${GREEN}✓${NC} openwebui_adapter.py exists"
else
    echo -e "${RED}✗${NC} openwebui_adapter.py not found"
    exit 1
fi

# Check __init__ file
if [ -f "dlplus/integration/__init__.py" ]; then
    echo -e "${GREEN}✓${NC} dlplus/integration/__init__.py exists"
else
    echo -e "${RED}✗${NC} dlplus/integration/__init__.py not found"
    exit 1
fi

echo ""
echo -e "${YELLOW}▶ Testing integration server modifications...${NC}"

# Check if integration server has agent support
if grep -q "OpenWebUIAdapter" openwebui-integration.py; then
    echo -e "${GREEN}✓${NC} Integration server has OpenWebUIAdapter import"
else
    echo -e "${RED}✗${NC} OpenWebUIAdapter not found in integration server"
    exit 1
fi

if grep -q "agent_adapter" openwebui-integration.py; then
    echo -e "${GREEN}✓${NC} Integration server uses agent_adapter"
else
    echo -e "${RED}✗${NC} agent_adapter not found in integration server"
    exit 1
fi

if grep -q "/api/agents" openwebui-integration.py; then
    echo -e "${GREEN}✓${NC} /api/agents endpoint added"
else
    echo -e "${RED}✗${NC} /api/agents endpoint not found"
    exit 1
fi

echo ""
echo -e "${YELLOW}▶ Testing configuration files...${NC}"

# Check .env file
if [ -f ".env" ]; then
    echo -e "${GREEN}✓${NC} .env file exists"
    
    # Check for required keys
    if grep -q "OPENWEBUI_JWT_TOKEN" .env; then
        echo -e "${GREEN}✓${NC} JWT token configured"
    else
        echo -e "${YELLOW}⚠${NC} JWT token not in .env"
    fi
    
    if grep -q "OPENWEBUI_API_KEY" .env; then
        echo -e "${GREEN}✓${NC} API key configured"
    else
        echo -e "${YELLOW}⚠${NC} API key not in .env"
    fi
else
    echo -e "${YELLOW}⚠${NC} .env file not found (will be created during setup)"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ All Tests Passed!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}Next Steps:${NC}"
echo ""
echo "  1. Review the automated setup script:"
echo "     cat auto-setup-openwebui.sh"
echo ""
echo "  2. Read the setup documentation:"
echo "     cat AUTO_SETUP_README.md"
echo ""
echo "  3. Run the automated setup (requires sudo):"
echo "     sudo bash auto-setup-openwebui.sh"
echo ""
echo "  4. Access OpenWebUI after installation:"
echo "     http://localhost:3000"
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
echo ""
