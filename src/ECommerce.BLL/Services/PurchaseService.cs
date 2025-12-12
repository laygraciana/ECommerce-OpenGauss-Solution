using System;
using System.Collections.Generic;
using System.Linq;
using ECommerce.DAL;
using ECommerce.BLL.DTO;

namespace ECommerce.BLL.Services
{
    public class PurchaseService : IPurchaseService
    {
        private readonly ECommerceDbContext _context;
        
        public PurchaseService(ECommerceDbContext context)
        {
            _context = context;
        }
        
        public PurchaseResponseDTO CreatePurchase(PurchaseDTO purchaseDto)
        {
            try
            {
                // 检查产品是否存在
                var product = _context.Products.Find(purchaseDto.ProductId);
                if (product == null)
                {
                    return new PurchaseResponseDTO
                    {
                        Success = false,
                        Message = "Product not found!"
                    };
                }
                
                // 创建购买记录
                var purchase = new Purchase
                {
                    ProductId = purchaseDto.ProductId,
                    ProductName = purchaseDto.ProductName,
                    Price = purchaseDto.Price,
                    Quantity = purchaseDto.Quantity,
                    PurchaseDate = DateTime.Now,
                    UserId = "demo-user"
                };
                
                _context.Purchases.Add(purchase);
                _context.SaveChanges();
                
                return new PurchaseResponseDTO
                {
                    Success = true,
                    Message = "Purchase successful!",
                    PurchaseId = purchase.Id
                };
            }
            catch (Exception ex)
            {
                return new PurchaseResponseDTO
                {
                    Success = false,
                    Message = $"Error: {ex.Message}"
                };
            }
        }
        
        public List<PurchaseDTO> GetAllPurchases()
        {
            return _context.Purchases
                .OrderByDescending(p => p.PurchaseDate)
                .Select(p => new PurchaseDTO
                {
                    ProductId = p.ProductId,
                    ProductName = p.ProductName,
                    Price = p.Price,
                    Quantity = p.Quantity
                })
                .ToList();
        }
        
        public PurchaseDTO GetPurchaseById(int id)
        {
            var purchase = _context.Purchases.Find(id);
            if (purchase == null)
                return null!;
                
            return new PurchaseDTO
            {
                ProductId = purchase.ProductId,
                ProductName = purchase.ProductName,
                Price = purchase.Price,
                Quantity = purchase.Quantity
            };
        }
    }
}
