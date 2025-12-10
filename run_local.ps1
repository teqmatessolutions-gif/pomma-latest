# Run All Resort Services from Pumaholidays Directory
# This script starts backend, admin dashboard, and user frontend in separate windows

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Starting All Resort Services" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$RESORT_DIR = "C:\releasing\Pumaholidays"

# Check if directory exists
if (-not (Test-Path $RESORT_DIR)) {
    Write-Host "[ERROR] Pumaholidays directory not found!" -ForegroundColor Red
    exit 1
}

Write-Host "[INFO] Starting services in separate windows..." -ForegroundColor Green
Write-Host ""

# Start Backend in new window
Write-Host "[INFO] Starting Backend (Port 8012)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
cd '$RESORT_DIR\ResortApp'
Write-Host '[INFO] Activating virtual environment...' -ForegroundColor Green
if (Test-Path '..\\.venv\Scripts\Activate.ps1') {
    & '..\\.venv\Scripts\Activate.ps1'
} elseif (Test-Path 'venv\Scripts\Activate.ps1') {
    & '.\venv\Scripts\Activate.ps1'
} else {
    Write-Host '[INFO] Creating virtual environment...' -ForegroundColor Green
    python -m venv venv
    & '.\venv\Scripts\Activate.ps1'
}
if (Test-Path 'requirements.txt') {
    Write-Host '[INFO] Installing dependencies...' -ForegroundColor Green
    pip install -r requirements.txt --quiet
}
Write-Host '[INFO] Starting Backend Server on port 8012...' -ForegroundColor Green
Write-Host 'Backend running on: http://localhost:8012' -ForegroundColor Green
Write-Host 'API Docs: http://localhost:8012/docs' -ForegroundColor Green
python main.py
"@

Start-Sleep -Seconds 5

# Start Admin Dashboard in new window
Write-Host "[INFO] Starting Admin Dashboard (Port 3000)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
cd '$RESORT_DIR\dasboard'
Write-Host '[INFO] Installing npm dependencies...' -ForegroundColor Green
npm install --silent
Write-Host '[INFO] Starting Admin Dashboard...' -ForegroundColor Green
Write-Host 'Admin Dashboard running on: http://localhost:3000' -ForegroundColor Green
npm start
"@

Start-Sleep -Seconds 3

# Start User Frontend in new window
Write-Host "[INFO] Starting User Frontend (Port 3001)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
cd '$RESORT_DIR\userend'
Write-Host '[INFO] Installing npm dependencies...' -ForegroundColor Green
npm install --silent
Write-Host '[INFO] Starting User Frontend...' -ForegroundColor Green
Write-Host 'User Frontend running on: http://localhost:3001' -ForegroundColor Green
npm start
"@

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "All Services Started!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services running:" -ForegroundColor White
Write-Host "  Backend API:      http://localhost:8012" -ForegroundColor Gray
Write-Host "  API Docs:         http://localhost:8012/docs" -ForegroundColor Gray
Write-Host "  Admin Dashboard:  http://localhost:3000" -ForegroundColor Gray
Write-Host "  User Frontend:    http://localhost:3001" -ForegroundColor Gray
Write-Host ""
Write-Host "Each service is running in a separate window." -ForegroundColor Yellow
Write-Host "Close the windows to stop the services." -ForegroundColor Yellow
Write-Host ""
