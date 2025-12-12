# 启动 API 和 Web 应用
Write-Host "=== 启动 E-Commerce 应用 ===" -ForegroundColor Cyan

# 停止所有运行的 .NET 进程
taskkill /F /IM "dotnet.exe" 2>$null
Start-Sleep -Seconds 2

# 清理并构建
Write-Host "清理和构建项目..." -ForegroundColor Yellow
dotnet clean
dotnet build

if ($LASTEXITCODE -ne 0) {
    Write-Host "构建失败，请检查错误" -ForegroundColor Red
    exit 1
}

Write-Host "`n启动 API (http://localhost:5100)..." -ForegroundColor Green
Start-Process -NoNewWindow -FilePath "dotnet" -ArgumentList "run" -WorkingDirectory "src\Application\ECommerce.Api"

Start-Sleep -Seconds 5

Write-Host "`n启动 Web 应用 (http://localhost:5000)..." -ForegroundColor Green
Start-Process -NoNewWindow -FilePath "dotnet" -ArgumentList "run" -WorkingDirectory "src\Presentation\ECommerce.Web"

Start-Sleep -Seconds 3

Write-Host "`n=== 应用已启动 ===" -ForegroundColor Cyan
Write-Host "API: http://localhost:5100" -ForegroundColor Green
Write-Host "API 端点: http://localhost:5100/api/products" -ForegroundColor Gray
Write-Host "Web 应用: http://localhost:5000" -ForegroundColor Green
Write-Host ""
Write-Host "按 Ctrl+C 停止所有应用" -ForegroundColor Yellow

# 保持脚本运行
while ($true) {
    Start-Sleep -Seconds 1
}