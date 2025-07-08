using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace VerticalFarmingApi.Data.Models
{
    public class Farm
    {
        [Key]
        public int FarmId { get; set; }

        [Required(ErrorMessage = "Farm Name is required.")]
        [StringLength(150, ErrorMessage = "Farm Name cannot exceed 150 characters.")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Location is required.")]
        public string Location { get; set; }

        public string UserId { get; set; }

        public User User { get; set; }

        [JsonIgnore]
        public ICollection<Crop> Crops { get; set; }

        public ICollection<Sensor> Sensors { get; set; }
    }
}
