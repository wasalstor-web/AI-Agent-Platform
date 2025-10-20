# GitHub Actions Integration with Hostinger Server

Complete guide for executing commands on Hostinger server from GitHub Actions.

## 🚀 Quick Start

### 1. Setup GitHub Secrets

Run the automated setup script:

```bash
./setup-github-secrets.sh
```

Or manually configure secrets in GitHub:
- Go to: `Settings > Secrets and Variables > Actions`
- Add secrets:
  - `HOSTINGER_SERVER` = `your-server-address:port` (e.g., `hostname:8000`)
  - `HOSTINGER_API_KEY` = Your API key

### 2. Trigger Workflow

**Via GitHub UI:**
1. Go to `Actions` tab
2. Select `Execute Hostinger Commands` workflow
3. Click `Run workflow`
4. Choose command type and provide payload

**Via GitHub CLI:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=status_check \
  -f payload='{}'
```

**Automatic Triggers:**
- Pushes to `main` or `develop` branches automatically run health checks
- Changes to `dlplus/**` or `api/**` trigger monitoring

## 📋 Supported Commands

The integration supports 9 command types:

### 1. file_create
Create files on Hostinger server.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=file_create \
  -f payload='{"path": "data/test.txt", "content": "Hello from GitHub!"}'
```

**Payload:**
```json
{
  "path": "relative/path/to/file.txt",
  "content": "File content here"
}
```

### 2. file_read
Read files from Hostinger server.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=file_read \
  -f payload='{"path": "data/test.txt"}'
```

**Payload:**
```json
{
  "path": "relative/path/to/file.txt"
}
```

### 3. file_update
Update existing files on Hostinger server.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=file_update \
  -f payload='{"path": "data/test.txt", "content": "Updated content"}'
```

**Payload:**
```json
{
  "path": "relative/path/to/file.txt",
  "content": "New content"
}
```

### 4. file_delete
Delete files from Hostinger server.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=file_delete \
  -f payload='{"path": "data/test.txt"}'
```

**Payload:**
```json
{
  "path": "relative/path/to/file.txt"
}
```

### 5. service_restart
Restart services on Hostinger server.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=service_restart \
  -f payload='{"service": "openwebui"}'
```

**Payload:**
```json
{
  "service": "openwebui"  // or "nginx", "ollama"
}
```

**Allowed services:**
- `openwebui` - OpenWebUI interface
- `nginx` - Web server
- `ollama` - Ollama AI service

### 6. openwebui_manage
Manage OpenWebUI service.

**Examples:**
```bash
# Start OpenWebUI
gh workflow run hostinger-commands.yml \
  -f command_type=openwebui_manage \
  -f payload='{"action": "start"}'

# Stop OpenWebUI
gh workflow run hostinger-commands.yml \
  -f command_type=openwebui_manage \
  -f payload='{"action": "stop"}'

# Restart OpenWebUI
gh workflow run hostinger-commands.yml \
  -f command_type=openwebui_manage \
  -f payload='{"action": "restart"}'

# Check status
gh workflow run hostinger-commands.yml \
  -f command_type=openwebui_manage \
  -f payload='{"action": "status"}'
```

**Payload:**
```json
{
  "action": "start"  // or "stop", "restart", "status"
}
```

### 7. log_view
View logs from Hostinger server.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=log_view \
  -f payload='{"log_type": "execution", "lines": 50}'
```

**Payload:**
```json
{
  "log_type": "execution",  // or "system", "error"
  "lines": 50               // number of lines to view
}
```

### 8. status_check
Check Hostinger server status and health.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=status_check \
  -f payload='{}'
```

**Payload:**
```json
{}  // Empty payload
```

### 9. backup_create
Create backups on Hostinger server.

**Example:**
```bash
gh workflow run hostinger-commands.yml \
  -f command_type=backup_create \
  -f payload='{"type": "full"}'
```

**Payload:**
```json
{
  "type": "full"  // or "partial", "scheduled"
}
```

## 🔄 Continuous Connection Features

### Automatic Health Monitoring
The workflow automatically monitors server health on every push to main/develop branches:

```yaml
# Triggered automatically on push
- Checks server status
- Runs 5 health checks with 10-second intervals
- Uploads monitoring logs
- Creates artifacts for review
```

### Permanent Connection
The integration maintains a permanent connection through:

1. **Push Triggers**: Automatic monitoring on code changes
2. **Scheduled Runs**: Optional cron-based execution
3. **Manual Triggers**: On-demand command execution
4. **Retry Logic**: Exponential backoff with 5 retries
5. **Health Checks**: Continuous server monitoring

## 🛠️ Advanced Usage

### Using github-commander.py Directly

```bash
# Set environment variables
export HOSTINGER_SERVER="your-server-address:port"
export HOSTINGER_API_KEY="your-api-key"

# Execute command
python3 github-commander.py status_check '{}'

# Create file
python3 github-commander.py file_create '{"path": "test.txt", "content": "Hello"}'

# Interactive mode
python3 github-commander.py
```

### Environment Variables

Configure via environment variables:

```bash
export HOSTINGER_SERVER="your-server-address:port"  # Server address
export HOSTINGER_API_KEY="your-api-key"             # API key
export RETRY_LIMIT="5"                              # Number of retries
export RETRY_DELAY="3"                              # Initial delay (seconds)
export CONNECTION_TIMEOUT="30"                      # Request timeout (seconds)
```

### Workflow Customization

Edit `.github/workflows/hostinger-commands.yml` to customize:

- Add more triggers (schedule, pull_request, etc.)
- Modify monitoring frequency
- Add custom command sequences
- Configure notifications
- Adjust artifact retention

## 📊 Monitoring and Logs

### View Workflow Runs

```bash
# List recent workflow runs
gh run list --workflow=hostinger-commands.yml

# View specific run
gh run view <run-id>

# View logs
gh run view <run-id> --log
```

### Download Artifacts

```bash
# List artifacts
gh run view <run-id> --json artifacts

# Download artifact
gh run download <run-id>
```

### Log Files

Execution logs are automatically uploaded as artifacts:
- `command-execution-logs-*` - Command execution logs
- `monitoring-logs-*` - Continuous monitoring logs

## 🔒 Security Best Practices

### API Key Management
- ✅ Store API keys in GitHub Secrets
- ✅ Never commit API keys to repository
- ✅ Rotate keys periodically
- ✅ Use different keys for dev/prod
- ❌ Don't share keys in logs or outputs

### Server Security
- Enable HTTPS when possible
- Use firewall to restrict access
- Monitor execution logs
- Implement rate limiting
- Validate all inputs

### Workflow Security
- Limit workflow permissions
- Use `workflow_dispatch` for sensitive commands
- Review workflow logs regularly
- Enable branch protection rules
- Require pull request reviews

## 🐛 Troubleshooting

### Connection Failed

**Problem:** Cannot connect to Hostinger server

**Solutions:**
1. Verify server is running: `curl http://$HOSTINGER_SERVER/api/health`
2. Check firewall rules allow GitHub IPs
3. Verify HOSTINGER_SERVER secret is correct
4. Check server logs for errors

### Authentication Failed

**Problem:** Invalid API key error

**Solutions:**
1. Verify HOSTINGER_API_KEY secret matches server configuration
2. Check API key format (should start with `aip_`)
3. Ensure API key hasn't expired
4. Regenerate key if necessary

### Command Failed

**Problem:** Command execution fails

**Solutions:**
1. Verify command type is supported
2. Check payload format is valid JSON
3. Review command-specific requirements
4. Check server has necessary permissions
5. View execution logs for details

### Workflow Doesn't Trigger

**Problem:** Workflow doesn't run automatically

**Solutions:**
1. Check workflow file syntax: `gh workflow view hostinger-commands.yml`
2. Verify push is to correct branch (main/develop)
3. Ensure paths match trigger patterns
4. Check workflow is enabled in Actions tab

## 📚 Additional Resources

### Documentation Files
- [HOSTINGER_COMMAND_EXECUTION.md](HOSTINGER_COMMAND_EXECUTION.md) - Detailed command reference
- [GITHUB_INTEGRATION_GUIDE.md](GITHUB_INTEGRATION_GUIDE.md) - General integration guide
- [DLPLUS_README.md](DLPLUS_README.md) - DL+ system documentation

### Scripts
- `setup-github-secrets.sh` - Automated secrets configuration
- `github-commander.py` - Command execution script
- `start-dlplus.sh` - Start DL+ system on Hostinger

### Workflow File
- `.github/workflows/hostinger-commands.yml` - Main workflow definition

## 🤝 Support

For issues and questions:
- Open an issue on GitHub
- Review workflow logs
- Check server logs on Hostinger
- Consult documentation files

## ✨ Features Summary

✅ **9 Command Types** - Complete command coverage  
✅ **Retry Logic** - Exponential backoff with 5 retries  
✅ **Health Monitoring** - Automatic continuous monitoring  
✅ **Permanent Connection** - Multiple trigger mechanisms  
✅ **Secure** - GitHub Secrets integration  
✅ **Automated Setup** - One-command configuration  
✅ **Comprehensive Logs** - Detailed execution tracking  
✅ **Artifact Storage** - Log retention and analysis  
✅ **Manual & Auto Triggers** - Flexible execution  
✅ **Well Documented** - Complete usage guide  

## 🎯 Example Workflows

### Deploy and Restart

```bash
# 1. Create deployment file
gh workflow run hostinger-commands.yml \
  -f command_type=file_create \
  -f payload='{"path": "deploy/version.txt", "content": "v1.0.0"}'

# 2. Restart service
gh workflow run hostinger-commands.yml \
  -f command_type=service_restart \
  -f payload='{"service": "openwebui"}'

# 3. Check status
gh workflow run hostinger-commands.yml \
  -f command_type=status_check \
  -f payload='{}'
```

### Backup and Verify

```bash
# 1. Create backup
gh workflow run hostinger-commands.yml \
  -f command_type=backup_create \
  -f payload='{"type": "full"}'

# 2. View logs
gh workflow run hostinger-commands.yml \
  -f command_type=log_view \
  -f payload='{"log_type": "execution", "lines": 100}'
```

### Monitor OpenWebUI

```bash
# Check status
gh workflow run hostinger-commands.yml \
  -f command_type=openwebui_manage \
  -f payload='{"action": "status"}'

# Restart if needed
gh workflow run hostinger-commands.yml \
  -f command_type=openwebui_manage \
  -f payload='{"action": "restart"}'
```

---

**Last Updated:** 2024-01-20  
**Version:** 1.0.0  
**Integration Status:** ✅ Complete
