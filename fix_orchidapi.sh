#!/bin/bash
# Fix Orchid API Configuration

echo "=== Fixing Orchid API Configuration ==="

# Backup
cp /etc/nginx/sites-enabled/resort /etc/nginx/sites-enabled/resort.backup.orchidapi.$(date +%Y%m%d_%H%M%S)

# Find and replace orchidapi block
python3 << 'PYTHON_FIX'
import re

with open('/etc/nginx/sites-enabled/resort', 'r') as f:
    content = f.read()

# Pattern to match orchidapi location block
pattern = r'location /orchidapi/ \{.*?\n    \}'

# Correct orchidapi block
correct_block = '''    location /orchidapi/ {
        rewrite ^/orchidapi/(.*)$ /$1 break;
        proxy_pass http://orchid_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect ~^https?://[^/]+/api/(.*)$ /orchidapi/api/$1;
        proxy_redirect /api/ /orchidapi/api/;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }'''

# Replace if exists, otherwise find insertion point
if re.search(pattern, content, re.DOTALL):
    content = re.sub(pattern, correct_block, content, flags=re.DOTALL)
    print("Orchidapi block replaced")
else:
    # Find insertion point (after orchidapi location line)
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if 'location /orchidapi/' in line:
            # Find the end of this block
            brace_count = 0
            j = i
            while j < len(lines):
                brace_count += lines[j].count('{') - lines[j].count('}')
                j += 1
                if brace_count == 0:
                    break
            # Replace from i to j
            new_lines = lines[:i] + correct_block.split('\n') + lines[j:]
            content = '\n'.join(new_lines)
            print("Orchidapi block inserted")
            break

with open('/etc/nginx/sites-enabled/resort', 'w') as f:
    f.write(content)

print("Configuration updated")
PYTHON_FIX

# Test and reload
if nginx -t; then
    systemctl reload nginx
    systemctl restart orchid.service
    sleep 2
    echo ""
    echo "=== Verification ==="
    echo "Backend direct:"
    curl -s -o /dev/null -w "  http://127.0.0.1:8011/api/: %{http_code}\n" http://127.0.0.1:8011/api/
    echo "Via Nginx:"
    curl -s -o /dev/null -w "  https://teqmates.com/orchidapi/api/: %{http_code}\n" https://teqmates.com/orchidapi/api/
    echo ""
    echo "Service:"
    systemctl is-active orchid.service && echo "  ✓ orchid.service: RUNNING" || echo "  ✗ orchid.service: NOT RUNNING"
    echo ""
    echo "SUCCESS: Orchid API configuration fixed"
else
    echo "ERROR: Nginx configuration test failed"
    exit 1
fi

