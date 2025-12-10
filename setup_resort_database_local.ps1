# PowerShell script to setup Resort database on Windows (Local)
# This script creates the resort database and user for local development

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Resort Database Setup Script (Windows)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Database configuration
$DB_NAME = "resort"
$DB_USER = "resortuser"
$DB_PASSWORD = "resort123"

# Check if PostgreSQL is installed
$psqlPath = Get-Command psql -ErrorAction SilentlyContinue
if (-not $psqlPath) {
    Write-Host "[ERROR] PostgreSQL is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "Please install PostgreSQL from: https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After installation, make sure PostgreSQL bin directory is in your PATH" -ForegroundColor Yellow
    Write-Host "Typically: C:\Program Files\PostgreSQL\<version>\bin" -ForegroundColor Yellow
    exit 1
}

Write-Host "[INFO] PostgreSQL found at: $($psqlPath.Source)" -ForegroundColor Green
Write-Host ""

# Get PostgreSQL installation path
$pgBinPath = Split-Path -Parent $psqlPath.Source
$pgAdminPath = Join-Path (Split-Path -Parent $pgBinPath) "bin"

# Check if PostgreSQL service is running
$pgService = Get-Service -Name "postgresql*" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($pgService) {
    if ($pgService.Status -ne "Running") {
        Write-Host "[INFO] Starting PostgreSQL service..." -ForegroundColor Yellow
        Start-Service $pgService.Name
        Start-Sleep -Seconds 3
    }
    Write-Host "[INFO] PostgreSQL service is running" -ForegroundColor Green
} else {
    Write-Host "[WARN] Could not find PostgreSQL service. Please ensure PostgreSQL is running." -ForegroundColor Yellow
}

Write-Host ""

# Get PostgreSQL superuser password (if set)
$pgPassword = Read-Host "Enter PostgreSQL superuser (postgres) password (press Enter if no password)"

# Set PGPASSWORD environment variable if password provided
if ($pgPassword) {
    $env:PGPASSWORD = $pgPassword
}

# Create database user
Write-Host "[INFO] Creating database user: $DB_USER" -ForegroundColor Green
$createUserSQL = @"
DO `$`$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_user WHERE usename = '$DB_USER') THEN
        CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
    END IF;
END
`$`$;
"@

try {
    & psql -U postgres -c $createUserSQL
    Write-Host "[INFO] User created or already exists" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Could not create user. You may need to run this script as administrator or provide correct postgres password." -ForegroundColor Yellow
}

# Grant privileges
Write-Host "[INFO] Granting privileges to $DB_USER..." -ForegroundColor Green
& psql -U postgres -c "ALTER USER $DB_USER CREATEDB;" 2>&1 | Out-Null

# Drop existing database if it exists
Write-Host "[INFO] Dropping existing database if it exists: $DB_NAME" -ForegroundColor Green
& psql -U postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>&1 | Out-Null

# Create database
Write-Host "[INFO] Creating database: $DB_NAME" -ForegroundColor Green
try {
    & psql -U postgres -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
    Write-Host "[INFO] Database created successfully" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to create database" -ForegroundColor Red
    exit 1
}

# Grant all privileges on database
Write-Host "[INFO] Granting all privileges on database $DB_NAME to $DB_USER..." -ForegroundColor Green
& psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;" 2>&1 | Out-Null

# Connect to database and grant schema privileges
Write-Host "[INFO] Granting schema privileges..." -ForegroundColor Green
& psql -U postgres -d $DB_NAME -c "GRANT ALL ON SCHEMA public TO $DB_USER;" 2>&1 | Out-Null

# Test connection
Write-Host "[INFO] Testing database connection..." -ForegroundColor Green
try {
    $testResult = & psql -U $DB_USER -d $DB_NAME -c "SELECT version();" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[INFO] Database connection successful!" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Connection test returned non-zero exit code" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARN] Could not test connection directly" -ForegroundColor Yellow
}

# Clear password from environment
$env:PGPASSWORD = $null

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Database Setup Complete!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Database Details:" -ForegroundColor White
Write-Host "  Name: $DB_NAME" -ForegroundColor Gray
Write-Host "  User: $DB_USER" -ForegroundColor Gray
Write-Host "  Password: $DB_PASSWORD" -ForegroundColor Gray
Write-Host "  Host: localhost" -ForegroundColor Gray
Write-Host "  Port: 5432" -ForegroundColor Gray
Write-Host ""
Write-Host "Connection String:" -ForegroundColor White
Write-Host "  postgresql+psycopg2://$DB_USER`:$DB_PASSWORD@localhost:5432/$DB_NAME" -ForegroundColor Gray
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. Update your .env file with the database connection string" -ForegroundColor Gray
Write-Host "  2. Run database migrations: alembic upgrade head" -ForegroundColor Gray
Write-Host "  3. Or create tables: python -c 'from app.database import Base, engine; Base.metadata.create_all(bind=engine)'" -ForegroundColor Gray
Write-Host ""

