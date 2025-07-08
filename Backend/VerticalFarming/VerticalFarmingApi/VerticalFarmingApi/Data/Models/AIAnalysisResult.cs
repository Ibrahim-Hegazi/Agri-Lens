using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace VerticalFarmingApi.Data.Models
{
    public class AIAnalysisResult
    {
        public int Id { get; set; }
        public string FileName { get; set; }
        public string AnnotatedImagePath { get; set; }
        public string ZipPath { get; set; }
        public int ClassId { get; set; }
        public float Confidence { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public float HealthPercentage { get; set; }

        //public int CropId { get; set; } // مفتاح أجنبي
        //public Crop Crop { get; set; }  // علاقة التنقل
    }
}

