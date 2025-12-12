using System;

namespace ECommerce.DAL
{
    public class Purchase
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int Quantity { get; set; } = 1;
        public DateTime PurchaseDate { get; set; } = DateTime.Now;
        public string UserId { get; set; } = "demo-user"; // 简单实现，实际应从用户认证获取
    }
}
