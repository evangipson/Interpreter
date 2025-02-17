using Microsoft.Extensions.Logging;
using Lua;
using Lua.Standard;
using System;

namespace Interpreter.Logic.Services;

/// <inheritdoc cref="IScriptService"/>
public class ScriptService(ILogger<ScriptService> logger) : IScriptService
{
    private readonly LuaState _luaState = LuaState.Create();
    private bool _addedStandardLibraries = false;

    public bool TryGetResult<TResult>(string scriptPath, out TResult? result)
    {
        ArgumentNullException.ThrowIfNullOrWhiteSpace(scriptPath);
        result = default;
        try
        {
            result = InvokeScriptAsync<TResult>(scriptPath).GetAwaiter().GetResult();
            return true;
        }
        catch
        {
            return false;
        }
    }

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

    public async Task<TResult?> GetResultAsync<TResult>(string scriptPath, IEnumerable<LuaValue>? arguments = null)
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

    public ValueTask<LuaValue[]> RunAsync(string script)
    {
        ArgumentNullException.ThrowIfNullOrWhiteSpace(script);

        logger.LogWarning(@$"{nameof(RunAsync)}: Running script: ""{script}""");
        return _luaState.DoStringAsync(script);
    }

    private async Task<TResult?> InvokeScriptAsync<TResult>(string scriptPath, IEnumerable<LuaValue>? arguments = null)
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

        // Determine what arguments will be sent based on the state of the provided "arguments"
        LuaValue[] funcArgs = arguments?.Any() == true ? [.. arguments] : [];

        // Invoke the function and return the results.
        LuaValue[] funcResults = [];
        try
        {
            logger.LogInformation(@$"{nameof(InvokeScriptAsync)}: Executing ""{func.Name}"" function from ""{scriptPath}"" lua script.");
            funcResults = await func.InvokeAsync(_luaState, funcArgs);
        }
        catch(LuaParseException exception)
        {
            logger.LogError(exception, @$"{nameof(InvokeScriptAsync)}: Could not parse the lua script at: ""{scriptPath}"".");
            return default;
        }
        catch(LuaRuntimeException exception)
        {
            logger.LogError(exception, @$"{nameof(InvokeScriptAsync)}: Could not run ""{func.Name}()"" in ""{scriptPath}"".");
            return default;
        }

        if (funcResults[0].Type == LuaValueType.Nil)
        {
            logger.LogWarning(@$"{nameof(InvokeScriptAsync)}: Received ""nil"" from ""{func.Name}()"" in ""{scriptPath}"".");
            return default;
        }

        if (!funcResults[0].TryRead(out TResult result))
        {
            logger.LogWarning(@$"{nameof(InvokeScriptAsync)}: Could not cast result from ""{func.Name}()"" in ""{scriptPath}"" as {typeof(TResult)}. Returning default value for {typeof(TResult)}.");
            return default;
        }

        logger.LogInformation(@$"{nameof(InvokeScriptAsync)}: Got result from ""{func.Name}()"" in ""{scriptPath}"": ""{result}"" as {funcResults[0].Type}.");
        return result;
    }
}
