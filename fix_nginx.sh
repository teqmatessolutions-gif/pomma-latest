#!/bin/bash
# Fix nginx configuration for resort

# Backup current config
cp /etc/nginx/sites-enabled/resort /etc/nginx/sites-enabled/resort.backup.$(date +%Y%m%d_%H%M%S)

# Remove legacy redirects
sed -i '/# Legacy admin routes redirect/,/^    }$/d' /etc/nginx/sites-enabled/resort
sed -i '/# Legacy resort routes redirect/,/^    }$/d' /etc/nginx/sites-enabled/resort

# Remove any existing resort blocks
sed -i '/# Resort Demo/,/^    }$/d' /etc/nginx/sites-enabled/resort
sed -i '/location \/admin$/,/^    }$/d' /etc/nginx/sites-enabled/resort
sed -i '/location \/resort$/,/^    }$/d' /etc/nginx/sites-enabled/resort
sed -i '/location \/resoapi/,/^    }$/d' /etc/nginx/sites-enabled/resort
sed -i '/location \/resortfiles/,/^    }$/d' /etc/nginx/sites-enabled/resort

# Find the line number of the closing brace of the server block
LAST_BRACE=$(grep -n '^}' /etc/nginx/sites-enabled/resort | tail -1 | cut -d: -f1)

# Insert resort blocks before the last closing brace
sed -i "$((LAST_BRACE-1)) r /dev/stdin" /etc/nginx/sites-enabled/resort << 'EOF'

    # Resort Demo - Admin Dashboard
    location /admin {
        alias /var/www/resort/resort_production/dasboard/build;
        try_files $uri $uri/ /admin/index.html;
    }

    location /admin/static/ {
        alias /var/www/resort/resort_production/dasboard/build/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Resort Demo - User Frontend
    location /resort {
        alias /var/www/resort/resort_production/userend/userend/build;
        try_files $uri $uri/ /resort/index.html;
    }

    location /resort/static/uploads/ {
        alias /var/www/resort/resort_production/ResortApp/static/uploads/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location /resort/static/ {
        alias /var/www/resort/resort_production/userend/userend/build/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location /resortfiles/static/uploads/ {
        alias /var/www/resort/resort_production/ResortApp/static/uploads/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    location /resortfiles/ {
        alias /var/www/resort/resort_production/ResortApp/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Resort Demo - API routes
    location /resoapi/ {
        rewrite ^/resoapi/(.*)$ /$1 break;
        proxy_pass http://resort_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect ~^https?://[^/]+/api/(.*)$ /resoapi/api/$1;
        proxy_redirect /api/ /resoapi/api/;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
EOF

# Test and reload
nginx -t && systemctl reload nginx && echo "SUCCESS" || echo "FAILED"

