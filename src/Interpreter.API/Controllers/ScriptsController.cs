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
    [Produces(MediaTypeNames.Application.Json)]
    [EndpointDescription("An example of a generic, synchronous call to any script with any number of arguments, and receiving a generic value.")]
    public dynamic? Run(string scriptRelativePath, [FromBody] IEnumerable<string>? arguments = null) => scriptManager.Run(scriptRelativePath, arguments);

    [HttpPost]
    [Route("run-async")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    [Produces(MediaTypeNames.Application.Json)]
    [EndpointDescription("An example of a generic, asynchronous call to any script with any number of arguments, and receiving a task with a generic value.")]
    public Task<dynamic?> RunAsync(string scriptRelativePath, [FromBody] IEnumerable<string>? arguments = null) => scriptManager.RunAsync(scriptRelativePath, arguments);
}
