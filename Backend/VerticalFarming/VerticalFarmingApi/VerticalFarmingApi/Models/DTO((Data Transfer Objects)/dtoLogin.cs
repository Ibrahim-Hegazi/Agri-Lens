using System.ComponentModel.DataAnnotations;

namespace VerticalFarmingApi.Models.DTO__Data_Transfer_Objects_
{
    public class dtoLogin
    {
        [Required(ErrorMessage = "Username is required.")]
        [StringLength(100, ErrorMessage = "Username cannot exceed 100 characters.")]
        public string Username { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        [StringLength(100, ErrorMessage = "Password cannot exceed 100 characters.")]
        public string Password { get; set; }
    }
}
