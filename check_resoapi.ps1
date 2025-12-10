# Check RESOAPI Status
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "CHECKING RESOAPI STATUS" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$SSH_KEY = "$env:USERPROFILE\.ssh\server_ed25519"
$SERVER = "root@139.84.211.200"

# Check service
Write-Host "1. Checking resort.service..." -ForegroundColor Yellow
$service = ssh -i $SSH_KEY $SERVER "systemctl is-active resort.service 2>&1"
Write-Host "   Service: $service"

# Check direct backend
Write-Host ""
Write-Host "2. Testing direct backend (127.0.0.1:8012)..." -ForegroundColor Yellow
$direct = ssh -i $SSH_KEY $SERVER "curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8012/api/resort-info/ 2>&1"
Write-Host "   Direct Backend: HTTP $direct"

# Check via nginx
Write-Host ""
Write-Host "3. Testing via Nginx (https://teqmates.com/resoapi/api/)..." -ForegroundColor Yellow
$nginx = ssh -i $SSH_KEY $SERVER "curl -s -o /dev/null -w '%{http_code}' https://teqmates.com/resoapi/api/resort-info/ 2>&1"
Write-Host "   Via Nginx: HTTP $nginx"

# Test from local machine
Write-Host ""
Write-Host "4. Testing from local machine..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://teqmates.com/resoapi/api/resort-info/" -UseBasicParsing -TimeoutSec 10
    Write-Host "   Status: HTTP $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Response Length: $($response.Content.Length) bytes"
    if ($response.Content.Length -gt 0) {
        Write-Host "   ✓ RESOAPI IS WORKING!" -ForegroundColor Green
    }
} catch {
    Write-Host "   ✗ RESOAPI NOT ACCESSIBLE" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)"
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "CHECK COMPLETE" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan


