# PowerShell 脚本：创建 SQLite 数据库
$dbPath = "app.db"
$currentDir = Get-Location

Write-Host "当前目录: $currentDir" -ForegroundColor Cyan
Write-Host "数据库路径: $dbPath" -ForegroundColor Cyan

if (Test-Path $dbPath) {
    Write-Host "数据库文件已存在" -ForegroundColor Green
    Write-Host "文件大小: $([math]::Round((Get-Item $dbPath).Length/1KB, 2)) KB" -ForegroundColor Green
} else {
    Write-Host "正在创建数据库..." -ForegroundColor Yellow
    
    # 创建简单的 SQL 命令文件
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

-- 插入示例购买记录
INSERT OR IGNORE INTO Purchases (ProductId, ProductName, Price, Quantity)
VALUES 
    (1, 'Smartphone', 599.99, 1),
    (2, 'Laptop', 1299.99, 1),
    (3, 'Headphones', 99.99, 2);

-- 验证数据
SELECT 'Products:' as TableName, COUNT(*) as Count FROM Products
UNION ALL
SELECT 'Purchases:', COUNT(*) FROM Purchases;
"@

    # 保存 SQL 命令到文件
    $sqlFile = "init_database.sql"
    $sqlCommands | Out-File -FilePath $sqlFile -Encoding UTF8
    
    Write-Host "已创建 SQL 命令文件: $sqlFile" -ForegroundColor Green
    
    # 检查是否有 sqlite3 命令行工具
    if (Get-Command sqlite3 -ErrorAction SilentlyContinue) {
        Write-Host "使用 sqlite3 创建数据库..." -ForegroundColor Yellow
        sqlite3 $dbPath < $sqlFile
        Write-Host "数据库创建完成！" -ForegroundColor Green
        
        # 验证数据库
        Write-Host "`n验证数据库内容:" -ForegroundColor Cyan
        sqlite3 $dbPath ".tables"
        sqlite3 $dbPath "SELECT name FROM sqlite_master WHERE type='table';"
    } else {
        Write-Host "未找到 sqlite3 工具，将使用 .NET 创建数据库..." -ForegroundColor Yellow
        
        # 使用 .NET 创建数据库
        Add-Type -Path "System.Data.SQLite.dll" -ErrorAction SilentlyContinue
        
        if ($?) {
            $connectionString = "Data Source=$dbPath;Version=3;"
            $connection = New-Object System.Data.SQLite.SQLiteConnection($connectionString)
            $connection.Open()
            
            $command = $connection.CreateCommand()
            $command.CommandText = $sqlCommands
            $command.ExecuteNonQuery()
            
            $connection.Close()
            Write-Host "数据库创建完成！" -ForegroundColor Green
        } else {
            Write-Host "无法创建数据库，请安装 SQLite 工具或添加 System.Data.SQLite 引用" -ForegroundColor Red
        }
    }
}
