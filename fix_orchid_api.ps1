# Fix Orchid API - Step by Step
$SSH_KEY = "$env:USERPROFILE\.ssh\server_ed25519"
$SERVER = "root@139.84.211.200"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "FIXING ORCHID API" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check service status
Write-Host "1. Checking orchid.service status..." -ForegroundColor Yellow
$status = ssh -i $SSH_KEY $SERVER "systemctl status orchid.service --no-pager 2>&1 | head -8"
Write-Host $status

# Step 2: Check if backend is running on port 8011
Write-Host ""
Write-Host "2. Checking if backend is listening on port 8011..." -ForegroundColor Yellow
$portCheck = ssh -i $SSH_KEY $SERVER "netstat -tlnp 2>/dev/null | grep 8011 || ss -tlnp | grep 8011 || echo 'Port 8011 not found'"
Write-Host $portCheck

# Step 3: Test direct backend connection
Write-Host ""
Write-Host "3. Testing direct backend connection..." -ForegroundColor Yellow
$directTest = ssh -i $SSH_KEY $SERVER "curl -s -o /dev/null -w 'Direct backend (127.0.0.1:8011/api/): HTTP %{http_code}' http://127.0.0.1:8011/api/ 2>&1 || echo 'Backend not responding'"
Write-Host $directTest

# Step 4: Check .env file for ROOT_PATH
Write-Host ""
Write-Host "4. Checking .env configuration..." -ForegroundColor Yellow
$envCheck = ssh -i $SSH_KEY $SERVER "if [ -f /var/www/resort/orchid_production/ResortApp/.env ]; then echo '.env exists'; grep ROOT_PATH /var/www/resort/orchid_production/ResortApp/.env || echo 'ROOT_PATH not set'; else echo '.env file not found'; fi"
Write-Host $envCheck

# Step 5: Check service logs
Write-Host ""
Write-Host "5. Recent service logs (last 10 lines):" -ForegroundColor Yellow
$logs = ssh -i $SSH_KEY $SERVER "journalctl -u orchid.service -n 10 --no-pager 2>&1 | tail -5"
Write-Host $logs

# Step 6: Check nginx configuration
Write-Host ""
Write-Host "6. Checking nginx configuration..." -ForegroundColor Yellow
$nginxCheck = ssh -i $SSH_KEY $SERVER "if grep -q 'location /orchidapi/' /etc/nginx/sites-enabled/resort; then echo '✓ /orchidapi/ location block exists'; else echo '✗ /orchidapi/ location block MISSING'; fi; if grep -q 'upstream orchid_backend' /etc/nginx/sites-enabled/resort; then echo '✓ orchid_backend upstream exists'; else echo '✗ orchid_backend upstream MISSING'; fi"
Write-Host $nginxCheck

# Step 7: Fix .env if ROOT_PATH is missing
Write-Host ""
Write-Host "7. Ensuring ROOT_PATH is set in .env..." -ForegroundColor Yellow
$fixEnv = ssh -i $SSH_KEY $SERVER "cd /var/www/resort/orchid_production/ResortApp && if ! grep -q '^ROOT_PATH=' .env 2>/dev/null; then echo 'ROOT_PATH=/orchidapi' >> .env && echo 'Added ROOT_PATH=/orchidapi'; else echo 'ROOT_PATH already exists'; fi"
Write-Host $fixEnv

# Step 8: Restart service
Write-Host ""
Write-Host "8. Restarting orchid.service..." -ForegroundColor Yellow
$restart = ssh -i $SSH_KEY $SERVER "systemctl restart orchid.service && sleep 3 && systemctl status orchid.service --no-pager 2>&1 | head -5"
Write-Host $restart

# Step 9: Test via nginx
Write-Host ""
Write-Host "9. Testing via nginx..." -ForegroundColor Yellow
$nginxTest = ssh -i $SSH_KEY $SERVER "curl -s -o /dev/null -w 'Via nginx (/orchidapi/api/): HTTP %{http_code}' https://teqmates.com/orchidapi/api/ 2>&1 || echo 'Nginx proxy failed'"
Write-Host $nginxTest

# Step 10: Reload nginx
Write-Host ""
Write-Host "10. Reloading nginx..." -ForegroundColor Yellow
$nginxReload = ssh -i $SSH_KEY $SERVER "nginx -t && systemctl reload nginx && echo 'Nginx reloaded successfully' || echo 'Nginx reload failed'"
Write-Host $nginxReload

# Step 11: Final verification
Write-Host ""
Write-Host "11. Final verification..." -ForegroundColor Yellow
$final = ssh -i $SSH_KEY $SERVER "echo 'Service:' && systemctl is-active orchid.service && echo 'Direct Backend:' && curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8011/api/ && echo '' && echo 'Via Nginx:' && curl -s -o /dev/null -w '%{http_code}' https://teqmates.com/orchidapi/api/ && echo ''"
Write-Host $final

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "ORCHID API FIX COMPLETE" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

