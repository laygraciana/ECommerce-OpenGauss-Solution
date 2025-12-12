Write-Host "=== 启动 ECommerce 应用 ===" -ForegroundColor Cyan

# 停止任何正在运行的实例
taskkill /F /IM "dotnet.exe" 2>$null
Start-Sleep -Seconds 2

Write-Host "清理生成文件..." -ForegroundColor Yellow
Remove-Item -Path "src\ECommerce.WebUI\bin" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "src\ECommerce.WebUI\obj" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`n启动应用..." -ForegroundColor Green
Set-Location "src\ECommerce.WebUI"

try {
    # 尝试构建
    Write-Host "尝试构建..." -ForegroundColor Yellow
    $buildResult = dotnet build
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "构建失败，尝试直接运行..." -ForegroundColor Yellow
    }
    
    # 启动应用
    $process = Start-Process -NoNewWindow -PassThru -FilePath "dotnet" -ArgumentList "run"
    
    Write-Host "等待应用启动 (15秒)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15
    
    Write-Host "`n=== 应用状态 ===" -ForegroundColor Green
    Write-Host "应用应该正在运行在:" -ForegroundColor Cyan
    Write-Host "http://localhost:5000" -ForegroundColor White
    
    Write-Host "`n测试页面:" -ForegroundColor Yellow
    Write-Host "1. 主页: http://localhost:5000" -ForegroundColor Gray
    Write-Host "2. 产品页: http://localhost:5000/Home/Products" -ForegroundColor Gray
    Write-Host "3. 注册页: http://localhost:5000/Home/Register" -ForegroundColor Gray
    
    # 尝试打开浏览器
    try {
        Start-Process "http://localhost:5000/Home/Products"
        Write-Host "`n已在浏览器中打开产品页面" -ForegroundColor Green
    } catch {
        Write-Host "`n请手动打开浏览器访问以上地址" -ForegroundColor Yellow
    }
    
    Write-Host "`n按 Ctrl+C 停止应用" -ForegroundColor Red
    
    # 保持脚本运行
    try {
        while ($true) {
            Start-Sleep -Seconds 1
        }
    } finally {
        taskkill /F /PID $process.Id 2>$null
        Write-Host "应用已停止" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "启动失败: $_" -ForegroundColor Red
    Write-Host "`n备用方案: 打开 minimal-products.html 查看静态页面" -ForegroundColor Yellow
    if (Test-Path "..\..\minimal-products.html") {
        Start-Process "..\..\minimal-products.html"
    }
}
