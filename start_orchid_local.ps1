# Start Orchid Locally
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Orchid Resort Locally" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Start Backend
Write-Host "[1/3] Starting Backend on port 8011..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd C:\releasing\orchid\ResortApp; .\venv\Scripts\activate; uvicorn app.main:app --reload --host 127.0.0.1 --port 8011" -WindowStyle Normal

Start-Sleep -Seconds 3

# Start Userend
Write-Host "[2/3] Starting User Frontend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd C:\releasing\orchid\userend\userend; npm start" -WindowStyle Normal

Start-Sleep -Seconds 3

# Start Dashboard
Write-Host "[3/3] Starting Admin Dashboard..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd C:\releasing\orchid\dasboard; npm start" -WindowStyle Normal

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "All services starting..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Backend API: http://localhost:8011" -ForegroundColor Cyan
Write-Host "API Docs: http://localhost:8011/docs" -ForegroundColor Cyan
Write-Host "User Frontend: http://localhost:3002 (or 3000)" -ForegroundColor Cyan
Write-Host "Admin Dashboard: http://localhost:3000 (or 3001)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Login Credentials:" -ForegroundColor Yellow
Write-Host "Email: admin@orchid.com" -ForegroundColor White
Write-Host "Password: admin123" -ForegroundColor White
Write-Host ""
Write-Host "Note: Create admin user if login fails:" -ForegroundColor Yellow
Write-Host 'Invoke-RestMethod -Uri "http://localhost:8011/api/users/setup-admin" -Method POST -ContentType "application/json" -Body ''{"name": "Orchid Admin", "email": "admin@orchid.com", "password": "admin123", "phone": "+1234567890"}''' -ForegroundColor Gray

