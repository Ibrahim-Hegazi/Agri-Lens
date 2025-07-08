using VerticalFarmingApi.Data.Models;

namespace VerticalFarmingApi.Models.DTO__Data_Transfer_Objects_
{
    public class SensorDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; } // مثلاً "Temperature", "Humidity", "CO2", إلخ
        public int FarmId { get; set; }
        public virtual Farm Farm { get; set; }

        public ICollection<SensorData> SensorData { get; set; }
    }
}
