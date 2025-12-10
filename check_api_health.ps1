# API Health Check Script
Write-Host "=== API Health Check ===" -ForegroundColor Cyan

# Check if port 8011 is listening
Write-Host "`n1. Checking if port 8011 is listening..." -ForegroundColor Yellow
$portCheck = netstat -ano | findstr ":8011" | findstr "LISTENING"
if ($portCheck) {
    Write-Host "   ✓ Port 8011 is listening" -ForegroundColor Green
    $portCheck | ForEach-Object { Write-Host "   $_" }
} else {
    Write-Host "   ✗ Port 8011 is NOT listening" -ForegroundColor Red
}

# Check Python processes
Write-Host "`n2. Checking Python processes..." -ForegroundColor Yellow
$pythonProcs = Get-Process | Where-Object {$_.ProcessName -like "*python*"} | Select-Object ProcessName, Id, CPU, WorkingSet
if ($pythonProcs) {
    Write-Host "   Found Python processes:" -ForegroundColor Green
    $pythonProcs | Format-Table -AutoSize
} else {
    Write-Host "   ✗ No Python processes found" -ForegroundColor Red
}

# Test API endpoints
Write-Host "`n3. Testing API endpoints..." -ForegroundColor Yellow

$endpoints = @(
    "http://localhost:8011/health",
    "http://localhost:8011/docs",
    "http://localhost:8011/api/bookings?limit=1"
)

foreach ($endpoint in $endpoints) {
    Write-Host "   Testing: $endpoint" -ForegroundColor Gray
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-WebRequest -Uri $endpoint -Method GET -TimeoutSec 3 -ErrorAction Stop
        $stopwatch.Stop()
        Write-Host "   ✓ Status: $($response.StatusCode) | Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Green
    } catch {
        $stopwatch.Stop()
        if ($_.Exception.Message -like "*timeout*") {
            Write-Host "   ✗ TIMEOUT after $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Red
        } else {
            Write-Host "   ✗ Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# Check database connection (if possible)
Write-Host "`n4. Recommendations:" -ForegroundColor Yellow
Write-Host "   - Backend appears to be hung/stuck" -ForegroundColor Red
Write-Host "   - High CPU usage suggests infinite loop or blocking operation" -ForegroundColor Red
Write-Host "   - Recommended action: Restart the backend server" -ForegroundColor Yellow
Write-Host "`n   To restart backend:" -ForegroundColor Cyan
Write-Host "   1. Stop the current process (PID shown above)" -ForegroundColor White
Write-Host "   2. cd ResortApp" -ForegroundColor White
Write-Host "   3. python -m uvicorn main:app --reload --host 0.0.0.0 --port 8011" -ForegroundColor White

