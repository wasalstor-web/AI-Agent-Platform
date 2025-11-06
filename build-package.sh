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

# Copy essential deployment scripts
echo "  ✓ Deployment scripts"
cp DEPLOY-NOW.sh "$TEMP_DIR/" 2>/dev/null || true
cp deploy.sh "$TEMP_DIR/" 2>/dev/null || true
cp smart-deploy.sh "$TEMP_DIR/" 2>/dev/null || true
cp quick-start.sh "$TEMP_DIR/" 2>/dev/null || true
cp autonomous-deploy.sh "$TEMP_DIR/" 2>/dev/null || true

# Copy documentation
echo "  ✓ Documentation"
cp START-HERE.md "$TEMP_DIR/" 2>/dev/null || true
cp README.md "$TEMP_DIR/" 2>/dev/null || true
cp DEPLOYMENT.md "$TEMP_DIR/" 2>/dev/null || true
cp GITHUB-DOWNLOAD.txt "$TEMP_DIR/" 2>/dev/null || true
cp QUICK-START.md "$TEMP_DIR/" 2>/dev/null || true

# Copy configuration files
echo "  ✓ Configuration files"
cp .env.example "$TEMP_DIR/" 2>/dev/null || true
cp requirements.txt "$TEMP_DIR/" 2>/dev/null || true
cp .gitignore "$TEMP_DIR/" 2>/dev/null || true

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
