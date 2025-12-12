Write-Host "=== 重启 API 应用 ===" -ForegroundColor Cyan

# 停止所有 dotnet 进程
Write-Host "停止运行中的进程..." -ForegroundColor Yellow
Get-Process dotnet -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# 清理构建文件
Write-Host "清理构建文件..." -ForegroundColor Yellow
Remove-Item -Recurse -Force bin, obj -ErrorAction SilentlyContinue

# 恢复和构建
Write-Host "恢复包..." -ForegroundColor Yellow
dotnet restore

Write-Host "构建项目..." -ForegroundColor Yellow
dotnet build

# 运行 API
Write-Host "启动 API (端口 5100)..." -ForegroundColor Green
dotnet run --urls=http://localhost:5100
