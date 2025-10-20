# GitHub Actions Workflows

This directory contains GitHub Actions workflows for the AI-Agent-Platform.

## Available Workflows

### 1. Deploy to GitHub Pages (`deploy-pages.yml`)
Automatically deploys the web interface to GitHub Pages on push to main branch.

**Triggers:**
- Push to `main` branch
- Manual dispatch

**Purpose:** Deploy the HTML interface and documentation to GitHub Pages

---

### 2. Execute Hostinger Commands (`hostinger-commands.yml`) ⭐ NEW

Complete integration with Hostinger server at 72.61.178.135:8000 for executing commands remotely.

**Triggers:**
- **Manual Dispatch:** Execute any of the 9 command types on-demand
- **Push to main/develop:** Automatic health checks and monitoring
- **Path-specific:** Triggers on changes to `dlplus/**` or `api/**`

**Supported Commands:**
1. `file_create` - Create files on server
2. `file_read` - Read files from server
3. `file_update` - Update files on server
4. `file_delete` - Delete files from server
5. `service_restart` - Restart services (openwebui, nginx, ollama)
6. `openwebui_manage` - Manage OpenWebUI (start, stop, restart, status)
7. `log_view` - View server logs
8. `status_check` - Check server status
9. `backup_create` - Create backups

**Jobs:**
- `execute-command` - Execute manual or auto-triggered commands
- `continuous-monitor` - Continuous health monitoring (5 checks with 10s intervals)
- `scheduled-sync` - Scheduled backups and log viewing

**Required Secrets:**
- `HOSTINGER_SERVER` - Server address (default: 72.61.178.135:8000)
- `HOSTINGER_API_KEY` - API key for authentication

**Setup:**
```bash
# Run the automated setup script
./setup-github-secrets.sh

# Or manually add secrets in GitHub:
# Settings > Secrets and Variables > Actions > New repository secret
```

**Usage:**

*Via GitHub UI:*
1. Go to Actions tab
2. Select "Execute Hostinger Commands"
3. Click "Run workflow"
4. Choose command type and provide JSON payload

*Via GitHub CLI:*
```bash
# Status check
gh workflow run hostinger-commands.yml \
  -f command_type=status_check \
  -f payload='{}'

# Create file
gh workflow run hostinger-commands.yml \
  -f command_type=file_create \
  -f payload='{"path": "test.txt", "content": "Hello from GitHub!"}'

# Restart service
gh workflow run hostinger-commands.yml \
  -f command_type=service_restart \
  -f payload='{"service": "openwebui"}'
```

**Artifacts:**
- `command-execution-logs-*` - Logs from command execution (30 days retention)
- `monitoring-logs-*` - Logs from continuous monitoring (7 days retention)

**Documentation:**
- [Complete Integration Guide](../GITHUB_ACTIONS_INTEGRATION.md)
- [Hostinger Command Execution Guide](../HOSTINGER_COMMAND_EXECUTION.md)
- [Examples](../examples/github_actions_examples.py)

---

## Setting Up Workflows

### Prerequisites
- GitHub repository with Actions enabled
- Hostinger server running at 72.61.178.135:8000 (for hostinger-commands workflow)
- GitHub CLI installed (optional, for command-line usage)

### Configuration

1. **Configure Secrets:**
   ```bash
   ./setup-github-secrets.sh
   ```

2. **Enable Workflows:**
   Workflows are automatically enabled when pushed to the repository.

3. **Test Workflows:**
   ```bash
   # List workflows
   gh workflow list
   
   # Trigger a workflow
   gh workflow run hostinger-commands.yml -f command_type=status_check -f payload='{}'
   
   # View runs
   gh run list --workflow=hostinger-commands.yml
   ```

## Monitoring Workflows

### View Workflow Runs
```bash
# List recent runs
gh run list

# View specific run
gh run view <run-id>

# View logs
gh run view <run-id> --log

# Download artifacts
gh run download <run-id>
```

### GitHub UI
1. Go to **Actions** tab in repository
2. Select a workflow from the left sidebar
3. Click on a specific run to view details
4. View logs and download artifacts

## Troubleshooting

### Workflow Failed
1. Check workflow logs in Actions tab
2. Verify secrets are configured correctly
3. Ensure server is reachable
4. Check server logs on Hostinger

### Secret Not Found
```bash
# List secrets
gh secret list

# Set secret
echo "value" | gh secret set SECRET_NAME
```

### Connection Timeout
- Verify server is running: `curl http://72.61.178.135:8000/api/health`
- Check firewall allows GitHub IPs
- Verify API key is correct

## Best Practices

1. **Use workflow_dispatch for sensitive commands** - Manual approval prevents accidents
2. **Monitor workflow logs regularly** - Stay informed of execution status
3. **Download artifacts for analysis** - Logs help debug issues
4. **Test in development first** - Use different secrets for dev/prod
5. **Rotate API keys periodically** - Enhance security
6. **Review workflow runs** - Ensure automation is working as expected

## Support

For help with workflows:
- Check [GITHUB_ACTIONS_INTEGRATION.md](../GITHUB_ACTIONS_INTEGRATION.md)
- Open an issue on GitHub
- Review workflow logs and artifacts

---

**Last Updated:** 2024-01-20  
**Workflows:** 2 active  
**Status:** ✅ All workflows operational
