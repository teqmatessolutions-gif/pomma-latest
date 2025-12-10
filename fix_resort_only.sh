#!/bin/bash

echo "=========================================="
echo "FIXING RESORT BACKEND API ONLY"
echo "(Not touching Pomma or Orchid)"
echo "=========================================="
echo ""

# 1. Check service status
echo "1. Checking resort.service status..."
systemctl status resort.service --no-pager | head -5

# 2. Ensure ROOT_PATH is set in .env
echo ""
echo "2. Ensuring ROOT_PATH is set..."
cd /var/www/resort/resort_production/ResortApp
if ! grep -q "^ROOT_PATH=" .env 2>/dev/null; then
    echo "ROOT_PATH=/resoapi" >> .env
    echo "  ✓ Added ROOT_PATH=/resoapi"
else
    echo "  ✓ ROOT_PATH already exists:"
    grep ROOT_PATH .env
fi

# 3. Check database connection
echo ""
echo "3. Checking database configuration..."
if grep -q "DATABASE_URL" .env; then
    echo "  ✓ DATABASE_URL is set"
else
    echo "  ✗ DATABASE_URL not found"
fi

# 4. Restart service
echo ""
echo "4. Restarting resort.service..."
systemctl restart resort.service
sleep 5

# 5. Check service status after restart
echo ""
echo "5. Service status after restart:"
systemctl status resort.service --no-pager | head -5

# 6. Test backend directly
echo ""
echo "6. Testing backend directly..."
curl -s -o /dev/null -w "  Direct backend (127.0.0.1:8012/api/): HTTP %{http_code}\n" http://127.0.0.1:8012/api/ || echo "  ✗ Backend not responding"

# 7. Test specific endpoint
echo ""
echo "7. Testing /api/resort-info/ endpoint..."
curl -s -o /dev/null -w "  Direct: HTTP %{http_code}\n" http://127.0.0.1:8012/api/resort-info/ || echo "  ✗ Endpoint not responding"

# 8. Test via nginx
echo ""
echo "8. Testing via nginx..."
curl -s -o /dev/null -w "  Via nginx (/resoapi/api/): HTTP %{http_code}\n" https://teqmates.com/resoapi/api/ || echo "  ✗ Nginx proxy failed"

# 9. Test resort-info via nginx
echo ""
echo "9. Testing /resoapi/api/resort-info/ via nginx..."
curl -s -o /dev/null -w "  Via nginx: HTTP %{http_code}\n" https://teqmates.com/resoapi/api/resort-info/ || echo "  ✗ Nginx proxy failed"

# 10. Final status
echo ""
echo "10. Final Status:"
echo "  Service: $(systemctl is-active resort.service)"
echo "  Direct Backend: $(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8012/api/ 2>/dev/null || echo 'FAILED')"
echo "  Via Nginx: $(curl -s -o /dev/null -w '%{http_code}' https://teqmates.com/resoapi/api/ 2>/dev/null || echo 'FAILED')"

echo ""
echo "=========================================="
echo "RESORT BACKEND FIX COMPLETE"
echo "=========================================="


