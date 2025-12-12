@echo off
title E-Commerce Application
echo ==========================================
echo E-Commerce Shopping Application
echo ==========================================
echo.

cd /d "C:\Users\graci\ECommerceSolution\src\ECommerce.WebUI"

echo 1. Stopping any running applications...
taskkill /F /IM dotnet.exe 2>nul
timeout /t 1 /nobreak >nul

echo.
echo 2. Building application...
dotnet build

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo Application is ready!
    echo.
    echo Open your browser and visit:
    echo.
    echo [1] Dashboard:    http://localhost:5050
    echo [2] Products:     http://localhost:5050/Home/Products
    echo [3] Buy History:  http://localhost:5050/Home/BuyHistory
    echo.
    echo Press Ctrl+C to stop the application
    echo ==========================================
    echo.
    echo Starting application on port 5050...
    echo.
    
    dotnet run --urls "http://localhost:5050"
) else (
    echo.
    echo Build failed!
    echo Try: dotnet run
    pause
)
