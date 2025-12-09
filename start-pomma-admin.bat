@echo off
echo.
echo ========================================
echo Starting Pomma Admin Dashboard
echo ========================================
echo.
echo Access at: http://localhost:3000/pommaadmin
echo.
cd /d "%~dp0dasboard"
call npm run start:pomma

