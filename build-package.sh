#!/bin/bash

#############################################################################
# Build Package Script
# Creates mubsat-deployment.tar.gz with all essential deployment files
#############################################################################

echo "🔨 Building deployment package..."
echo ""

# Package name
PACKAGE_NAME="mubsat-deployment.tar.gz"
TEMP_DIR="mubsat-deployment-temp"

# Clean up any previous builds
rm -rf "$TEMP_DIR" "$PACKAGE_NAME"

# Create temporary directory
mkdir -p "$TEMP_DIR"

echo "📦 Collecting essential files..."

# Define file lists
DEPLOYMENT_SCRIPTS=(
    "DEPLOY-NOW.sh"
    "deploy.sh"
    "smart-deploy.sh"
    "quick-start.sh"
    "autonomous-deploy.sh"
)

DOCUMENTATION=(
    "START-HERE.md"
    "README.md"
    "DEPLOYMENT.md"
    "GITHUB-DOWNLOAD.txt"
    "QUICK-START.md"
)

CONFIG_FILES=(
    ".env.example"
    "requirements.txt"
    ".gitignore"
)

# Copy deployment scripts
echo "  ✓ Deployment scripts"
for file in "${DEPLOYMENT_SCRIPTS[@]}"; do
    cp "$file" "$TEMP_DIR/" 2>/dev/null || true
done

# Copy documentation
echo "  ✓ Documentation"
for file in "${DOCUMENTATION[@]}"; do
    cp "$file" "$TEMP_DIR/" 2>/dev/null || true
done

# Copy configuration files
echo "  ✓ Configuration files"
for file in "${CONFIG_FILES[@]}"; do
    cp "$file" "$TEMP_DIR/" 2>/dev/null || true
done

# Copy API directory if it exists
if [ -d "api" ]; then
    echo "  ✓ API files"
    cp -r api "$TEMP_DIR/"
fi

# Copy index.html if it exists
if [ -f "index.html" ]; then
    echo "  ✓ Web interface"
    cp index.html "$TEMP_DIR/"
fi

# Create the package
echo ""
echo "📦 Creating compressed package..."
tar -czf "$PACKAGE_NAME" -C "$TEMP_DIR" .

# Clean up temp directory
rm -rf "$TEMP_DIR"

# Get file size
SIZE=$(du -h "$PACKAGE_NAME" | cut -f1)

echo ""
echo "✅ Package created successfully!"
echo ""
echo "📦 Package: $PACKAGE_NAME"
echo "📊 Size: $SIZE"
echo ""
echo "📋 Contents:"
tar -tzf "$PACKAGE_NAME" | head -20
echo ""
echo "✅ Ready to distribute!"
