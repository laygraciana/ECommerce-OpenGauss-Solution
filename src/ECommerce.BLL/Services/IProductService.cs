using System.Collections.Generic;
using ECommerce.BLL.DTO;

namespace ECommerce.BLL.Services
{
    public interface IProductService
    {
        List<ProductDTO> GetAllProducts();
        ProductDTO? GetProductById(int id);  // 可空类型
    }
}
