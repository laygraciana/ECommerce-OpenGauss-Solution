using System;
using Microsoft.Data.Sqlite;
using System.IO;

public class DatabaseInitializer
{
    public static void Initialize()
    {
        string dbPath = "app.db";
        
        Console.WriteLine($"检查数据库文件: {dbPath}");
        Console.WriteLine($"当前目录: {Directory.GetCurrentDirectory()}");
        
        if (!File.Exists(dbPath))
        {
            Console.WriteLine("数据库文件不存在，正在创建...");
            
            try
            {
                // 创建 SQLite 连接，这会创建数据库文件
                using (var connection = new SqliteConnection($"Data Source={dbPath}"))
                {
                    connection.Open();
                    
                    // 创建 Products 表
                    using (var command = connection.CreateCommand())
                    {
                        command.CommandText = @"
                            CREATE TABLE IF NOT EXISTS Products (
                                Id INTEGER PRIMARY KEY AUTOINCREMENT,
                                Name TEXT NOT NULL,
                                Description TEXT NOT NULL,
                                Price REAL NOT NULL,
                                Category TEXT NOT NULL DEFAULT 'Electronics',
                                StockQuantity INTEGER NOT NULL DEFAULT 0,
                                ImageUrl TEXT NOT NULL DEFAULT ''
                            )";
                        command.ExecuteNonQuery();
                        Console.WriteLine("Products 表已创建");
                    }
                    
                    // 创建 Purchases 表
                    using (var command = connection.CreateCommand())
                    {
                        command.CommandText = @"
                            CREATE TABLE IF NOT EXISTS Purchases (
                                Id INTEGER PRIMARY KEY AUTOINCREMENT,
                                ProductId INTEGER NOT NULL,
                                ProductName TEXT NOT NULL,
                                Price REAL NOT NULL,
                                Quantity INTEGER NOT NULL DEFAULT 1,
                                PurchaseDate TEXT NOT NULL DEFAULT (datetime('now')),
                                UserId TEXT NOT NULL DEFAULT 'demo-user'
                            )";
                        command.ExecuteNonQuery();
                        Console.WriteLine("Purchases 表已创建");
                    }
                    
                    // 添加示例数据
                    using (var command = connection.CreateCommand())
                    {
                        command.CommandText = @"
                            INSERT OR IGNORE INTO Products (Name, Description, Price, Category, StockQuantity, ImageUrl)
                            VALUES 
                                ('Smartphone', 'Latest smartphone with advanced features', 599.99, 'Electronics', 100, '/images/phone.jpg'),
                                ('Laptop', 'High-performance laptop for work and gaming', 1299.99, 'Electronics', 50, '/images/laptop.jpg'),
                                ('Headphones', 'Wireless noise-cancelling headphones', 99.99, 'Electronics', 200, '/images/headphones.jpg'),
                                ('Smart Watch', 'Fitness tracker and smart notifications', 249.99, 'Electronics', 150, '/images/watch.jpg'),
                                ('Tablet', 'Portable tablet for entertainment', 399.99, 'Electronics', 75, '/images/tablet.jpg')
                        ";
                        int rows = command.ExecuteNonQuery();
                        Console.WriteLine($"已添加 {rows} 个产品记录");
                    }
                    
                    Console.WriteLine("数据库初始化完成！");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"数据库创建错误: {ex.Message}");
            }
        }
        else
        {
            Console.WriteLine("数据库文件已存在");
            CheckTables(dbPath);
        }
    }
    
    private static void CheckTables(string dbPath)
    {
        try
        {
            using (var connection = new SqliteConnection($"Data Source={dbPath}"))
            {
                connection.Open();
                
                // 检查表是否存在
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "SELECT name FROM sqlite_master WHERE type='table'";
                    using (var reader = command.ExecuteReader())
                    {
                        Console.WriteLine("现有表:");
                        while (reader.Read())
                        {
                            Console.WriteLine($"  - {reader.GetString(0)}");
                        }
                    }
                }
                
                // 检查 Purchases 表
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='Purchases'";
                    var hasPurchasesTable = Convert.ToInt32(command.ExecuteScalar()) > 0;
                    Console.WriteLine($"Purchases 表存在: {hasPurchasesTable}");
                    
                    if (!hasPurchasesTable)
                    {
                        Console.WriteLine("创建 Purchases 表...");
                        command.CommandText = @"
                            CREATE TABLE Purchases (
                                Id INTEGER PRIMARY KEY AUTOINCREMENT,
                                ProductId INTEGER NOT NULL,
                                ProductName TEXT NOT NULL,
                                Price REAL NOT NULL,
                                Quantity INTEGER NOT NULL DEFAULT 1,
                                PurchaseDate TEXT NOT NULL DEFAULT (datetime('now')),
                                UserId TEXT NOT NULL DEFAULT 'demo-user'
                            )";
                        command.ExecuteNonQuery();
                        Console.WriteLine("Purchases 表已创建");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"检查表错误: {ex.Message}");
        }
    }
}
