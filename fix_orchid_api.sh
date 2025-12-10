#!/bin/bash

echo "=========================================="
echo "FIXING ORCHID API"
echo "=========================================="

# 1. Check orchid service status
echo ""
echo "1. Checking orchid.service status..."
systemctl status orchid.service --no-pager | head -10

# 2. Check if backend is listening on port 8011
echo ""
echo "2. Checking if backend is listening on port 8011..."
netstat -tlnp 2>/dev/null | grep 8011 || ss -tlnp | grep 8011 || echo "Port 8011 not found"

# 3. Test direct backend connection
echo ""
echo "3. Testing direct backend connection..."
curl -s -o /dev/null -w "Direct backend (127.0.0.1:8011/api/): HTTP %{http_code}\n" http://127.0.0.1:8011/api/ || echo "Backend not responding"

# 4. Check nginx configuration
echo ""
echo "4. Checking nginx configuration..."
if grep -q "location /orchidapi/" /etc/nginx/sites-enabled/resort; then
    echo "  ✓ /orchidapi/ location block exists"
else
    echo "  ✗ /orchidapi/ location block MISSING"
fi

if grep -q "upstream orchid_backend" /etc/nginx/sites-enabled/resort; then
    echo "  ✓ orchid_backend upstream exists"
else
    echo "  ✗ orchid_backend upstream MISSING"
fi

# 5. Check .env file for ROOT_PATH
echo ""
echo "5. Checking .env configuration..."
if [ -f /var/www/resort/orchid_production/ResortApp/.env ]; then
    echo "  .env file exists"
    if grep -q "ROOT_PATH" /var/www/resort/orchid_production/ResortApp/.env; then
        echo "  ROOT_PATH: $(grep ROOT_PATH /var/www/resort/orchid_production/ResortApp/.env)"
    else
        echo "  ✗ ROOT_PATH not set in .env"
    fi
else
    echo "  ✗ .env file not found"
fi

# 6. Check service logs
echo ""
echo "6. Recent service logs (last 10 lines):"
journalctl -u orchid.service -n 10 --no-pager | tail -5

# 7. Restart service
echo ""
echo "7. Restarting orchid.service..."
systemctl restart orchid.service
sleep 3

# 8. Check status after restart
echo ""
echo "8. Service status after restart:"
systemctl status orchid.service --no-pager | head -5

# 9. Test via nginx
echo ""
echo "9. Testing via nginx..."
curl -s -o /dev/null -w "Via nginx (/orchidapi/api/): HTTP %{http_code}\n" https://teqmates.com/orchidapi/api/ || echo "Nginx proxy failed"

# 10. Test nginx configuration
echo ""
echo "10. Testing nginx configuration..."
nginx -t 2>&1

echo ""
echo "=========================================="
echo "ORCHID API FIX COMPLETE"
echo "=========================================="

