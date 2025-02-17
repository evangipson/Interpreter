using Microsoft.Extensions.Logging;
using Lua;
using Lua.Standard;

namespace Interpreter.Logic.Services;

/// <inheritdoc cref="IScriptService"/>
public class ScriptService(ILogger<ScriptService> logger) : IScriptService
{
    private readonly LuaState _luaState = LuaState.Create();
    private bool _addedStandardLibraries = false;

    public bool TryGetResult<TResult>(string scriptPath, IEnumerable<LuaValue> arguments, out TResult? result)
    {
        ArgumentNullException.ThrowIfNullOrWhiteSpace(scriptPath);

        result = default;
        try
        {
            result = InvokeScriptAsync<TResult>(scriptPath, arguments).GetAwaiter().GetResult();
            return true;
        }
        catch
        {
            return false;
        }
    }

    public async Task<TResult?> GetResultAsync<TResult>(string scriptPath, IEnumerable<LuaValue> arguments)
    {
        ArgumentNullException.ThrowIfNullOrWhiteSpace(scriptPath);

        try
        {
            return await InvokeScriptAsync<TResult>(scriptPath, arguments);
        }
        catch
        {
            return default;
        }
    }

    private async Task<TResult?> InvokeScriptAsync<TResult>(string scriptPath, IEnumerable<LuaValue> arguments)
    {
        // Make sure the script exists before attempting to run it.
        if (!File.Exists(scriptPath))
        {
            logger.LogWarning(@$"{nameof(InvokeScriptAsync)}: Could not find the ""{scriptPath}"" lua script. Returning default value for {typeof(TResult)}.");
            return default;
        }

        // Add lua standard libraries once, and only once.
        if (!_addedStandardLibraries)
        {
            _luaState.OpenStandardLibraries();
            _addedStandardLibraries = true;
        }

        // Get the function from the lua file.
        var results = await _luaState.DoFileAsync(scriptPath);
        if (results == null || results.Length == 0)
        {
            logger.LogWarning(@$"{nameof(InvokeScriptAsync)}: Could not get file contents from ""{scriptPath}"" lua script. Returning default value for {typeof(TResult)}.");
            return default;
        }
        var func = results[0].Read<LuaFunction>();

        // Invoke the function with the provided arguments, and return the results.
        var funcResults = await func.InvokeAsync(_luaState, [.. arguments]);
        if(!funcResults[0].TryRead(out TResult result))
        {
            logger.LogWarning(@$"{nameof(InvokeScriptAsync)}: Could not get result as {typeof(TResult)} for ""{scriptPath}"" lua script. Returning default value for {typeof(TResult)}.");
            return default;
        }

        logger.LogInformation(@$"{nameof(InvokeScriptAsync)}: Got result from ""{scriptPath}"" lua script: ""{result}"" as {funcResults[0].Type}.");
        return result;
    }
}
