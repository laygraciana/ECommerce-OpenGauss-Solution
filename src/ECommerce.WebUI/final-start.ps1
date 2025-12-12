# 三层架构购物应用最终启动脚本
Write-Host "=== 最终启动 ===" -ForegroundColor Cyan

# 停止现有进程
taskkill /F /IM "dotnet.exe" 2>$null
Start-Sleep -Seconds 2

# 清理
Write-Host "清理生成文件..." -ForegroundColor Yellow
Remove-Item -Path "src\ECommerce.WebUI\bin" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "src\ECommerce.WebUI\obj" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "src\ECommerce.DAL\bin" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "src\ECommerce.DAL\obj" -Recurse -Force -ErrorAction SilentlyContinue

# 进入WebUI目录
Set-Location "src\ECommerce.WebUI"

# 显示文件状态
Write-Host "`n文件状态检查:" -ForegroundColor Green
$essentialFiles = @(
    "Controllers\HomeController.cs",
    "Program.cs", 
    "Views\Home\Index.cshtml",
    "Views\Home\Products.cshtml",
    "Views\Home\BuyHistory.cshtml"
)

foreach ($file in $essentialFiles) {
    if (Test-Path $file) {
        Write-Host "  ? $file" -ForegroundColor Gray
    } else {
        Write-Host "  ? $file" -ForegroundColor Red
    }
}

# 启动应用
Write-Host "`n启动应用..." -ForegroundColor Green
$process = Start-Process -NoNewWindow -PassThru -FilePath "dotnet" -ArgumentList "run"

Write-Host "等待应用启动 (25秒)..." -ForegroundColor Yellow

# 显示进度
$totalWait = 25
for ($i = 1; $i -le $totalWait; $i++) {
    Write-Host "." -NoNewline
    if ($i % 10 -eq 0) { Write-Host " $i秒" }
    Start-Sleep -Seconds 1
}
Write-Host "`n"

Write-Host "`n" + "="*60 -ForegroundColor Cyan
Write-Host "       三层架构购物应用" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Cyan

Write-Host "`n?? 三层架构:" -ForegroundColor Yellow
Write-Host "   ?? 数据层 (DAL): Product, Order, DbContext" -ForegroundColor Gray
Write-Host "   ?? 表现层 (WebUI): 三个完整页面" -ForegroundColor Gray
Write-Host "   ? 业务逻辑: Controller中处理" -ForegroundColor Gray

Write-Host "`n?? 访问地址:" -ForegroundColor Yellow
Write-Host "   1. 产品页面: http://localhost:5000/Home/Products" -ForegroundColor White
Write-Host "   2. 仪表板:   http://localhost:5000" -ForegroundColor White
Write-Host "   3. 购买历史: http://localhost:5000/Home/BuyHistory" -ForegroundColor White

Write-Host "`n?? 功能测试:" -ForegroundColor Yellow
Write-Host "   1. 点击'BUY'按钮添加商品" -ForegroundColor Gray
Write-Host "   2. 查看右下角购物车图标更新" -ForegroundColor Gray
Write-Host "   3. 点击购物车图标结账" -ForegroundColor Gray
Write-Host "   4. 查看购买历史" -ForegroundColor Gray

# 打开浏览器
try {
    Start-Process "http://localhost:5000/Home/Products"
    Write-Host "`n? 已打开产品页面" -ForegroundColor Green
} catch {
    Write-Host "`n?? 请手动访问: http://localhost:5000/Home/Products" -ForegroundColor Yellow
}

Write-Host "`n" + "-"*60 -ForegroundColor DarkGray
Write-Host "   应用运行中... 按 Ctrl+C 停止" -ForegroundColor White
Write-Host "-"*60 -ForegroundColor DarkGray

# 保持运行
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    taskkill /F /PID $process.Id 2>$null
    Write-Host "`n应用已停止" -ForegroundColor Yellow
}
