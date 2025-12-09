@echo off
echo.
echo ========================================
echo Starting Pomma User Frontend
echo ========================================
echo.
echo Access at: http://localhost:3002/pommaholidays
echo.
cd /d "%~dp0userend\userend"
call npm run start:pomma

