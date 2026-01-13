param(
    [Parameter(Mandatory=$true)]
    [string]$ServerPassword
)

$server = "root@139.84.211.200"

Write-Host "=== Userend Application Deployment ===" -ForegroundColor Cyan
Write-Host "Server: $server" -ForegroundColor Yellow
Write-Host ""
Write-Host "Step 1: Rebuilding Userend on Server..." -ForegroundColor Yellow

# Rebuild Userend on Server
# We navigate to the userend directory, install dependencies, and run production build
# Note regarding path: deploy-to-server.ps1 uses /var/www/resort/Resort_first/dasboard
# So we assume userend is at /var/www/resort/Resort_first/userend/userend
echo $ServerPassword | plink -batch -pw "$ServerPassword" -ssh $server "cd /var/www/resort/Resort_first/userend/userend && echo 'Installing dependencies...' && npm install --production=false && echo 'Building...' && npm run build:prod"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build Failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Build Successful!" -ForegroundColor Green
Write-Host ""
Write-Host "Step 2: Deploying to /var/www/pomma..." -ForegroundColor Yellow

# Copy build artifacts to the serving directory
# Nginx alias for /pomma is /var/www/pomma
echo $ServerPassword | plink -batch -pw "$ServerPassword" -ssh $server "sudo cp -r /var/www/resort/Resort_first/userend/userend/build/* /var/www/pomma/"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Deployment Failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Deployment Successful!" -ForegroundColor Green
Write-Host ""
Write-Host "Step 3: Restarting Nginx..." -ForegroundColor Yellow

echo $ServerPassword | plink -batch -pw "$ServerPassword" -ssh $server "sudo systemctl restart nginx"

Write-Host "=== Userend Deployment Complete ===" -ForegroundColor Green
Write-Host "Please check: https://www.teqmates.com/resort" -ForegroundColor Cyan
