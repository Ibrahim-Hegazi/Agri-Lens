using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Threading.Tasks;
using VerticalFarmingApi.Data.Models;
using VerticalFarmingApi.Models;
using VerticalFarmingApi.Models.DTO__Data_Transfer_Objects_;
using VerticalFarmingApi.Repositories.IRepository;

namespace VerticalFarmingApi.Controllers
{
    [Authorize(Roles = "Admin,Farmer")]
    [Route("api/[controller]")]
    [ApiController]
    public class CropsController : ControllerBase
    {
        private readonly IUnitOfWork _unitOfWork;

        public CropsController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public async Task<IActionResult> GetCrops()
        {
            var crops = await _unitOfWork.Crops.GetAllAsync();
            return Ok(crops.Select(c => new CropDto
            {
                Id = c.Id,
                Type = c.Type,
                PlantingDate = c.PlantingDate,
                SensorId = c.SensorId
            }));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCrop(int id)
        {
            var crop = await _unitOfWork.Crops.GetByIdAsync(id);
            if (crop == null) return NotFound();

            return Ok(new CropDto
            {
                Id = crop.Id,
                Type = crop.Type,
                PlantingDate = crop.PlantingDate,
                SensorId = crop.SensorId
            });
        }

        [HttpPost]
        public async Task<IActionResult> CreateCrop([FromBody] CropDto cropDto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            if (cropDto.SensorId.HasValue && await _unitOfWork.Sensors.GetByIdAsync(cropDto.SensorId.Value) == null)
                return BadRequest("The specified SensorId does not exist.");

            var crop = new Crop
            {
                Type = cropDto.Type,
                PlantingDate = cropDto.PlantingDate,
                FarmId = cropDto.FarmId ?? 0,
                SensorId = cropDto.SensorId
            };

            await _unitOfWork.Crops.AddAsync(crop);
            await _unitOfWork.CompleteAsync();

            return CreatedAtAction(nameof(GetCrop), new { id = crop.Id }, new { crop.Id, crop.Type, crop.PlantingDate, crop.SensorId });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCrop(int id, [FromBody] CropDto cropDto)
        {
            if (id != cropDto.Id) return BadRequest();

            var crop = await _unitOfWork.Crops.GetByIdAsync(id);
            if (crop == null) return NotFound();

            crop.Type = cropDto.Type;
            crop.PlantingDate = cropDto.PlantingDate;
            crop.SensorId = cropDto.SensorId;

            _unitOfWork.Crops.Update(crop);
            await _unitOfWork.CompleteAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCrop(int id)
        {
            var crop = await _unitOfWork.Crops.GetByIdAsync(id);
            if (crop == null) return NotFound();

            _unitOfWork.Crops.Remove(crop);
            await _unitOfWork.CompleteAsync();

            return NoContent();
        }
    }
}
