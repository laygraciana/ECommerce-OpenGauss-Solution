using System.Collections.Generic;
using ECommerce.BLL.DTO;

namespace ECommerce.BLL.Services
{
    public interface IPurchaseService
    {
        PurchaseResponseDTO CreatePurchase(PurchaseDTO purchaseDto);
        List<PurchaseDTO> GetAllPurchases();
        PurchaseDTO GetPurchaseById(int id);
    }
}
