using System.Collections.Generic;
using System.Linq;
using ECommerce.DAL;
using ECommerce.BLL.DTO;

namespace ECommerce.BLL.Services
{
    public class ProductService : IProductService
    {
        private readonly ECommerceDbContext _context;
        
        public ProductService(ECommerceDbContext context)
        {
            _context = context;
        }

        public List<ProductDTO> GetAllProducts()
        {
            return _context.Products
                .Select(p => new ProductDTO
                {
                    Id = p.Id,
                    Name = p.Name ?? string.Empty,
                    Description = p.Description ?? string.Empty,
                    Price = p.Price,
                    StockQuantity = p.StockQuantity
                })
                .ToList();
        }
        
        public ProductDTO? GetProductById(int id)
        {
            var product = _context.Products.FirstOrDefault(p => p.Id == id);
            
            if (product == null)
                return null;
                
            return new ProductDTO
            {
                Id = product.Id,
                Name = product.Name ?? string.Empty,
                Description = product.Description ?? string.Empty,
                Price = product.Price,
                StockQuantity = product.StockQuantity
            };
        }
    }
}