using Microsoft.AspNetCore.Mvc;
using ECommerce.BLL.Services;

namespace ECommerce.WebUI.Controllers
{
    public class HomeController : Controller
    {
        private readonly IProductService _productService;
        private readonly IPurchaseService _purchaseService;
        
        public HomeController(IProductService productService, IPurchaseService purchaseService)
        {
            _productService = productService;
            _purchaseService = purchaseService;
        }
        
        public IActionResult Index()
        {
            return View();
        }
        
        public IActionResult Products()
        {
            var products = _productService.GetAllProducts();
            return View(products);
        }
        
        public IActionResult BuyHistory()
        {
            var purchases = _purchaseService.GetAllPurchases();
            return View(purchases);
        }
    }
}
