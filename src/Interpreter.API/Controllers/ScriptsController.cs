using System.Net.Mime;
using Microsoft.AspNetCore.Mvc;

using Interpreter.Logic.Managers;

namespace Interpreter.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Produces(MediaTypeNames.Application.Json)]
    public class ScriptsController(IScriptManager scriptManager) : ControllerBase
    {
        [HttpPost]
        [Route("[action]")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<int> Add(int a, int b) => await scriptManager.GetResult<int>("numbers/add.lua", "add", [a, b]);

        [HttpPost]
        [Route("[action]")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<string> Loot(string monsterType) => await scriptManager.GetResult<string>("loot/get_loot.lua", "get_loot", [monsterType]) ?? string.Empty;
    }
}
