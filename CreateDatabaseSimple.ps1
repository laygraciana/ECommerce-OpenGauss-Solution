# PowerShell 脚本：创建 SQLite 数据库
$dbPath = "app.db"
$currentDir = Get-Location

Write-Host "=== 创建 SQLite 数据库 ===" -ForegroundColor Green
Write-Host "当前目录: $currentDir" -ForegroundColor Cyan
Write-Host "数据库文件: $dbPath" -ForegroundColor Cyan

if (Test-Path $dbPath) {
    Write-Host "✓ 数据库文件已存在" -ForegroundColor Green
    $size = [math]::Round((Get-Item $dbPath).Length / 1KB, 2)
    Write-Host "  文件大小: ${size} KB" -ForegroundColor Green
} else {
    Write-Host "正在创建数据库文件..." -ForegroundColor Yellow
    
    # 创建 SQL 命令
    $sqlCommands = @"
-- 创建 Products 表
CREATE TABLE IF NOT EXISTS Products (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Description TEXT NOT NULL,
    Price REAL NOT NULL,
    Category TEXT NOT NULL DEFAULT 'Electronics',
    StockQuantity INTEGER NOT NULL DEFAULT 0,
    ImageUrl TEXT NOT NULL DEFAULT ''
);

-- 创建 Purchases 表
CREATE TABLE IF NOT EXISTS Purchases (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    ProductId INTEGER NOT NULL,
    ProductName TEXT NOT NULL,
    Price REAL NOT NULL,
    Quantity INTEGER NOT NULL DEFAULT 1,
    PurchaseDate TEXT NOT NULL DEFAULT (datetime('now')),
    UserId TEXT NOT NULL DEFAULT 'demo-user'
);

-- 插入示例产品数据
INSERT OR IGNORE INTO Products (Name, Description, Price, Category, StockQuantity, ImageUrl)
VALUES 
    ('Smartphone', 'Latest smartphone with advanced features', 599.99, 'Electronics', 100, '/images/phone.jpg'),
    ('Laptop', 'High-performance laptop for work and gaming', 1299.99, 'Electronics', 50, '/images/laptop.jpg'),
    ('Headphones', 'Wireless noise-cancelling headphones', 99.99, 'Electronics', 200, '/images/headphones.jpg'),
    ('Smart Watch', 'Fitness tracker and smart notifications', 249.99, 'Electronics', 150, '/images/watch.jpg'),
    ('Tablet', 'Portable tablet for entertainment', 399.99, 'Electronics', 75, '/images/tablet.jpg');
"@

    # 保存 SQL 到文件
    $sqlFile = "init_database.sql"
    $sqlCommands | Out-File -FilePath $sqlFile -Encoding UTF8
    
    Write-Host "✓ 已创建 SQL 文件: $sqlFile" -ForegroundColor Green
    
    # 方法1：使用 sqlite3 命令行（如果可用）
    if (Get-Command sqlite3 -ErrorAction SilentlyContinue) {
        Write-Host "使用 sqlite3 命令行工具..." -ForegroundColor Yellow
        
        # 逐行执行 SQL 命令
        $sqlCommands -split "`n" | ForEach-Object {
            if ($_.Trim() -ne "" -and -not $_.StartsWith("--")) {
                try {
                    $command = $_.Trim()
                    if ($command.EndsWith(";")) {
                        Write-Host "执行: $command" -ForegroundColor DarkGray
                        echo $command | sqlite3 $dbPath
                    }
                } catch {
                    Write-Host "执行命令时出错: $_" -ForegroundColor Red
                }
            }
        }
        
        Write-Host "✓ 数据库创建完成！" -ForegroundColor Green
    } 
    # 方法2：使用 System.Data.SQLite（如果可用）
    elseif ([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.FullName -like "System.Data.SQLite*" }) {
        Write-Host "使用 System.Data.SQLite..." -ForegroundColor Yellow
        
        try {
            Add-Type -AssemblyName "System.Data.SQLite"
            $connectionString = "Data Source=$dbPath;Version=3;"
            $connection = New-Object System.Data.SQLite.SQLiteConnection($connectionString)
            $connection.Open()
            
            $command = $connection.CreateCommand()
            $command.CommandText = $sqlCommands
            $command.ExecuteNonQuery()
            
            $connection.Close()
            Write-Host "✓ 数据库创建完成！" -ForegroundColor Green
        } catch {
            Write-Host "使用 System.Data.SQLite 失败: $_" -ForegroundColor Red
        }
    }
    # 方法3：创建一个空的数据库文件，让 EF Core 处理
    else {
        Write-Host "创建空的数据库文件..." -ForegroundColor Yellow
        try {
            # 创建空的 SQLite 数据库文件
            [System.IO.File]::WriteAllBytes($dbPath, [System.Array]::CreateInstance([byte], 0))
            Write-Host "✓ 已创建空的数据库文件" -ForegroundColor Green
            Write-Host "应用启动时 EF Core 会自动创建表" -ForegroundColor Yellow
        } catch {
            Write-Host "创建文件失败: $_" -ForegroundColor Red
        }
    }
}

# 检查文件是否创建成功
if (Test-Path $dbPath) {
    Write-Host "`n=== 数据库验证 ===" -ForegroundColor Green
    Write-Host "数据库文件位置: $(Resolve-Path $dbPath)" -ForegroundColor Cyan
    
    # 尝试使用 sqlite3 查看内容（如果可用）
    if (Get-Command sqlite3 -ErrorAction SilentlyContinue) {
        Write-Host "`n数据库表列表:" -ForegroundColor Yellow
        try {
            $tables = sqlite3 $dbPath ".tables"
            if ($tables) {
                Write-Host $tables -ForegroundColor Cyan
            } else {
                Write-Host "（暂无表）" -ForegroundColor Gray
            }
        } catch {
            Write-Host "无法读取表信息" -ForegroundColor Red
        }
    }
} else {
    Write-Host "✗ 数据库文件创建失败" -ForegroundColor Red
}
