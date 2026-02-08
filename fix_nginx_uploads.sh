#!/bin/bash
# Script to fix Nginx uploads configuration
# This fixes the image loading issue by correcting the /uploads location block

echo "=== Fixing Nginx uploads configuration ==="

# Backup current config
echo "Creating backup..."
sudo cp /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.backup.$(date +%Y%m%d_%H%M%S)

# Create temp file with the fix
cat > /tmp/nginx_uploads_fix.conf << 'NGINX_CONF'
    location /uploads {
        alias /opt/pomma/ResortApp/uploads;
        autoindex off;
        expires 30d;
        add_header Cache-Control "public";
        add_header X-Content-Type-Options "nosniff";
        add_header Access-Control-Allow-Origin "*";
        try_files $uri =404;
    }
NGINX_CONF

echo "
To apply the fix manually:
1. Edit: sudo nano /etc/nginx/sites-enabled/default
2. Find the 'location /uploads/' block (around line 70-75)
3. Replace it with the content from: cat /tmp/nginx_uploads_fix.conf
4. Key change: Remove trailing slashes: /uploads/ → /uploads
5. Test: sudo nginx -t
6. Reload: sudo systemctl reload nginx

The fix is in: /tmp/nginx_uploads_fix.conf
"

# Show the fix
echo "=== New configuration block ==="
cat /tmp/nginx_uploads_fix.conf

echo "
Run these commands to apply:
sudo nano /etc/nginx/sites-enabled/default
# (replace the location /uploads/ block)
sudo nginx -t
sudo systemctl reload nginx
"
