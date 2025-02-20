using Microsoft.Extensions.Logging;
using Lua;
using Lua.Standard;
using Lua.CodeAnalysis.Compilation;
using Lua.Internal;
using Lua.Runtime;
using System.Text.Json;

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

    public void AddToGlobals(string name, LuaValue value)
    {
        logger.LogInformation(@$"{nameof(AddToGlobals)}: Adding ""{name}"" to the lua globals, which is a function with the return value of ""{value}"".");
        _luaState.Environment[name] = new LuaFunction((context, buffer, ct) =>
        {
            buffer.Span[0] = value;

            return new(1);
        });
    }

    public void ConfigureStandardLibraries(string path)
    {
        _luaState.OpenStandardLibraries();
        _luaState.Environment["require"] = new LuaFunction("require", async (context, buffer, cancellationToken) =>
        {
            string arg0 = context.GetArgument<string>(0);
            LuaTable loaded = context.State.LoadedModules;
            if (!loaded.TryGetValue(arg0, out var value))
            {
                string sanitizedModuleName = arg0.Replace("\\", "\\\\").Replace("/", "\\\\").Replace(".", "\\\\");
                LuaModule luaModule = await context.State.ModuleLoader.LoadAsync($"{path}\\{sanitizedModuleName}", cancellationToken);
                Chunk proto = LuaCompiler.Default.Compile(luaModule.ReadText(), luaModule.Name);
                using PooledArray<LuaValue> methodBuffer = new(1);
                await new Closure(context.State, proto).InvokeAsync(context, methodBuffer.AsMemory(), cancellationToken);
                value = methodBuffer[0];
                loaded[arg0] = value;
            }

            buffer.Span[0] = value;
            return 1;
        });
    }

    public Dictionary<LuaValue, LuaValue> GetValuesFromTable(LuaTable luaTable)
    {
        if (!luaTable.Metatable?.TryGetValue("get_key", out LuaValue result) ?? false)
        {
            return [];
        }

        Dictionary<LuaValue, LuaValue> results = [];
        for (var i = 1; i <= luaTable.HashMapCount; i++)
        {
            if (luaTable.TryGetNext(i, out KeyValuePair<LuaValue, LuaValue> keyValue))
            {
                results.Add(keyValue.Key, keyValue.Value);
            }
        }

        return results;
    }

    private async Task<TResult?> InvokeScriptAsync<TResult>(string scriptPath, IEnumerable<LuaValue>? arguments = null)
    {
        // Make sure the script exists before attempting to run it.
        if (!File.Exists(scriptPath))
        {
            logger.LogWarning(@$"{nameof(InvokeScriptAsync)}: Could not find the ""{scriptPath}"" lua script. Returning default value for {typeof(TResult)}.");
            return default;
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
