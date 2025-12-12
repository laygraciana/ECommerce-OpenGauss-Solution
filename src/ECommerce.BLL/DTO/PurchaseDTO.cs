namespace ECommerce.BLL.DTO
{
    public class PurchaseDTO
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int Quantity { get; set; } = 1;
    }

    public class PurchaseResponseDTO
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public int PurchaseId { get; set; }
    }
}
