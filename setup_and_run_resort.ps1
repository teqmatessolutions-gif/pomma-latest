# Resort Management System - Complete Setup and Run Script
# This script sets up and runs the Resort project locally

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Resort Management System - Local Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$RESORT_DIR = "C:\releasing\Resort"

# Check if directory exists
if (-not (Test-Path $RESORT_DIR)) {
    Write-Host "[INFO] Creating Resort directory..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $RESORT_DIR -Force | Out-Null
}

# Navigate to Resort directory
Set-Location $RESORT_DIR

# Check if repository is cloned
if (-not (Test-Path ".git")) {
    Write-Host "[INFO] Cloning Resort repository..." -ForegroundColor Green
    git clone https://github.com/teqmatessolutions-gif/Resort.git .
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to clone repository!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[INFO] Repository already exists. Pulling latest changes..." -ForegroundColor Yellow
    git pull origin main
}

Write-Host ""
Write-Host "[INFO] Repository ready!" -ForegroundColor Green
Write-Host ""

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Cyan

# Check Python
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Python: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Python is not installed!" -ForegroundColor Red
    exit 1
}

# Check Node.js
$nodeVersion = node --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Node.js: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Node.js is not installed!" -ForegroundColor Red
    exit 1
}

# Check PostgreSQL
$pgVersion = psql --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] PostgreSQL: $pgVersion" -ForegroundColor Green
} else {
    Write-Host "[WARN] PostgreSQL may not be in PATH" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Setup Complete! Ready to run." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Run: .\run_backend.ps1      (Backend API)" -ForegroundColor Gray
Write-Host "  2. Run: .\run_admin.ps1       (Admin Dashboard)" -ForegroundColor Gray
Write-Host "  3. Run: .\run_userfrontend.ps1 (User Frontend)" -ForegroundColor Gray
Write-Host ""
Write-Host "Or run all at once: .\run_all.ps1" -ForegroundColor Yellow
Write-Host ""

