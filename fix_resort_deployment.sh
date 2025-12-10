#!/bin/bash
# Fix Resort Deployment - Run this on the server

echo "=== Fixing Resort Deployment ==="
echo ""

# 1. Check and build userend
echo "1. Building userend..."
cd /var/www/resort/resort_production/userend/userend
if [ ! -f build/index.html ]; then
    npm install --legacy-peer-deps
    npm run build
else
    echo "   Userend build already exists"
fi

# 2. Check and build dashboard
echo "2. Building dashboard..."
cd /var/www/resort/resort_production/dasboard
if [ ! -f build/index.html ]; then
    npm install --legacy-peer-deps
    npm run build
else
    echo "   Dashboard build already exists"
fi

# 3. Set permissions
echo "3. Setting permissions..."
chown -R www-data:www-data /var/www/resort/resort_production/userend/userend/build
chown -R www-data:www-data /var/www/resort/resort_production/dasboard/build
chmod -R 755 /var/www/resort/resort_production/userend/userend/build
chmod -R 755 /var/www/resort/resort_production/dasboard/build
mkdir -p /var/www/resort/resort_production/ResortApp/uploads
mkdir -p /var/www/resort/resort_production/ResortApp/static/uploads
chown -R www-data:www-data /var/www/resort/resort_production/ResortApp

# 4. Verify nginx config
echo "4. Verifying nginx configuration..."
nginx -t

# 5. Reload nginx
echo "5. Reloading nginx..."
systemctl reload nginx

# 6. Restart resort service
echo "6. Restarting resort service..."
systemctl restart resort.service

# 7. Final verification
echo ""
echo "=== Verification ==="
echo "Userend build: $([ -f /var/www/resort/resort_production/userend/userend/build/index.html ] && echo '✓ EXISTS' || echo '✗ MISSING')"
echo "Dashboard build: $([ -f /var/www/resort/resort_production/dasboard/build/index.html ] && echo '✓ EXISTS' || echo '✗ MISSING')"
echo "Resort service: $(systemctl is-active resort.service 2>/dev/null && echo '✓ RUNNING' || echo '✗ NOT RUNNING')"
echo "Nginx: $(systemctl is-active nginx 2>/dev/null && echo '✓ RUNNING' || echo '✗ NOT RUNNING')"
echo ""
echo "Test URLs:"
echo "  https://teqmates.com/resort/"
echo "  https://teqmates.com/admin/"
echo "  https://teqmates.com/resoapi/api/"

