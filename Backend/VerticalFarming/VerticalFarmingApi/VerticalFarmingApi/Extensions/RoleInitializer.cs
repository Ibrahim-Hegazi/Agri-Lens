using Microsoft.AspNetCore.Identity;

namespace VerticalFarmingApi.Extensions
{
    public class RoleInitializer
    {
        public static async Task InitializeRolesAsync(RoleManager<IdentityRole> roleManager)
        {
            string[] roleNames = { "Admin", "Farmer" };

            foreach (var roleName in roleNames)
            {
                if (!await roleManager.RoleExistsAsync(roleName))
                {
                    await roleManager.CreateAsync(new IdentityRole(roleName));
                    Console.WriteLine($"Role '{roleName}' created.");
                }
            }
        }
    }
}
