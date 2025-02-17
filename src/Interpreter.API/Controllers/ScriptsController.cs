using System.Net.Mime;
using Microsoft.AspNetCore.Mvc;

using Interpreter.Logic.Managers;

namespace Interpreter.API.Controllers;

[ApiController]
[Route("[controller]")]
[Produces(MediaTypeNames.Application.Json)]
public class ScriptsController(IScriptManager scriptManager) : ControllerBase
{
    [HttpPost]
    [Route("[action]")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    [EndpointDescription("An example of a generic, synchronous call to any script with any number of arguments, and receiving a generic value.")]
    public object? Run(string scriptRelativePath, [FromBody] IEnumerable<string> arguments) =>
        scriptManager.TryGetResult(scriptRelativePath, [.. arguments], out object? result) ? result : default;

    [HttpPost]
    [Route("run-async")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    [EndpointDescription("An example of a generic, asynchronous call to any script with any number of arguments, and receiving a task with a generic value.")]
    public async Task<object?> RunAsync(string scriptRelativePath, [FromBody] IEnumerable<string> arguments) =>
        await scriptManager.GetResultAsync<object>(scriptRelativePath, [.. arguments]);

    [HttpGet]
    [Route("[action]")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    [EndpointDescription("An example of a synchronous call to a specific script with a specific number of arguments, and receiving a value of a specific type.")]
    public int Add(int a, int b) =>
        scriptManager.TryGetResult("numbers/add.lua", [a, b], out int result) ? result : -1;

    [HttpGet]
    [Route("[action]")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    [EndpointDescription("An example of an asynchronous call to a specific script with a specific argument, and receiving a task with a value of a specific type.")]
    public async Task<string?> Loot(string monsterType) =>
        await scriptManager.GetResultAsync<string>("loot/get_loot.lua", [monsterType]);
}
