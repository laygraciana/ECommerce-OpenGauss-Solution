@echo off
echo ========================================
echo E-Commerce Application Launcher
echo ========================================
echo.

cd /d "C:\Users\graci\ECommerceSolution\src\ECommerce.WebUI"

echo 1. Cleaning up...
del /q bin\*.exe 2>nul
del /q bin\*.dll 2>nul
taskkill /F /IM dotnet.exe 2>nul
timeout /t 3 /nobreak >nul

echo.
echo 2. Building application...
call dotnet build

if %errorlevel% equ 0 (
    echo.
    echo 3. Starting application on port 5055...
    echo ========================================
    echo Application starting...
    echo.
    echo Please wait for the application to start...
    echo Then test these URLs:
    echo.
    echo [API Endpoint]
    echo http://localhost:5055/api/ProductsApi
    echo.
    echo [Web Pages]
    echo http://localhost:5055/
    echo http://localhost:5055/Home/Products
    echo http://localhost:5055/Home/ApiTest
    echo ========================================
    echo.
    
    dotnet run --urls "http://localhost:5055"
) else (
    echo.
    echo Build failed!
    pause
)
