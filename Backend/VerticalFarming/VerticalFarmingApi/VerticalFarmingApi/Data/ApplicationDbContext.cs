using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using VerticalFarmingApi.Data.Models;

namespace VerticalFarmingApi.Data
{
    public class ApplicationDbContext : IdentityDbContext<User>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<AIAnalysisResult> AIAnalysisResults { get; set; }
        public DbSet<DiseaseAlert> DiseaseAlerts { get; set; }
        public DbSet<Farm> Farms { get; set; }
        public DbSet<Sensor> Sensors { get; set; }
        public DbSet<SensorData> SensorDatas { get; set; }
        public DbSet<CropHealthReport> CropHealthReports { get; set; }
        public DbSet<Crop> Crops { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // ✅ 1. Farm مرتبط بالـ User
            var farmId = 1;
            var userId = "4e594207-03c3-4410-a350-1945a7514801";

            modelBuilder.Entity<Farm>().HasData(new Farm
            {
                FarmId = farmId,
                Name = "AI Demo Farm",
                Location = "Smart Zone",
                UserId = userId
            });

            // ✅ 2. Sensors
            var sensors = new List<Sensor>
    {
        new Sensor { Id = 1, Name = "Air Temp Sensor", Type = "Air Temperature", FarmId = farmId },
        new Sensor { Id = 2, Name = "Air Moisture Sensor", Type = "Air Moisture", FarmId = farmId },
        new Sensor { Id = 3, Name = "Soil Moisture Sensor", Type = "Soil Moisture", FarmId = farmId }
    };
            modelBuilder.Entity<Sensor>().HasData(sensors);

            // ✅ 3. SensorData بقيم ثابتة ووقت ثابت
            var sensorData = new List<SensorData>();
            int dataId = 1;
            var baseTimestamp = new DateTime(2024, 01, 01, 0, 0, 0, DateTimeKind.Utc);

            foreach (var sensor in sensors)
            {
                for (int i = 0; i < 24; i++)
                {
                    float value = sensor.Id switch
                    {
                        1 => 20.0f + i % 5, // Sensor 1: Air Temperature (20.0 - 24.0)
                        2 => 50.0f + i % 10, // Sensor 2: Air Moisture (50.0 - 59.0)
                        3 => 40.0f + i % 7,  // Sensor 3: Soil Moisture (40.0 - 46.0)
                        _ => 0
                    };

                    sensorData.Add(new SensorData
                    {
                        Id = dataId++,
                        SensorId = sensor.Id,
                        Value = value,
                        Timestamp = baseTimestamp.AddHours(i)
                    });
                }
            }
            modelBuilder.Entity<SensorData>().HasData(sensorData);
        }


    }
}
