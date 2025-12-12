Write-Host "=== ECommerce 3-Tier Application Test ===" -ForegroundColor Cyan

# Stop any running instances
taskkill /F /IM "dotnet.exe" 2>$null
Start-Sleep -Seconds 2

Write-Host "`nStarting application..." -ForegroundColor Green
$process = Start-Process -NoNewWindow -PassThru -FilePath "dotnet" -ArgumentList "run" -WorkingDirectory "src\ECommerce.WebUI"

Write-Host "Waiting for application to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 8

Write-Host "`nTesting all interfaces:" -ForegroundColor Cyan

$pages = @(
    @{Name="Main Page"; Url="http://localhost:5000"; Expected="Browse Products"},
    @{Name="Products Page"; Url="http://localhost:5000/Home/Products"; Expected="Ultra Gaming Laptop"},
    @{Name="Register Page"; Url="http://localhost:5000/Home/Register"; Expected="Create Your Account"}
)

$successCount = 0
foreach ($page in $pages) {
    try {
        $response = Invoke-WebRequest -Uri $page.Url -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200 -and $response.Content -match $page.Expected) {
            Write-Host "  ? $($page.Name)" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  ? $($page.Name)" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ? $($page.Name) (Cannot connect)" -ForegroundColor Red
    }
}

if ($successCount -eq 3) {
    Write-Host "`n?? All 3 interfaces are working!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opening in browser..." -ForegroundColor Yellow
    Start-Process "http://localhost:5000"
    
    Write-Host "`nApplication URLs:" -ForegroundColor Green
    Write-Host "Main: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "Products: http://localhost:5000/Home/Products" -ForegroundColor Gray
    Write-Host "Register: http://localhost:5000/Home/Register" -ForegroundColor Gray
    
    Write-Host "`nPress Ctrl+C in this window to stop the application" -ForegroundColor Yellow
    
    # Keep the script running
    try {
        while ($true) {
            Start-Sleep -Seconds 1
        }
    } finally {
        taskkill /F /PID $process.Id 2>$null
    }
} else {
    Write-Host "`n? Only $successCount/3 interfaces are working" -ForegroundColor Yellow
    taskkill /F /PID $process.Id 2>$null
}
