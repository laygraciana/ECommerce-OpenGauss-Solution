@echo off
chcp 65001 > nul
echo ==================================================
echo     三层架构购物仪表板启动器
echo ==================================================
echo.

echo 正在停止现有进程...
taskkill /F /IM "dotnet.exe" 2>nul
timeout /t 2 /nobreak >nul

echo 清理生成文件...
if exist "src\ECommerce.WebUI\bin" rmdir /s /q "src\ECommerce.WebUI\bin"
if exist "src\ECommerce.WebUI\obj" rmdir /s /q "src\ECommerce.WebUI\obj"
if exist "src\ECommerce.DAL\bin" rmdir /s /q "src\ECommerce.DAL\bin"
if exist "src\ECommerce.DAL\obj" rmdir /s /q "src\ECommerce.DAL\obj"
if exist "src\ECommerce.BLL\bin" rmdir /s /q "src\ECommerce.BLL\bin"
if exist "src\ECommerce.BLL\obj" rmdir /s /q "src\ECommerce.BLL\obj"

echo.
echo 启动应用...
cd src\ECommerce.WebUI
start "ECommerce Dashboard" dotnet run

echo.
echo 等待应用启动...
timeout /t 10 /nobreak >nul

echo.
echo ==================================================
echo     应用已启动！
echo ==================================================
echo.
echo 访问地址：
echo 1. 仪表板主页:   http://localhost:5000
echo 2. 产品页面:     http://localhost:5000/Home/Products
echo 3. 购买历史:     http://localhost:5000/Home/BuyHistory
echo.
echo 按任意键打开产品页面...
pause >nul

start http://localhost:5000/Home/Products

echo.
echo ==================================================
echo     应用正在运行中...
echo     按 Ctrl+C 停止应用
echo ==================================================
echo.
pause
