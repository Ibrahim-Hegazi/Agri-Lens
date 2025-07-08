using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using VerticalFarmingApi.Data.Models;
using VerticalFarmingApi.Models.DTO__Data_Transfer_Objects_;
using VerticalFarmingApi.Repositories.IRepository;

namespace VerticalFarmingApi.Controllers
{
    //[Authorize(Roles = "Admin,Farmer")]
    [Route("api/[controller]")]
    [ApiController]
    public class SensorsController : ControllerBase
    {
        private readonly IUnitOfWork _unitOfWork;

        public SensorsController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var sensors = await _unitOfWork.Sensors.GetAllAsync();
            return Ok(sensors.Select(s => new SensorDto
            {
                Id = s.Id,
                Type = s.Type,
                Name = s.Name,
                FarmId = s.FarmId
            }));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var sensor = await _unitOfWork.Sensors.GetByIdAsync(id);
            if (sensor == null)
                return NotFound();

            return Ok(new SensorDto
            {
                Id = sensor.Id,
                Type = sensor.Type,
                Name = sensor.Name,
                FarmId = sensor.FarmId
            });
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] SensorDto sensorDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var sensor = new Sensor
            {
                Type = sensorDto.Type,
                Name = sensorDto.Name,
                FarmId = sensorDto.FarmId
            };

            await _unitOfWork.Sensors.AddAsync(sensor);
            await _unitOfWork.CompleteAsync();

            return CreatedAtAction(nameof(GetById), new { id = sensor.Id }, sensorDto);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] SensorDto sensorDto)
        {
            if (id != sensorDto.Id)
                return BadRequest();

            var sensor = await _unitOfWork.Sensors.GetByIdAsync(id);
            if (sensor == null)
                return NotFound();

            sensor.Type = sensorDto.Type;
            sensor.Name = sensorDto.Name;
            sensor.FarmId = sensorDto.FarmId;

            _unitOfWork.Sensors.Update(sensor);
            await _unitOfWork.CompleteAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var sensor = await _unitOfWork.Sensors.GetByIdAsync(id);
            if (sensor == null)
                return NotFound();

            _unitOfWork.Sensors.Remove(sensor);
            await _unitOfWork.CompleteAsync();

            return NoContent();
        }
    }
}