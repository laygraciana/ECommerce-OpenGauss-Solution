using Microsoft.AspNetCore.Mvc;
using ECommerce.BLL.Services;
using ECommerce.BLL.DTO;

namespace ECommerce.WebUI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchasesController : ControllerBase
    {
        private readonly IPurchaseService _purchaseService;
        
        public PurchasesController(IPurchaseService purchaseService)
        {
            _purchaseService = purchaseService;
        }
        
        [HttpPost]
        public IActionResult CreatePurchase([FromBody] PurchaseDTO purchaseDto)
        {
            var result = _purchaseService.CreatePurchase(purchaseDto);
            
            if (result.Success)
            {
                return Ok(new
                {
                    success = true,
                    message = result.Message,
                    purchaseId = result.PurchaseId
                });
            }
            
            return BadRequest(new
            {
                success = false,
                message = result.Message
            });
        }
        
        [HttpGet]
        public IActionResult GetAllPurchases()
        {
            var purchases = _purchaseService.GetAllPurchases();
            return Ok(purchases);
        }
        
        [HttpGet("{id}")]
        public IActionResult GetPurchase(int id)
        {
            var purchase = _purchaseService.GetPurchaseById(id);
            if (purchase == null)
                return NotFound();
                
            return Ok(purchase);
        }
    }
}
