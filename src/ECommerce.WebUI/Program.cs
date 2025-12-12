using Microsoft.EntityFrameworkCore;
using ECommerce.DAL;
using System.IO;

var builder = WebApplication.CreateBuilder(args);

// 添加服务到容器
builder.Services.AddControllersWithViews();

// 添加数据库上下文
builder.Services.AddDbContext<ECommerceDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection") ?? "Data Source=app.db"));

// 注册服务
builder.Services.AddScoped<ECommerce.BLL.Services.IProductService, ECommerce.BLL.Services.ProductService>();
builder.Services.AddScoped<ECommerce.BLL.Services.IPurchaseService, ECommerce.BLL.Services.PurchaseService>();

var app = builder.Build();

// 配置 HTTP 请求管道
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// 确保数据库文件存在并初始化
Console.WriteLine("=== 数据库初始化 ===");
Console.WriteLine($"当前目录: {Directory.GetCurrentDirectory()}");
Console.WriteLine($"数据库文件: app.db");

if (!File.Exists("app.db"))
{
    Console.WriteLine("数据库文件不存在，正在创建...");
    try
    {
        // 创建空的数据库文件
        File.WriteAllBytes("app.db", new byte[0]);
        Console.WriteLine("✓ 数据库文件已创建");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"创建数据库文件失败: {ex.Message}");
    }
}

// 初始化数据库上下文
try
{
    using (var scope = app.Services.CreateScope())
    {
        var dbContext = scope.ServiceProvider.GetRequiredService<ECommerceDbContext>();
        
        // 确保数据库连接正常
        bool canConnect = dbContext.Database.CanConnect();
        Console.WriteLine($"数据库连接状态: {canConnect}");
        
        if (!canConnect)
        {
            Console.WriteLine("正在创建数据库表...");
            bool created = dbContext.Database.EnsureCreated();
            Console.WriteLine($"数据库表创建: {created}");
        }
        else
        {
            Console.WriteLine("数据库已连接");
        }
        
        // 检查表是否存在
        try
        {
            var productCount = dbContext.Products.Count();
            Console.WriteLine($"Products 表记录数: {productCount}");
        }
        catch
        {
            Console.WriteLine("Products 表不存在，正在创建...");
            dbContext.Database.ExecuteSqlRaw(@"
                CREATE TABLE IF NOT EXISTS Products (
                    Id INTEGER PRIMARY KEY AUTOINCREMENT,
                    Name TEXT NOT NULL,
                    Description TEXT NOT NULL,
                    Price REAL NOT NULL,
                    Category TEXT NOT NULL DEFAULT 'Electronics',
                    StockQuantity INTEGER NOT NULL DEFAULT 0,
                    ImageUrl TEXT NOT NULL DEFAULT ''
                )");
        }
        
        try
        {
            var purchaseCount = dbContext.Purchases.Count();
            Console.WriteLine($"Purchases 表记录数: {purchaseCount}");
        }
        catch
        {
            Console.WriteLine("Purchases 表不存在，正在创建...");
            dbContext.Database.ExecuteSqlRaw(@"
                CREATE TABLE IF NOT EXISTS Purchases (
                    Id INTEGER PRIMARY KEY AUTOINCREMENT,
                    ProductId INTEGER NOT NULL,
                    ProductName TEXT NOT NULL,
                    Price REAL NOT NULL,
                    Quantity INTEGER NOT NULL DEFAULT 1,
                    PurchaseDate TEXT NOT NULL DEFAULT (datetime('now')),
                    UserId TEXT NOT NULL DEFAULT 'demo-user'
                )");
        }
        
        // 添加初始数据
        if (!dbContext.Products.Any())
        {
            Console.WriteLine("添加初始产品数据...");
            dbContext.Products.AddRange(
                new Product { Name = "Smartphone", Description = "Latest smartphone", Price = 599.99m, Category = "Electronics", StockQuantity = 100, ImageUrl = "/images/phone.jpg" },
                new Product { Name = "Laptop", Description = "High-performance laptop", Price = 1299.99m, Category = "Electronics", StockQuantity = 50, ImageUrl = "/images/laptop.jpg" },
                new Product { Name = "Headphones", Description = "Wireless headphones", Price = 99.99m, Category = "Electronics", StockQuantity = 200, ImageUrl = "/images/headphones.jpg" }
            );
            dbContext.SaveChanges();
            Console.WriteLine("✓ 初始产品数据已添加");
        }
    }
    Console.WriteLine("✓ 数据库初始化完成");
}
catch (Exception ex)
{
    Console.WriteLine($"数据库初始化错误: {ex.Message}");
    Console.WriteLine($"完整错误: {ex}");
}

app.Run();
