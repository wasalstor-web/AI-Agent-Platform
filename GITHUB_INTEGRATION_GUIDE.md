# GITHUB_INTEGRATION_GUIDE.md

## Introduction
This guide provides complete documentation on how to use GitHub Actions to send commands to your Hostinger server.

## إعداد GitHub Actions مع Hostinger
هذا الدليل يوفر توثيقًا كاملاً حول كيفية استخدام GitHub Actions لإرسال الأوامر إلى خادم Hostinger.

## Setup Instructions
1. **Create a GitHub repository**.
2. **Set up GitHub Actions in your repository**:
   - Navigate to the "Actions" tab in your repository.
   - Choose a workflow template or create a new one.

3. **Configure Secrets**:
   - Go to Settings > Secrets and Variables > Actions.
   - Add your Hostinger credentials (e.g., username, password).

## مثال على الاستخدام
### English Example
```yaml
name: Deploy to Hostinger

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Deploy to Hostinger
        run: |
          ssh username@your_hostinger_ip 'your_command_here'
```

### مثال باللغة العربية
```yaml
name: نشر على Hostinger

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: سحب الكود
        uses: actions/checkout@v2

      - name: نشر على Hostinger
        run: |
          ssh username@your_hostinger_ip 'your_command_here'
```

## Troubleshooting
- Ensure SSH access is enabled on your Hostinger account.
- Check your GitHub Actions logs for any errors.

## Available Command Types
1. **Command Type 1**: Description...
2. **Command Type 2**: Description...
3. **Command Type 3**: Description...
4. **Command Type 4**: Description...
5. **Command Type 5**: Description...
6. **Command Type 6**: Description...
7. **Command Type 7**: Description...
8. **Command Type 8**: Description...
9. **Command Type 9**: Description...