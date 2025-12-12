Write-Host "=== 三层架构购物仪表板 ===" -ForegroundColor Cyan
Write-Host "功能: 1. 仪表板  2. 产品页面  3. 购买历史" -ForegroundColor Yellow

# 停止现有进程
taskkill /F /IM "dotnet.exe" 2>$null
Start-Sleep -Seconds 2

Write-Host "`n启动应用..." -ForegroundColor Green
$process = Start-Process -NoNewWindow -PassThru -FilePath "dotnet" -ArgumentList "run"

Write-Host "等待应用启动 (10秒)..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "`n=== 应用信息 ===" -ForegroundColor Cyan
Write-Host "仪表板: http://localhost:5000" -ForegroundColor Green
Write-Host "产品页面: http://localhost:5000/Home/Products" -ForegroundColor Green
Write-Host "购买历史: http://localhost:5000/Home/BuyHistory" -ForegroundColor Green

Write-Host "`n=== 功能说明 ===" -ForegroundColor Yellow
Write-Host "1. 产品页面: 点击'BUY'按钮添加商品到购物车" -ForegroundColor Gray
Write-Host "2. 购物车: 实时显示商品数量和总价" -ForegroundColor Gray
Write-Host "3. 结账: 创建订单并存储到数据库" -ForegroundColor Gray
Write-Host "4. 购买历史: 查看所有订单详情" -ForegroundColor Gray

# 打开浏览器
try {
    Start-Process "http://localhost:5000"
    Write-Host "`n已在浏览器中打开仪表板" -ForegroundColor Green
} catch {
    Write-Host "`n请手动打开浏览器访问以上地址" -ForegroundColor Yellow
}

Write-Host "`n按 Ctrl+C 停止应用" -ForegroundColor Red

# 保持运行
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    taskkill /F /PID $process.Id 2>$null
    Write-Host "应用已停止" -ForegroundColor Yellow
}
