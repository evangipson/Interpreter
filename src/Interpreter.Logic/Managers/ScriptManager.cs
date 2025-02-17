using Lua;

using Interpreter.Logic.Services;

namespace Interpreter.Logic.Managers;

/// <inheritdoc cref="IScriptManager"/>
public class ScriptManager(ISettingsService settingsService, IScriptService scriptService) : IScriptManager
{
    private string ScriptPath => settingsService.ScriptRootPath;

    public bool TryGetResult<TResult>(string scriptRelativePath, IEnumerable<LuaValue> arguments, out TResult? result)
    {
        var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);

        result = default;
        if(!scriptService.TryGetResult(scriptPath, arguments, out TResult? scriptResult))
        {
            return false;
        }

        result = scriptResult;
        return true;
    }

    public Task<TResult?> GetResultAsync<TResult>(string scriptRelativePath, IEnumerable<LuaValue> arguments)
    {
        var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);
        return scriptService.GetResultAsync<TResult>(scriptPath, arguments);
    }
}
