using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace VerticalFarmingApi.Migrations
{
    /// <inheritdoc />
    public partial class AddDataToSensoDataTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Farms",
                columns: new[] { "FarmId", "Location", "Name", "UserId" },
                values: new object[] { 1, "Smart Zone", "AI Demo Farm", "4e594207-03c3-4410-a350-1945a7514801" });

            migrationBuilder.InsertData(
                table: "Sensors",
                columns: new[] { "Id", "FarmId", "Name", "Type" },
                values: new object[,]
                {
                    { 1, 1, "Air Temp Sensor", "Air Temperature" },
                    { 2, 1, "Air Moisture Sensor", "Air Moisture" },
                    { 3, 1, "Soil Moisture Sensor", "Soil Moisture" }
                });

            migrationBuilder.InsertData(
                table: "SensorDatas",
                columns: new[] { "Id", "SensorId", "Timestamp", "Value" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), 20.0 },
                    { 2, 1, new DateTime(2024, 1, 1, 1, 0, 0, 0, DateTimeKind.Utc), 21.0 },
                    { 3, 1, new DateTime(2024, 1, 1, 2, 0, 0, 0, DateTimeKind.Utc), 22.0 },
                    { 4, 1, new DateTime(2024, 1, 1, 3, 0, 0, 0, DateTimeKind.Utc), 23.0 },
                    { 5, 1, new DateTime(2024, 1, 1, 4, 0, 0, 0, DateTimeKind.Utc), 24.0 },
                    { 6, 1, new DateTime(2024, 1, 1, 5, 0, 0, 0, DateTimeKind.Utc), 20.0 },
                    { 7, 1, new DateTime(2024, 1, 1, 6, 0, 0, 0, DateTimeKind.Utc), 21.0 },
                    { 8, 1, new DateTime(2024, 1, 1, 7, 0, 0, 0, DateTimeKind.Utc), 22.0 },
                    { 9, 1, new DateTime(2024, 1, 1, 8, 0, 0, 0, DateTimeKind.Utc), 23.0 },
                    { 10, 1, new DateTime(2024, 1, 1, 9, 0, 0, 0, DateTimeKind.Utc), 24.0 },
                    { 11, 1, new DateTime(2024, 1, 1, 10, 0, 0, 0, DateTimeKind.Utc), 20.0 },
                    { 12, 1, new DateTime(2024, 1, 1, 11, 0, 0, 0, DateTimeKind.Utc), 21.0 },
                    { 13, 1, new DateTime(2024, 1, 1, 12, 0, 0, 0, DateTimeKind.Utc), 22.0 },
                    { 14, 1, new DateTime(2024, 1, 1, 13, 0, 0, 0, DateTimeKind.Utc), 23.0 },
                    { 15, 1, new DateTime(2024, 1, 1, 14, 0, 0, 0, DateTimeKind.Utc), 24.0 },
                    { 16, 1, new DateTime(2024, 1, 1, 15, 0, 0, 0, DateTimeKind.Utc), 20.0 },
                    { 17, 1, new DateTime(2024, 1, 1, 16, 0, 0, 0, DateTimeKind.Utc), 21.0 },
                    { 18, 1, new DateTime(2024, 1, 1, 17, 0, 0, 0, DateTimeKind.Utc), 22.0 },
                    { 19, 1, new DateTime(2024, 1, 1, 18, 0, 0, 0, DateTimeKind.Utc), 23.0 },
                    { 20, 1, new DateTime(2024, 1, 1, 19, 0, 0, 0, DateTimeKind.Utc), 24.0 },
                    { 21, 1, new DateTime(2024, 1, 1, 20, 0, 0, 0, DateTimeKind.Utc), 20.0 },
                    { 22, 1, new DateTime(2024, 1, 1, 21, 0, 0, 0, DateTimeKind.Utc), 21.0 },
                    { 23, 1, new DateTime(2024, 1, 1, 22, 0, 0, 0, DateTimeKind.Utc), 22.0 },
                    { 24, 1, new DateTime(2024, 1, 1, 23, 0, 0, 0, DateTimeKind.Utc), 23.0 },
                    { 25, 2, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), 50.0 },
                    { 26, 2, new DateTime(2024, 1, 1, 1, 0, 0, 0, DateTimeKind.Utc), 51.0 },
                    { 27, 2, new DateTime(2024, 1, 1, 2, 0, 0, 0, DateTimeKind.Utc), 52.0 },
                    { 28, 2, new DateTime(2024, 1, 1, 3, 0, 0, 0, DateTimeKind.Utc), 53.0 },
                    { 29, 2, new DateTime(2024, 1, 1, 4, 0, 0, 0, DateTimeKind.Utc), 54.0 },
                    { 30, 2, new DateTime(2024, 1, 1, 5, 0, 0, 0, DateTimeKind.Utc), 55.0 },
                    { 31, 2, new DateTime(2024, 1, 1, 6, 0, 0, 0, DateTimeKind.Utc), 56.0 },
                    { 32, 2, new DateTime(2024, 1, 1, 7, 0, 0, 0, DateTimeKind.Utc), 57.0 },
                    { 33, 2, new DateTime(2024, 1, 1, 8, 0, 0, 0, DateTimeKind.Utc), 58.0 },
                    { 34, 2, new DateTime(2024, 1, 1, 9, 0, 0, 0, DateTimeKind.Utc), 59.0 },
                    { 35, 2, new DateTime(2024, 1, 1, 10, 0, 0, 0, DateTimeKind.Utc), 50.0 },
                    { 36, 2, new DateTime(2024, 1, 1, 11, 0, 0, 0, DateTimeKind.Utc), 51.0 },
                    { 37, 2, new DateTime(2024, 1, 1, 12, 0, 0, 0, DateTimeKind.Utc), 52.0 },
                    { 38, 2, new DateTime(2024, 1, 1, 13, 0, 0, 0, DateTimeKind.Utc), 53.0 },
                    { 39, 2, new DateTime(2024, 1, 1, 14, 0, 0, 0, DateTimeKind.Utc), 54.0 },
                    { 40, 2, new DateTime(2024, 1, 1, 15, 0, 0, 0, DateTimeKind.Utc), 55.0 },
                    { 41, 2, new DateTime(2024, 1, 1, 16, 0, 0, 0, DateTimeKind.Utc), 56.0 },
                    { 42, 2, new DateTime(2024, 1, 1, 17, 0, 0, 0, DateTimeKind.Utc), 57.0 },
                    { 43, 2, new DateTime(2024, 1, 1, 18, 0, 0, 0, DateTimeKind.Utc), 58.0 },
                    { 44, 2, new DateTime(2024, 1, 1, 19, 0, 0, 0, DateTimeKind.Utc), 59.0 },
                    { 45, 2, new DateTime(2024, 1, 1, 20, 0, 0, 0, DateTimeKind.Utc), 50.0 },
                    { 46, 2, new DateTime(2024, 1, 1, 21, 0, 0, 0, DateTimeKind.Utc), 51.0 },
                    { 47, 2, new DateTime(2024, 1, 1, 22, 0, 0, 0, DateTimeKind.Utc), 52.0 },
                    { 48, 2, new DateTime(2024, 1, 1, 23, 0, 0, 0, DateTimeKind.Utc), 53.0 },
                    { 49, 3, new DateTime(2024, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), 40.0 },
                    { 50, 3, new DateTime(2024, 1, 1, 1, 0, 0, 0, DateTimeKind.Utc), 41.0 },
                    { 51, 3, new DateTime(2024, 1, 1, 2, 0, 0, 0, DateTimeKind.Utc), 42.0 },
                    { 52, 3, new DateTime(2024, 1, 1, 3, 0, 0, 0, DateTimeKind.Utc), 43.0 },
                    { 53, 3, new DateTime(2024, 1, 1, 4, 0, 0, 0, DateTimeKind.Utc), 44.0 },
                    { 54, 3, new DateTime(2024, 1, 1, 5, 0, 0, 0, DateTimeKind.Utc), 45.0 },
                    { 55, 3, new DateTime(2024, 1, 1, 6, 0, 0, 0, DateTimeKind.Utc), 46.0 },
                    { 56, 3, new DateTime(2024, 1, 1, 7, 0, 0, 0, DateTimeKind.Utc), 40.0 },
                    { 57, 3, new DateTime(2024, 1, 1, 8, 0, 0, 0, DateTimeKind.Utc), 41.0 },
                    { 58, 3, new DateTime(2024, 1, 1, 9, 0, 0, 0, DateTimeKind.Utc), 42.0 },
                    { 59, 3, new DateTime(2024, 1, 1, 10, 0, 0, 0, DateTimeKind.Utc), 43.0 },
                    { 60, 3, new DateTime(2024, 1, 1, 11, 0, 0, 0, DateTimeKind.Utc), 44.0 },
                    { 61, 3, new DateTime(2024, 1, 1, 12, 0, 0, 0, DateTimeKind.Utc), 45.0 },
                    { 62, 3, new DateTime(2024, 1, 1, 13, 0, 0, 0, DateTimeKind.Utc), 46.0 },
                    { 63, 3, new DateTime(2024, 1, 1, 14, 0, 0, 0, DateTimeKind.Utc), 40.0 },
                    { 64, 3, new DateTime(2024, 1, 1, 15, 0, 0, 0, DateTimeKind.Utc), 41.0 },
                    { 65, 3, new DateTime(2024, 1, 1, 16, 0, 0, 0, DateTimeKind.Utc), 42.0 },
                    { 66, 3, new DateTime(2024, 1, 1, 17, 0, 0, 0, DateTimeKind.Utc), 43.0 },
                    { 67, 3, new DateTime(2024, 1, 1, 18, 0, 0, 0, DateTimeKind.Utc), 44.0 },
                    { 68, 3, new DateTime(2024, 1, 1, 19, 0, 0, 0, DateTimeKind.Utc), 45.0 },
                    { 69, 3, new DateTime(2024, 1, 1, 20, 0, 0, 0, DateTimeKind.Utc), 46.0 },
                    { 70, 3, new DateTime(2024, 1, 1, 21, 0, 0, 0, DateTimeKind.Utc), 40.0 },
                    { 71, 3, new DateTime(2024, 1, 1, 22, 0, 0, 0, DateTimeKind.Utc), 41.0 },
                    { 72, 3, new DateTime(2024, 1, 1, 23, 0, 0, 0, DateTimeKind.Utc), 42.0 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 29);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 30);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 31);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 32);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 33);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 34);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 35);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 36);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 37);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 38);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 39);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 40);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 41);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 42);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 43);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 44);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 45);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 46);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 47);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 48);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 49);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 50);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 51);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 52);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 53);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 54);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 55);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 56);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 57);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 58);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 59);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 60);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 61);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 62);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 63);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 64);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 65);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 66);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 67);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 68);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 69);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 70);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 71);

            migrationBuilder.DeleteData(
                table: "SensorDatas",
                keyColumn: "Id",
                keyValue: 72);

            migrationBuilder.DeleteData(
                table: "Sensors",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Sensors",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Sensors",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Farms",
                keyColumn: "FarmId",
                keyValue: 1);
        }
    }
}
