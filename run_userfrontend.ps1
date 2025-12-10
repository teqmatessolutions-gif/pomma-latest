# Run Resort User Frontend
# Run this script to start the user frontend

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Starting Resort User Frontend" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$RESORT_DIR = "C:\releasing\Resort"
$USEREND_DIR = Join-Path $RESORT_DIR "userend\userend"

# Check if directory exists
if (-not (Test-Path $USEREND_DIR)) {
    Write-Host "[ERROR] userend/userend directory not found!" -ForegroundColor Red
    Write-Host "Please run setup_and_run_resort.ps1 first" -ForegroundColor Yellow
    exit 1
}

Set-Location $USEREND_DIR

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "[INFO] Installing dependencies..." -ForegroundColor Green
    npm install --legacy-peer-deps
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to install dependencies!" -ForegroundColor Red
        exit 1
    }
}

# Check if .env exists and create if needed
if (-not (Test-Path ".env")) {
    Write-Host "[INFO] Creating .env file..." -ForegroundColor Green
    @"
REACT_APP_API_URL=http://localhost:8012
REACT_APP_API_BASE_URL=http://localhost:8012/api
"@ | Out-File -FilePath ".env" -Encoding UTF8
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "User Frontend Starting..." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "User Frontend will run on: http://localhost:3001" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the development server
npm start

