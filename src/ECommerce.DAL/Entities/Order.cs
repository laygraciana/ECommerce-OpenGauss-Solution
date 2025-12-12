using System;
using System.Collections.Generic;

namespace ECommerce.DAL.Entities
{
    public class Order
    {
        public int Id { get; set; }
        public string OrderNumber { get; set; } = string.Empty;
        public DateTime OrderDate { get; set; }
        public decimal TotalAmount { get; set; }
        public List<OrderItem> Items { get; set; } = new List<OrderItem>();
        
        // Éú³É¶©µ¥ºÅ
        public void GenerateOrderNumber()
        {
            OrderNumber = $"ORD-{DateTime.Now:yyyyMMdd}-{Id:0000}";
        }
    }

    public class OrderItem
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }
        public decimal Subtotal => UnitPrice * Quantity;
        public int OrderId { get; set; }
        public Order? Order { get; set; }
    }
}
