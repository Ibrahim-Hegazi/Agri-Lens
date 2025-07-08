using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VerticalFarmingApi.Data;
using VerticalFarmingApi.Data.Models;
using VerticalFarmingApi.Data.ViewModel;
using VerticalFarmingApi.Models;
using VerticalFarmingApi.Models.DTO__Data_Transfer_Objects_;
using VerticalFarmingApi.Repositories.IRepository;

namespace VerticalFarmingApi.Controllers
{
    //[Authorize(Roles = "Admin,Farmer")]
    [Route("api/[controller]")]
    [ApiController]
    public class AIAnalysisSensorController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public AIAnalysisSensorController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet("results")]
        public IActionResult GetAnalysisResults()
        {
            var results = _context.AIAnalysisResults
                .GroupBy(r => r.FileName)
                .Select(g => new AIAnalysisResultImageViewModel
                {
                    AnnotatedImagePath = g.First().AnnotatedImagePath,
                    HealthPercentage = g.First().HealthPercentage
                })
                .ToList();

            return Ok(results);
        }

        [HttpGet("image")]
        public IActionResult GetAnnotatedImage([FromQuery] string path)
        {
            if (string.IsNullOrEmpty(path))
                return BadRequest("Image path is required.");

            var fullPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", path.TrimStart('/'));

            if (!System.IO.File.Exists(fullPath))
                return NotFound("Image not found.");

            var imageBytes = System.IO.File.ReadAllBytes(fullPath);
            return File(imageBytes, "image/jpeg");
        }

        [HttpGet("image-by-id/{id}")]
        public IActionResult GetAnnotatedImageById(int id)
        {
            var result = _context.AIAnalysisResults.FirstOrDefault(r => r.Id == id);
            if (result == null)
                return NotFound("AI Analysis result not found.");

            var relativePath = result.AnnotatedImagePath;
            var fullPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", relativePath.TrimStart('/'));

            if (!System.IO.File.Exists(fullPath))
                return NotFound("Image file not found.");

            var imageBytes = System.IO.File.ReadAllBytes(fullPath);
            return File(imageBytes, "image/jpeg");
        }

        //[HttpGet("latest-per-crop")]
        //public IActionResult GetLatestImagesPerCrop()
        //{
        //    var results = _context.AIAnalysisResults
        //        .Include(r => r.Crop) // لو عايز تعرض اسم النبتة
        //        .GroupBy(r => r.CropId)
        //        .Select(g => g.OrderByDescending(r => r.CreatedAt).FirstOrDefault())
        //        .Select(r => new
        //        {
        //            CropName = r.Crop.Type,
        //            AnnotatedImageUrl = Url.Action("GetAnnotatedImageById", new { id = r.Id }),
        //            HealthPercentage = r.HealthPercentage,
        //            CreatedAt = r.CreatedAt
        //        })
        //        .ToList();

        //    return Ok(results);
        //}

    }
}
