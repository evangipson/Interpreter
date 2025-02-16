using Microsoft.Extensions.Logging;
using Lua;
using Lua.Standard;

namespace Interpreter.Logic.Services
{
    public class ScriptService(ILogger<ScriptService> logger) : IScriptService
    {
        private readonly LuaState _luaState = LuaState.Create();

        public async Task<TResult?> GetResult<TResult>(string scriptPath, string functionName, IEnumerable<LuaValue> arguments)
        {
            ArgumentNullException.ThrowIfNullOrWhiteSpace(scriptPath);
            ArgumentNullException.ThrowIfNullOrWhiteSpace(functionName);

            logger.LogInformation(@$"{nameof(GetResult)}: Getting result from the ""{functionName}"" function from the ""{scriptPath}"" lua script.");
            if(!File.Exists(scriptPath))
            {
                logger.LogWarning(@$"{nameof(GetResult)}: Could not find lua script. Returning default value for {typeof(TResult)}.");
                return default;
            }

            _luaState.OpenStandardLibraries();

            var results = await _luaState.DoFileAsync(scriptPath);
            if(results == null || results.Length == 0)
            {
                logger.LogWarning(@$"{nameof(GetResult)}: Could not get file contents from ""{scriptPath}"" lua script. Returning default value for {typeof(TResult)}.");
                return default;
            }

            var func = results[0].Read<LuaFunction>();
            var funcResults = await func.InvokeAsync(_luaState, [.. arguments]);
            try
            {
                var result = funcResults[0].Read<TResult>();
                logger.LogInformation(@$"{nameof(GetResult)}: Got result from ""{scriptPath}"" lua script: ""{result}"" as {funcResults[0].Type}.");

                return result;
            }
            catch
            {
                logger.LogWarning(@$"{nameof(GetResult)}: Could not get result as {typeof(TResult)} for ""{scriptPath}"" lua script. Returning default value for {typeof(TResult)}.");
                return default;
            }
        }
    }
}
