# Quick Deploy Usage Example
# مثال على استخدام النشر السريع

## Complete Step-by-Step Guide
## دليل خطوة بخطوة كامل

This document shows you **exactly** how to use the instant deployment script.

### Prerequisites Check | فحص المتطلبات الأساسية

```bash
# 1. Check Docker is installed
docker --version
# Expected output: Docker version XX.XX.X, build XXXXXXX

# 2. Check Python is installed
python3 --version
# Expected output: Python 3.8.x or higher

# 3. Check OpenSSL is installed
openssl version
# Expected output: OpenSSL X.X.X
```

If any of these are missing, install them first:

```bash
# Install Docker (Ubuntu/Debian)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Python 3
sudo apt-get update
sudo apt-get install python3 python3-pip python3-venv

# OpenSSL is usually pre-installed on Linux/macOS
```

### Step-by-Step Deployment | النشر خطوة بخطوة

#### Step 1: Clone the Repository | استنساخ المستودع

```bash
# Clone the repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform
```

#### Step 2: Create Configuration | إنشاء التكوين

```bash
# Copy the example configuration file
cp .env.instant-deploy.example .env.instant-deploy
```

#### Step 3: Generate Secure Keys | توليد المفاتيح الآمنة

```bash
# Generate a secure API key
API_KEY="sk-$(openssl rand -hex 32)"
echo "Generated API Key: $API_KEY"

# Generate a secure secret key
SECRET_KEY=$(openssl rand -hex 32)
echo "Generated Secret Key: $SECRET_KEY"

# Generate a JWT token (simple random token for demo)
JWT_TOKEN=$(openssl rand -hex 64)
echo "Generated JWT Token: $JWT_TOKEN"

# Update the configuration file with generated keys
cat > .env.instant-deploy << EOF
# Instant Deployment Configuration
# Auto-generated on $(date)

# DL+ Backend Configuration
DLPLUS_API_KEY=$API_KEY
DLPLUS_JWT_TOKEN=$JWT_TOKEN
DLPLUS_PORT=8000

# OpenWebUI Configuration
OPENWEBUI_PORT=3000
OPENWEBUI_VERSION=main
WEBUI_SECRET_KEY=$SECRET_KEY
ENABLE_SIGNUP=true
ENABLE_API_KEY=true

# Integration Settings
OPENAI_API_BASE_URL=http://host.docker.internal:8000/api
EOF

echo "✅ Configuration file created with secure keys!"
```

**IMPORTANT:** Save these keys somewhere safe! You'll need them to access the API.

#### Step 4: Verify Configuration | التحقق من التكوين

```bash
# Check that the configuration file is created
ls -lh .env.instant-deploy

# Verify it's not in git (for security)
git status | grep .env.instant-deploy
# Should show nothing (file is ignored)

# View the configuration (optional - be careful not to share this!)
cat .env.instant-deploy
```

#### Step 5: Run Deployment | تشغيل النشر

```bash
# Make sure the script is executable
chmod +x quick-deploy-openwebui.sh

# Run the deployment
./quick-deploy-openwebui.sh
```

**Expected Output:**

```
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║         🚀 Quick Deploy: OpenWebUI + DL+ Backend                        ║
║            نشر سريع: OpenWebUI + DL+ Backend                           ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️  تحميل التكوين | Loading Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ تم تحميل التكوين | Configuration loaded

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚡ [1/5] تشغيل DL+ Backend | Starting DL+ Backend
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ DL+ Backend جاهز | DL+ Backend ready

...
```

#### Step 6: Access the Services | الوصول إلى الخدمات

After deployment completes, you'll see:

```
╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║         🎉 تم التشغيل بنجاح! SUCCESSFULLY RUNNING! 🎉                  ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝

📍 روابط الوصول | Access URLs:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   🌐 OpenWebUI:      http://localhost:3000
   🔧 DL+ API:        http://localhost:8000
   📖 Docs:           http://localhost:8000/api/docs
   📄 Dashboard:      ~/openwebui-dashboard.html
```

**Now you can:**

1. **Open your browser** to http://localhost:3000
2. **Create an account** (first user becomes admin)
3. **Start chatting** with AI models!

### Using OpenWebUI | استخدام OpenWebUI

#### First Time Setup

1. **Navigate to** http://localhost:3000
2. **Click "Sign Up"**
3. **Enter your details:**
   - Email: your-email@example.com
   - Password: (choose a strong password)
   - Confirm password
4. **Click "Create Account"**
5. **You're now logged in as admin!**

#### Chatting with AI Models

1. **Select a model** from the dropdown (top of chat interface)
   - AraBERT (for Arabic processing)
   - Qwen (for Arabic text generation)
   - LLaMA 3 (general purpose)
   - DeepSeek (code generation)
   - Mistral (multilingual)
   - CAMeLBERT (named entities)

2. **Type your message** in the chat box

3. **Press Enter** or click Send

4. **See the AI response** in real-time!

### Example Conversations | محادثات مثالية

#### Example 1: Arabic Conversation

```
You: مرحبا، كيف يمكنك مساعدتي؟
AI (AraBERT): مرحبا بك! أنا نموذج ذكاء صناعي متخصص في اللغة العربية. 
              يمكنني مساعدتك في الإجابة على الأسئلة، تحليل النصوص، 
              والمساعدة في المهام المتعلقة باللغة العربية.
```

#### Example 2: Code Generation

```
You: Write a Python function to calculate fibonacci numbers
AI (DeepSeek): Here's a Python function to calculate Fibonacci numbers:

def fibonacci(n):
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    
    fib = [0, 1]
    for i in range(2, n):
        fib.append(fib[i-1] + fib[i-2])
    return fib

# Example usage:
print(fibonacci(10))  # Output: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

### Management Commands | أوامر الإدارة

#### Check Status | فحص الحالة

```bash
# Check if OpenWebUI is running
docker ps | grep open-webui

# Expected output:
# CONTAINER ID   IMAGE                              STATUS          PORTS
# abc123...      ghcr.io/open-webui/open-webui:main Up 5 minutes   0.0.0.0:3000->8080/tcp
```

#### View Logs | عرض السجلات

```bash
# View OpenWebUI logs
docker logs -f open-webui

# View DL+ Backend logs
tail -f /tmp/dlplus.log
```

#### Restart Services | إعادة تشغيل الخدمات

```bash
# Restart OpenWebUI
docker restart open-webui

# Restart DL+ Backend
pkill -f "python.*dlplus/main.py"
./start-dlplus.sh
```

#### Stop Services | إيقاف الخدمات

```bash
# Stop OpenWebUI
docker stop open-webui

# Stop DL+ Backend
pkill -f "python.*dlplus/main.py"
```

### Troubleshooting Common Issues | حل المشاكل الشائعة

#### Issue 1: Port 3000 already in use

```bash
# Find what's using port 3000
sudo lsof -i :3000

# Kill the process
sudo kill -9 <PID>

# Or use a different port in .env.instant-deploy
# Change OPENWEBUI_PORT=3000 to OPENWEBUI_PORT=3001
```

#### Issue 2: Docker permission denied

```bash
# Add your user to docker group
sudo usermod -aG docker $USER

# Log out and log back in for changes to take effect
# Or run this:
newgrp docker
```

#### Issue 3: Can't access http://localhost:3000

```bash
# Check if Docker container is running
docker ps | grep open-webui

# Check Docker logs for errors
docker logs open-webui

# Try accessing via 127.0.0.1 instead
curl http://127.0.0.1:3000
```

### Security Best Practices | أفضل ممارسات الأمان

1. **Never share `.env.instant-deploy` file**
   - Contains your API keys and secrets
   - Keep it private and secure

2. **Use strong, unique passwords**
   - For OpenWebUI accounts
   - Change default admin password

3. **Keep keys secure**
   - Don't commit to git
   - Don't share in screenshots
   - Rotate regularly

4. **Set proper file permissions**
   ```bash
   chmod 600 .env.instant-deploy
   ```

5. **Use HTTPS in production**
   - Set up reverse proxy (Nginx)
   - Get SSL certificate (Let's Encrypt)

### Next Steps | الخطوات التالية

1. **Explore the AI models**
   - Try different models for different tasks
   - Compare their responses

2. **Configure custom settings**
   - Adjust ports if needed
   - Change OpenWebUI version

3. **Set up for production**
   - Configure domain name
   - Set up SSL/HTTPS
   - Configure firewall

4. **Read full documentation**
   - [Quick Deploy Guide](QUICK_DEPLOY_GUIDE.md)
   - [OpenWebUI Documentation](OPENWEBUI.md)
   - [DL+ System Documentation](DLPLUS_README.md)

## Summary | الملخص

You have successfully:
- ✅ Generated secure API keys
- ✅ Configured the deployment
- ✅ Deployed OpenWebUI + DL+ Backend
- ✅ Created your first account
- ✅ Started chatting with AI!

**Enjoy your AI Agent Platform!**

---

**Questions?** Check the [troubleshooting section](QUICK_DEPLOY_GUIDE.md#troubleshooting) or open an issue on GitHub.
