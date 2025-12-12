namespace ECommerce.DAL
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string Category { get; set; } = "Electronics";
        public int StockQuantity { get; set; } = 0;
        
        private string _imageUrl = string.Empty;
        public string ImageUrl 
        { 
            get 
            {
                if (!string.IsNullOrEmpty(_imageUrl))
                    return _imageUrl;
                    
                // Default images based on category
                return Category.ToLower() switch
                {
                    "electronics" => "https://images.unsplash.com/photo-1498049794561-7780e7231661?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80",
                    "computers" => "https://images.unsplash.com/photo-1499951360447-b19be8fe80f5?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80",
                    "audio" => "https://images.unsplash.com/photo-1484704849700-f032a568e944?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80",
                    "phones" => "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80",
                    _ => "https://images.unsplash.com/photo-1556656793-08538906a9f8?ixlib=rb-4.0.3&auto=format&fit=crop&w-600&q=80"
                };
            }
            set { _imageUrl = value; }
        }
    }
}
