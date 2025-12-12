using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ECommerce.DAL;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ECommerce.WebUI.Controllers
{
    public class HomeController : Controller
    {
        private readonly ECommerceDbContext _context;

        public HomeController(ECommerceDbContext context)
        {
            _context = context;
                
        public IActionResult ApiTest()
        {
            return View();
        }
    }

        public IActionResult Index()
        {
            return View();
                
        public IActionResult ApiTest()
        {
            return View();
        }
    }

        public IActionResult BuyHistory()
        {
            return View();
                
        public IActionResult ApiTest()
        {
            return View();
        }
    }

        // GET: Home/Products
        public async Task<IActionResult> Products()
        {
            var products = await _context.Products.ToListAsync();
            return View(products);
                
        public IActionResult ApiTest()
        {
            return View();
        }
    }

        // GET: Home/ProductDetails/5
        public async Task<IActionResult> ProductDetails(int Id)
        {
            if (Id == null)
            {
                return NotFound();
                    
        public IActionResult ApiTest()
        {
            return View();
        }
    }

            var product = await _context.Products
                .FirstOrDefaultAsync(m => m.Id == Id);
            if (product == null)
            {
                return NotFound();
                    
        public IActionResult ApiTest()
        {
            return View();
        }
    }

            return View(product);
                
        public IActionResult ApiTest()
        {
            return View();
        }
    }
            
        public IActionResult ApiTest()
        {
            return View();
        }
    }
        
        public IActionResult ApiTest()
        {
            return View();
        }
    }

