@echo off
echo Restarting E-Commerce Application...
echo.

cd /d "C:\Users\graci\ECommerceSolution\src\ECommerce.WebUI"

echo 1. Stopping current application...
taskkill /F /IM dotnet.exe 2>nul
timeout /t 2 /nobreak >nul

echo.
echo 2. Building application...
dotnet build

if %errorlevel% equ 0 (
    echo.
    echo 3. Starting application...
    echo.
    echo Test URLs:
    echo - http://localhost:5001/
    echo - http://localhost:5001/Home/Products
    echo - http://localhost:5001/api/TestApi/ping
    echo - http://localhost:5001/api/ProductsApi
    echo.
    echo Press Ctrl+C to stop
    echo.
    
    dotnet run
) else (
    echo.
    echo Build failed!
    pause
)
