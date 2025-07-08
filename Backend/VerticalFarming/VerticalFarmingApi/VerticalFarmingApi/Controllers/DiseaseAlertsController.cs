using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VerticalFarmingApi.Models.DTO__Data_Transfer_Objects_;
using VerticalFarmingApi.Models;
using VerticalFarmingApi.Repositories.IRepository;
using VerticalFarmingApi.Data.Models;
using Microsoft.AspNetCore.Authorization;

namespace VerticalFarmingApi.Controllers
{
    [Authorize(Roles = "Admin,Farmer")]
    [Route("api/[controller]")]
    [ApiController]
    public class DiseaseAlertsController : ControllerBase
    {
        private readonly IUnitOfWork _unitOfWork;

        public DiseaseAlertsController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        
    }
}
