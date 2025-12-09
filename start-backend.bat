@echo off
echo.
echo ========================================
echo Starting Pomma Backend API
echo ========================================
echo.
echo API will be available at: http://localhost:8010
echo Docs at: http://localhost:8010/docs
echo.
cd /d "%~dp0ResortApp"

if exist venv\Scripts\activate.bat (
    echo Activating virtual environment...
    call venv\Scripts\activate.bat
    echo Starting FastAPI server...
    uvicorn main:app --reload --host 0.0.0.0 --port 8010
) else (
    echo ERROR: Virtual environment not found!
    echo Please run: python -m venv venv
    echo Then: venv\Scripts\activate
    echo Then: pip install -r requirements.txt
    pause
)

