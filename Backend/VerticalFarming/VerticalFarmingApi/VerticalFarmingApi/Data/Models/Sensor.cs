using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace VerticalFarmingApi.Data.Models
{
    public class Sensor
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; } // مثلاً "Temperature", "Humidity", "CO2", إلخ
        public int FarmId { get; set; }
        public virtual Farm Farm { get; set; }

        public ICollection<SensorData> SensorData { get; set; }
    }

}
