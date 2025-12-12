using Microsoft.EntityFrameworkCore;
using ECommerce.DAL;

namespace ECommerce.DAL
{
    public class ECommerceDbContext : DbContext
    {
        public ECommerceDbContext(DbContextOptions<ECommerceDbContext> options)
            : base(options)
        {
        }
        
        public DbSet<Product> Products { get; set; }
        public DbSet<Purchase> Purchases { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            // 配置 Product 实体
            modelBuilder.Entity<Product>(entity =>
            {
                entity.Property(p => p.Price)
                    .HasColumnType("decimal(18,2)");
                
                entity.Property(p => p.Name)
                    .HasMaxLength(200);
                    
                entity.Property(p => p.Category)
                    .HasMaxLength(100);
            });
            
            // 配置 Purchase 实体
            modelBuilder.Entity<Purchase>(entity =>
            {
                entity.Property(p => p.Price)
                    .HasColumnType("decimal(18,2)");
                
                entity.Property(p => p.ProductName)
                    .HasMaxLength(200);
                
                entity.Property(p => p.UserId)
                    .HasMaxLength(100)
                    .HasDefaultValue("demo-user");
                
                entity.Property(p => p.Quantity)
                    .HasDefaultValue(1);
                
                entity.Property(p => p.PurchaseDate)
                    .HasDefaultValueSql("datetime('now')");
            });
        }
    }
}
