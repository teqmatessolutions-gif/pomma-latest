# Run All Resort Services
# This script starts backend, admin, and user frontend in separate windows

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Starting All Resort Services" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$RESORT_DIR = "C:\releasing\Resort"

# Check if directory exists
if (-not (Test-Path $RESORT_DIR)) {
    Write-Host "[ERROR] Resort directory not found!" -ForegroundColor Red
    Write-Host "Please run setup_and_run_resort.ps1 first" -ForegroundColor Yellow
    exit 1
}

Write-Host "[INFO] Starting services in separate windows..." -ForegroundColor Green
Write-Host ""

# Start Backend in new window
Write-Host "[INFO] Starting Backend (Port 8012)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$RESORT_DIR'; .\run_backend.ps1"

Start-Sleep -Seconds 3

# Start Admin Dashboard in new window
Write-Host "[INFO] Starting Admin Dashboard (Port 3000)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$RESORT_DIR'; .\run_admin.ps1"

Start-Sleep -Seconds 3

# Start User Frontend in new window
Write-Host "[INFO] Starting User Frontend (Port 3001)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$RESORT_DIR'; .\run_userfrontend.ps1"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "All Services Started!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services running:" -ForegroundColor White
Write-Host "  Backend API:      http://localhost:8012" -ForegroundColor Gray
Write-Host "  API Docs:         http://localhost:8012/docs" -ForegroundColor Gray
Write-Host "  Admin Dashboard:  http://localhost:3000" -ForegroundColor Gray
Write-Host "  User Frontend:   http://localhost:3001" -ForegroundColor Gray
Write-Host ""
Write-Host "Each service is running in a separate window." -ForegroundColor Yellow
Write-Host "Close the windows to stop the services." -ForegroundColor Yellow
Write-Host ""

