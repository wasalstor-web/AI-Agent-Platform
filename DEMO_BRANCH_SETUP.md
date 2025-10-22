# Demo Branch Setup Instructions

This document provides instructions for setting up the `demo/openweb-preview` branch for GitHub Pages deployment.

## What is the demo/openweb-preview branch?

The `demo/openweb-preview` branch is specifically designed to host the OpenWebUI interface on GitHub Pages. It contains the static web application files in the `docs/` directory.

## Setup Instructions

### Option 1: Using GitHub Web Interface (Recommended)

1. Go to the repository on GitHub: https://github.com/wasalstor-web/AI-Agent-Platform
2. Click on the "Branch" dropdown (currently showing "main" or your current branch)
3. Type "demo/openweb-preview" in the search box
4. Click "Create branch: demo/openweb-preview from 'copilot/clone-repository'"
5. Once created, the GitHub Actions workflow will automatically deploy to GitHub Pages

### Option 2: Using Git Commands (If you have push access)

```bash
# Clone the repository
git clone https://github.com/wasalstor-web/AI-Agent-Platform.git
cd AI-Agent-Platform

# Create and checkout the demo branch from copilot/clone-repository
git checkout copilot/clone-repository
git checkout -b demo/openweb-preview

# Push the branch to GitHub
git push -u origin demo/openweb-preview
```

## Enabling GitHub Pages

After creating the branch:

1. Go to repository Settings
2. Navigate to "Pages" in the left sidebar
3. Under "Source":
   - Branch: Select `demo/openweb-preview`
   - Folder: Select `/docs`
4. Click "Save"
5. Wait a few minutes for the deployment to complete
6. Your site will be available at: https://wasalstor-web.github.io/AI-Agent-Platform/

## GitHub Actions Workflow

The workflow file `.github/workflows/openweb-pages.yml` will automatically:
- Build the interface when changes are pushed to `main` or `demo/openweb-preview`
- Run deployment scripts (with error handling)
- Deploy the `docs/` directory to GitHub Pages
- Send notifications about deployment status

## Files in the docs/ Directory

- `index.html` - Main web interface
- `styles.css` - Styling and layout
- `app.js` - Interactive functionality
- `README.md` - Documentation
- `FINAL_REPORT.md` - Comprehensive deployment report

## Verifying Deployment

After deployment:
1. Visit: https://wasalstor-web.github.io/AI-Agent-Platform/
2. Check that all sections work:
   - Models section
   - Agents section
   - Chat interface
   - Documentation links
   - System status
3. Test on mobile and desktop browsers

## Troubleshooting

### Site not appearing?
- Check GitHub Pages settings in repository Settings > Pages
- Verify the branch is set to `demo/openweb-preview`
- Verify the folder is set to `/docs`
- Wait up to 10 minutes for initial deployment

### Workflow failing?
- Check the Actions tab for error logs
- Most deployment scripts have continue-on-error enabled
- The static interface should deploy even if scripts fail

### Updates not showing?
- GitHub Pages may cache for a few minutes
- Try hard refresh (Ctrl+Shift+R or Cmd+Shift+R)
- Check the Actions tab to see if workflow completed

## Current Status

✅ All files created and ready for deployment  
✅ GitHub Actions workflow configured  
✅ Full OpenWebUI interface with 6 AI models  
✅ 3 AI agents documented  
✅ Arabic and English support  
✅ Responsive design  

**Ready for deployment to GitHub Pages!**
