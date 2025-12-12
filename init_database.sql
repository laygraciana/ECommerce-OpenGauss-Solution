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
