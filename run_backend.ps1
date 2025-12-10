# Run Resort Backend (FastAPI)
# Run this script to start the backend server

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Starting Resort Backend Server" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$RESORT_DIR = "C:\releasing\Resort"
$BACKEND_DIR = Join-Path $RESORT_DIR "ResortApp"

# Check if directory exists
if (-not (Test-Path $BACKEND_DIR)) {
    Write-Host "[ERROR] ResortApp directory not found!" -ForegroundColor Red
    Write-Host "Please run setup_and_run_resort.ps1 first" -ForegroundColor Yellow
    exit 1
}

Set-Location $BACKEND_DIR

# Check if virtual environment exists
if (-not (Test-Path "venv")) {
    Write-Host "[INFO] Creating virtual environment..." -ForegroundColor Green
    python -m venv venv
}

# Activate virtual environment
Write-Host "[INFO] Activating virtual environment..." -ForegroundColor Green
& ".\venv\Scripts\Activate.ps1"

# Install/update dependencies
if (Test-Path "requirements.txt") {
    Write-Host "[INFO] Installing/updating dependencies..." -ForegroundColor Green
    pip install -r requirements.txt --quiet
} else {
    Write-Host "[WARN] requirements.txt not found!" -ForegroundColor Yellow
}

# Check if .env exists
if (-not (Test-Path ".env")) {
    Write-Host "[INFO] Creating .env file..." -ForegroundColor Green
    @"
# Database Configuration
DATABASE_URL=postgresql+psycopg2://resortuser:resort123@localhost:5432/resort
DB_HOST=localhost
DB_PORT=5432
DB_NAME=resort
DB_USER=resortuser
DB_PASSWORD=resort123

# Security Configuration
SECRET_KEY=dev-secret-key-change-in-production-$(Get-Random)
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# Server Configuration
HOST=0.0.0.0
PORT=8012
ROOT_PATH=/resortapi

# CORS Configuration
CORS_ORIGINS=http://localhost:3000,http://localhost:3001,http://localhost:3002

# File Upload Configuration
MAX_FILE_SIZE=10485760
UPLOAD_FOLDER=uploads
STATIC_FOLDER=static
"@ | Out-File -FilePath ".env" -Encoding UTF8
    Write-Host "[INFO] .env file created with default values" -ForegroundColor Green
}

# Create uploads and static directories
if (-not (Test-Path "uploads")) {
    New-Item -ItemType Directory -Path "uploads" | Out-Null
}
if (-not (Test-Path "static")) {
    New-Item -ItemType Directory -Path "static" | Out-Null
}

# Initialize database tables (if needed)
Write-Host "[INFO] Initializing database tables..." -ForegroundColor Green
python -c "from app.database import Base, engine; Base.metadata.create_all(bind=engine)" 2>&1 | Out-Null

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Backend Server Starting..." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend will run on: http://localhost:8012" -ForegroundColor Green
Write-Host "API Docs: http://localhost:8012/docs" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the backend server
if (Test-Path "main.py") {
    python main.py
} else {
    uvicorn main:app --reload --host 0.0.0.0 --port 8012
}

