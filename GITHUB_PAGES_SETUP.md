# GitHub Pages Setup Instructions

## Automatic Setup

Once this branch is merged to `main`, GitHub Pages will be automatically deployed via GitHub Actions.

## Accessing Your Site

**Live URL:** [https://wasalstor-web.github.io/AI-Agent-Platform/](https://wasalstor-web.github.io/AI-Agent-Platform/)

## Manual Configuration (if needed)

If GitHub Pages is not automatically enabled after merging, follow these steps:

1. Go to your repository on GitHub: https://github.com/wasalstor-web/AI-Agent-Platform
2. Click on **Settings** tab
3. Scroll down to **Pages** section in the left sidebar
4. Under **Source**, select:
   - Source: **GitHub Actions**
5. Save the settings

## Workflow Details

The deployment workflow (`.github/workflows/deploy-pages.yml`) will:
- Trigger automatically on every push to the `main` branch
- Can be manually triggered from the Actions tab
- Deploy all files from the repository root
- Make the site available at the GitHub Pages URL

## Redeployment

The site will automatically redeploy when:
- Changes are pushed to the `main` branch
- The workflow is manually triggered from GitHub Actions tab

## Troubleshooting

If the site is not accessible:
1. Check the **Actions** tab to see if the workflow ran successfully
2. Verify GitHub Pages is enabled in repository settings
3. Wait a few minutes after the first deployment (initial setup can take time)
4. Ensure the repository is public or your organization has GitHub Pages enabled for private repos

## Arabic Translation / الترجمة العربية

**رابط الموقع المباشر:** [https://wasalstor-web.github.io/AI-Agent-Platform/](https://wasalstor-web.github.io/AI-Agent-Platform/)

سيتم نشر الموقع تلقائياً عند دمج هذا الفرع مع `main`. الموقع سيكون متاحاً على الرابط أعلاه.

### إعداد يدوي (إذا لزم الأمر):
1. اذهب إلى صفحة المستودع على GitHub
2. اضغط على تبويب **Settings**
3. اختر **Pages** من القائمة الجانبية
4. تحت **Source**، اختر **GitHub Actions**
5. احفظ الإعدادات

سيتم إعادة نشر الموقع تلقائياً عند كل تحديث يتم دفعه إلى الفرع الرئيسي `main`.
