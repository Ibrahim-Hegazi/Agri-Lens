using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using VerticalFarmingApi.Data.Models;
using VerticalFarmingApi.Models.DTO__Data_Transfer_Objects_;
using VerticalFarmingApi.Models;

namespace VerticalFarmingApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly IConfiguration configuration;

        public AccountController(UserManager<User> userManager, IConfiguration configuration)
        {
            _userManager = userManager;
            this.configuration = configuration;
        }

        [HttpPost("Register")]
        public async Task<IActionResult> RegisterNewUser(dtoNewUser user)
        {
            if (ModelState.IsValid)
            {
                User newUser = new()
                {
                    UserName = user.UserName,
                    Email = user.Email,
                };
                IdentityResult result = await _userManager.CreateAsync(newUser, user.Password);

                if (result.Succeeded)
                {
                    
                    await _userManager.AddToRoleAsync(newUser, "Farmer");

                    return Ok("User registered successfully!");
                }
                else
                {
                    foreach (var item in result.Errors)
                    {
                        ModelState.AddModelError("", item.Description);
                    }
                }
            }
            return BadRequest(ModelState);
        }


        [HttpPost("Login")]
        public async Task<IActionResult> Login(dtoLogin Login)
        {
            User? user = await _userManager.FindByNameAsync(Login.Username);
            if (user != null)
            {
                if (await _userManager.CheckPasswordAsync(user, Login.Password))
                {
                    var Claims = new List<Claim>();
                    Claims.Add(new Claim(ClaimTypes.Name, user.UserName));
                    Claims.Add(new Claim(ClaimTypes.NameIdentifier, user.Id));
                    Claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
                    var roles = await _userManager.GetRolesAsync(user);
                    foreach (var role in roles)
                    {
                        Claims.Add(new Claim(ClaimTypes.Role, role.ToString()));
                    }
                    //SigningCredentials
                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JWT:SecretKey"]));
                    var sc = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                    var token = new JwtSecurityToken(
                        claims: Claims,
                        issuer: configuration["Jwt:Issuer"],
                        audience: configuration["JWT:Audience"],
                        expires: DateTime.Now.AddHours(1),
                        signingCredentials: sc
                        );
                    //Generate Token
                    var _token = new
                    {
                        token = new JwtSecurityTokenHandler().WriteToken(token),
                        expiration = token.ValidTo,
                    };
                    return Ok(_token);

                }
                else
                {
                    return Unauthorized();
                }
            }
            else
            {
                ModelState.AddModelError("", "User name is valid !");
            }
            return BadRequest(ModelState);
        }
    }
}
