#!/bin/bash
set -e

echo "=========================================="
echo "FIXING RESORT BACKEND API"
echo "=========================================="

cd /var/www/resort/resort_production/ResortApp

# Add ROOT_PATH if not exists
if ! grep -q "^ROOT_PATH=" .env 2>/dev/null; then
    echo "ROOT_PATH=/resoapi" >> .env
    echo "✓ Added ROOT_PATH=/resoapi to .env"
else
    echo "✓ ROOT_PATH already exists in .env"
    grep "^ROOT_PATH=" .env
fi

# Restart service
echo ""
echo "Restarting resort.service..."
systemctl restart resort.service
sleep 5

# Check service status
echo ""
echo "Service status:"
systemctl status resort.service --no-pager | head -5

# Test backend
echo ""
echo "Testing backend..."
echo -n "  Direct (127.0.0.1:8012): "
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8012/api/resort-info/ || echo "FAILED"

echo -n "  Via Nginx (/resoapi/api/): "
curl -s -o /dev/null -w "%{http_code}\n" https://teqmates.com/resoapi/api/resort-info/ || echo "FAILED"

echo ""
echo "=========================================="
echo "FIX COMPLETE"
echo "=========================================="
echo "Please refresh https://teqmates.com/resort/"


