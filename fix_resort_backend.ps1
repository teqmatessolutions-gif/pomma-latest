# Fix Resort Backend API Connectivity
$SSH_KEY = "$env:USERPROFILE\.ssh\server_ed25519"
$SERVER = "root@139.84.211.200"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "FIXING RESORT BACKEND API" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check service status
Write-Host "1. Checking resort.service status..." -ForegroundColor Yellow
$status = ssh -i $SSH_KEY $SERVER "systemctl status resort.service --no-pager 2>&1 | head -5"
Write-Host $status

# Step 2: Check if backend is running on port 8012
Write-Host ""
Write-Host "2. Checking if backend is listening on port 8012..." -ForegroundColor Yellow
$portCheck = ssh -i $SSH_KEY $SERVER "netstat -tlnp 2>/dev/null | grep 8012 || ss -tlnp | grep 8012 || echo 'Port 8012 not found'"
Write-Host $portCheck

# Step 3: Test direct backend connection
Write-Host ""
Write-Host "3. Testing direct backend connection..." -ForegroundColor Yellow
$directTest = ssh -i $SSH_KEY $SERVER "curl -s -o /dev/null -w 'Direct backend (127.0.0.1:8012/api/): HTTP %{http_code}' http://127.0.0.1:8012/api/ 2>&1 || echo 'Backend not responding'"
Write-Host $directTest

# Step 4: Check .env file for ROOT_PATH
Write-Host ""
Write-Host "4. Checking .env configuration..." -ForegroundColor Yellow
$envCheck = ssh -i $SSH_KEY $SERVER "cd /var/www/resort/resort_production/ResortApp && if [ -f .env ]; then echo '.env exists'; grep ROOT_PATH .env || echo 'ROOT_PATH not set'; else echo '.env file not found'; fi"
Write-Host $envCheck

# Step 5: Add ROOT_PATH if missing
Write-Host ""
Write-Host "5. Ensuring ROOT_PATH is set..." -ForegroundColor Yellow
$fixEnv = ssh -i $SSH_KEY $SERVER "cd /var/www/resort/resort_production/ResortApp && if ! grep -q '^ROOT_PATH=' .env 2>/dev/null; then echo 'ROOT_PATH=/resoapi' >> .env && echo 'Added ROOT_PATH=/resoapi'; else echo 'ROOT_PATH already exists'; grep ROOT_PATH .env; fi"
Write-Host $fixEnv

# Step 6: Check service logs
Write-Host ""
Write-Host "6. Recent service logs (last 10 lines):" -ForegroundColor Yellow
$logs = ssh -i $SSH_KEY $SERVER "journalctl -u resort.service -n 10 --no-pager 2>&1 | tail -5"
Write-Host $logs

# Step 7: Start/Restart service
Write-Host ""
Write-Host "7. Starting/restarting resort.service..." -ForegroundColor Yellow
$restart = ssh -i $SSH_KEY $SERVER "systemctl restart resort.service && sleep 5 && systemctl status resort.service --no-pager 2>&1 | head -5"
Write-Host $restart

# Step 8: Test via nginx
Write-Host ""
Write-Host "8. Testing via nginx..." -ForegroundColor Yellow
$nginxTest = ssh -i $SSH_KEY $SERVER "curl -s -o /dev/null -w 'Via nginx (/resoapi/api/): HTTP %{http_code}' https://teqmates.com/resoapi/api/ 2>&1 || echo 'Nginx proxy failed'"
Write-Host $nginxTest

# Step 9: Final verification
Write-Host ""
Write-Host "9. Final verification..." -ForegroundColor Yellow
$final = ssh -i $SSH_KEY $SERVER "echo 'Service:' && systemctl is-active resort.service && echo 'Direct Backend:' && curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8012/api/ && echo '' && echo 'Via Nginx:' && curl -s -o /dev/null -w '%{http_code}' https://teqmates.com/resoapi/api/ && echo ''"
Write-Host $final

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "RESORT BACKEND API FIX COMPLETE" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan


