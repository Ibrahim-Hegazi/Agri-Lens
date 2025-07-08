using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace VerticalFarmingApi.Data.Models
{
    public class Crop
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Crop Name is required.")]
        [StringLength(100, ErrorMessage = "Crop Name cannot exceed 100 characters.")]
        public string Type { get; set; }

        public DateTime PlantingDate { get; set; }

        [ForeignKey("Farm")]
        public int FarmId { get; set; }
        public virtual Farm Farm { get; set; }

        [ForeignKey("SensorId")]
        public int? SensorId { get; set; }
        public virtual Sensor Sensor { get; set; }
       // public ICollection<AIAnalysisResult> AIAnalysisResults { get; set; }

    }
}
