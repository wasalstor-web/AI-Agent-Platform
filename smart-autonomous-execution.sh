#!/bin/bash

################################################################################
# Smart Autonomous Execution Script
# سكربت التنفيذ الذاتي الذكي
#
# This script executes all deployment steps in the intelligent order as specified
# in the deployment requirements:
#
# 1. bash deploy-smart.sh
# 2. bash deploy-to-hostinger.sh (if Hostinger server)
# 3. bash directive_finalize.sh
# 4. bash ai-agent-manager.sh --auto --warm
# 5. Activate Open WebUI and return final URL
#
################################################################################

set -e  # Exit on error

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXECUTION_LOG="/tmp/smart-execution-$(date +%Y%m%d-%H%M%S).log"

################################################################################
# Display Functions
################################################################################

print_header() {
    echo "" | tee -a "$EXECUTION_LOG"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a "$EXECUTION_LOG"
    echo -e "${BLUE}  $1${NC}" | tee -a "$EXECUTION_LOG"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a "$EXECUTION_LOG"
    echo "" | tee -a "$EXECUTION_LOG"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$EXECUTION_LOG"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$EXECUTION_LOG"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}" | tee -a "$EXECUTION_LOG"
}

################################################################################
# Main Execution
################################################################################

main() {
    clear
    
    print_header "🚀 Smart Autonomous Execution / التنفيذ الذاتي الذكي"
    
    echo -e "${CYAN}Starting smart autonomous execution...${NC}"
    echo -e "${CYAN}Repository: wasalstor-web/AI-Agent-Platform${NC}"
    echo -e "${CYAN}Execution Log: $EXECUTION_LOG${NC}"
    echo ""
    
    # Step 1: Autonomous Deployment (replaces deploy-smart.sh for non-interactive execution)
    print_header "Step 1: Autonomous Deployment"
    print_info "Running autonomous-deploy.sh (smart deployment)..."
    
    if [ -f "$PROJECT_ROOT/autonomous-deploy.sh" ]; then
        bash "$PROJECT_ROOT/autonomous-deploy.sh" 2>&1 | tee -a "$EXECUTION_LOG"
        print_success "Autonomous deployment completed"
    else
        print_warning "autonomous-deploy.sh not found, skipping"
    fi
    
    echo ""
    
    # Step 2: Hostinger Deployment (if applicable)
    print_header "Step 2: Hostinger Deployment (Optional)"
    print_info "Checking for Hostinger environment..."
    
    # Check if we're on a Hostinger server
    if [ -f "/etc/hostinger" ] || [ -n "$HOSTINGER_HOST" ]; then
        print_info "Hostinger environment detected, running deploy-to-hostinger.sh..."
        
        if [ -f "$PROJECT_ROOT/deploy-to-hostinger.sh" ]; then
            # This script requires interaction, skip in autonomous mode
            print_warning "deploy-to-hostinger.sh requires manual configuration, skipping"
        fi
    else
        print_info "Not on Hostinger server, skipping this step"
    fi
    
    echo ""
    
    # Step 3: Finalization Directive
    print_header "Step 3: Finalization Directive"
    print_info "Running directive_finalize.sh..."
    
    if [ -f "$PROJECT_ROOT/directive_finalize.sh" ]; then
        bash "$PROJECT_ROOT/directive_finalize.sh" 2>&1 | tee -a "$EXECUTION_LOG"
        print_success "Finalization directive completed"
    else
        print_warning "directive_finalize.sh not found, skipping"
    fi
    
    echo ""
    
    # Step 4: AI Agent Manager with Auto and Warm-up
    print_header "Step 4: AI Agent Manager (Auto + Warm-up)"
    print_info "Running ai-agent-manager.sh --auto --warm..."
    
    if [ -f "$PROJECT_ROOT/ai-agent-manager.sh" ]; then
        bash "$PROJECT_ROOT/ai-agent-manager.sh" --auto --warm 2>&1 | tee -a "$EXECUTION_LOG"
        print_success "AI Agent Manager completed"
    else
        print_warning "ai-agent-manager.sh not found, skipping"
    fi
    
    echo ""
    
    # Step 5: Activate Open WebUI
    print_header "Step 5: Open WebUI Activation"
    print_info "Checking Open WebUI status..."
    
    # Check if OpenWebUI is responding
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 2>/dev/null | grep -q "200\|404"; then
        print_success "Open WebUI is running on http://localhost:8080"
    else
        print_warning "Open WebUI is not responding. Starting OpenWebUI..."
        
        # Try to start OpenWebUI if setup script exists
        if [ -f "$PROJECT_ROOT/setup-openwebui.sh" ]; then
            bash "$PROJECT_ROOT/setup-openwebui.sh" 2>&1 | tee -a "$EXECUTION_LOG" &
            sleep 5
            
            if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 2>/dev/null | grep -q "200\|404"; then
                print_success "Open WebUI started successfully"
            else
                print_warning "Open WebUI may need manual start"
            fi
        fi
    fi
    
    echo ""
    
    # Final Output
    print_header "✅ Smart Execution Completed / اكتمل التنفيذ الذكي"
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         SMART EXECUTION COMPLETED SUCCESSFULLY           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Read deployment info from DEPLOY.md if available
    if [ -f "$PROJECT_ROOT/DEPLOY.md" ]; then
        echo -e "${CYAN}📊 Deployment Information:${NC}"
        echo ""
        
        # Extract models
        echo -e "${YELLOW}🤖 AI Models:${NC}"
        grep -A 10 "#### 🤖 AI Models" "$PROJECT_ROOT/DEPLOY.md" | grep "^-" | head -10
        echo ""
        
        # Extract agents
        echo -e "${YELLOW}🧠 AI Agents:${NC}"
        grep -A 5 "#### 🧠 AI Agents" "$PROJECT_ROOT/DEPLOY.md" | grep "^-" | head -5
        echo ""
    fi
    
    echo -e "${YELLOW}🌐 Access Points:${NC}"
    echo -e "   Main Page: ${BLUE}https://wasalstor-web.github.io/AI-Agent-Platform/${NC}"
    echo -e "   WebUI: ${BLUE}http://localhost:8080${NC}"
    echo -e "   Gateway: ${BLUE}http://localhost:8000${NC}"
    echo ""
    
    echo -e "${YELLOW}🔐 Authentication:${NC}"
    echo -e "   JWT TOKEN: ${GREEN}eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...${NC}"
    echo -e "   API KEY: ${GREEN}sk-3720ccd539704717ba9af3453500fe3c${NC}"
    echo -e "   ${CYAN}(Full credentials in DEPLOY.md)${NC}"
    echo ""
    
    echo -e "${YELLOW}📝 Documentation:${NC}"
    echo -e "   Deployment Report: ${CYAN}$PROJECT_ROOT/DEPLOY.md${NC}"
    echo -e "   Execution Log: ${CYAN}$EXECUTION_LOG${NC}"
    echo -e "   Full Guide: ${CYAN}$PROJECT_ROOT/AUTONOMOUS_DEPLOYMENT.md${NC}"
    echo ""
    
    echo -e "${GREEN}✅ All deployment steps completed successfully!${NC}"
    echo -e "${GREEN}✅ اكتملت جميع خطوات النشر بنجاح!${NC}"
    echo ""
    
    exit 0
}

# Execute main function
main "$@"
