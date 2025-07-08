using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
using System.IO.Compression;
using System.Text;
using VerticalFarmingApi.Data.Models;
using VerticalFarmingApi.Data;

[Route("api/[controller]")]
[ApiController]
public class AIAnalysisController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public AIAnalysisController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpPost("analyze")]
    public async Task<IActionResult> Analyze(IFormFile file)
    {
        if (file == null || file.Length == 0)
            return BadRequest("File is missing");

        var fastApiUrl = "http://127.0.0.1:8000/segment/";

        using var client = new HttpClient();
        using var content = new MultipartFormDataContent();
        using var stream = file.OpenReadStream();
        var fileContent = new StreamContent(stream);
        fileContent.Headers.ContentType = new MediaTypeHeaderValue("image/jpeg");

        content.Add(fileContent, "file", file.FileName);

        var response = await client.PostAsync(fastApiUrl, content);
        if (!response.IsSuccessStatusCode)
            return StatusCode((int)response.StatusCode, "AI service error");

        var result = await response.Content.ReadAsByteArrayAsync();

        // Save ZIP file
        var zipFileName = $"{Guid.NewGuid()}.zip";
        var zipDirPath = Path.Combine("wwwroot", "ai_results");
        var zipPath = Path.Combine(zipDirPath, zipFileName);
        Directory.CreateDirectory(zipDirPath);
        await System.IO.File.WriteAllBytesAsync(zipPath, result);

        // Extract ZIP
        var extractFolder = Path.Combine(zipDirPath, Path.GetFileNameWithoutExtension(zipFileName));
        ZipFile.ExtractToDirectory(zipPath, extractFolder);

        // Read labels.txt
        var labelsPath = Path.Combine(extractFolder, "labels.txt");
        var labelLines = System.IO.File.Exists(labelsPath)
            ? await System.IO.File.ReadAllLinesAsync(labelsPath, Encoding.UTF8)
            : Array.Empty<string>();

        var results = new List<AIAnalysisResult>();

        foreach (var line in labelLines)
        {
            var parts = line.Split(' ');
            if (parts.Length >= 6)
            {
                var classId = int.Parse(parts[0]);
                var confidence = float.Parse(parts[1]);
                var x1 = float.Parse(parts[2]);
                var y1 = float.Parse(parts[3]);
                var x2 = float.Parse(parts[4]);
                var y2 = float.Parse(parts[5]);

                var resultEntity = new AIAnalysisResult
                {
                    FileName = file.FileName,
                    AnnotatedImagePath = Path.Combine("/ai_results", Path.GetFileNameWithoutExtension(zipFileName), "annotated.jpg"),
                    ZipPath = Path.Combine("/ai_results", zipFileName),
                    ClassId = classId,
                   // CropId = cropId,
                    Confidence = confidence,
                    CreatedAt = DateTime.UtcNow
                };

                results.Add(resultEntity);
                _context.AIAnalysisResults.Add(resultEntity);
            }
        }

        // ✅ احسب HealthPercentage بعد ما تخلص كل النتائج
        if (results.Any())
        {
            var healthValues = results.Select(r => (r.ClassId >= 7 && r.ClassId <= 9) ? 1 : 0).ToList();
            var healthPercentage = ((float)healthValues.Sum() / healthValues.Count) * 100;

            // ✅ حدث القيمة لكل النتائج
            foreach (var r in results)
            {
                r.HealthPercentage = healthPercentage;
            }
        }


        await _context.SaveChangesAsync();

        return Ok(new
        {
            Message = "AI analysis completed and saved",
            ResultCount = results.Count,
            AnnotatedImage = Path.Combine("/ai_results", Path.GetFileNameWithoutExtension(zipFileName), "annotated.jpg"),
            ZipFile = Path.Combine("/ai_results", zipFileName)
        });
    }
}
