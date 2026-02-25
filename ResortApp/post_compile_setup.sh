#!/bin/bash
# ============================================================
# post_compile_setup.sh
# Run this AFTER every: python compile_backend.py
# Usage: sudo bash /opt/pomma/ResortApp/post_compile_setup.sh
# ============================================================

set -e

DIST_DIR="/opt/pomma/ResortApp/dist"
BASE_DIR="/opt/pomma/ResortApp"

echo "==> Setting up post-compile environment..."

# 1. Recreate uploads symlink (compile wipes dist/)
if [ -L "$DIST_DIR/uploads" ]; then
    echo "    uploads symlink already exists, skipping."
else
    echo "    Creating uploads symlink..."
    sudo mkdir -p "$BASE_DIR/uploads"
    sudo ln -s "$BASE_DIR/uploads" "$DIST_DIR/uploads"
fi

# 2. Recreate static symlink (compile wipes dist/)
if [ -L "$DIST_DIR/static" ]; then
    echo "    static symlink already exists, skipping."
else
    echo "    Creating static symlink..."
    sudo mkdir -p "$BASE_DIR/static/food_categories"
    sudo ln -s "$BASE_DIR/static" "$DIST_DIR/static"
fi

# 3. Ensure license.json exists and is writable by www-data
if [ ! -f "$DIST_DIR/license.json" ]; then
    echo "    Creating license.json..."
    sudo touch "$DIST_DIR/license.json"
fi
sudo chown www-data:www-data "$DIST_DIR/license.json"

# 4. Fix ownership for uploads and static
echo "    Fixing ownership for uploads and static..."
sudo chown -R www-data:www-data "$BASE_DIR/uploads/"
sudo chown -R www-data:www-data "$BASE_DIR/static/"
sudo chmod -R 755 "$BASE_DIR/uploads/"
sudo chmod -R 755 "$BASE_DIR/static/"

# 5. Restart the service
echo "    Restarting pomma.service..."
sudo systemctl restart pomma.service

echo ""
echo "==> Done! Checking service status..."
sudo systemctl status pomma.service --no-pager -l | head -20
