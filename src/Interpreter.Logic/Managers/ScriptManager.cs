using Lua;

using Interpreter.Logic.Services;

namespace Interpreter.Logic.Managers;

/// <inheritdoc cref="IScriptManager"/>
public class ScriptManager(ISettingsService settingsService, IScriptService scriptService) : IScriptManager
{
    private string? _scriptPath;
    private string ScriptPath
    {
        get
        {
            AddPathInformationToGlobals();
            return _scriptPath ??= settingsService.ScriptRootPath;
        }
    }

    public bool TryGetResult<TResult>(string scriptRelativePath, out TResult? result)
    {
        var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);

        result = default;
        if (!scriptService.TryGetResult(scriptPath, out TResult? scriptResult))
        {
            return false;
        }

        result = scriptResult;
        return true;
    }

    public bool TryGetResult<TResult>(string scriptRelativePath, IEnumerable<LuaValue> arguments, out TResult? result)
    {
        var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);

        result = default;
        if(!scriptService.TryGetResult(scriptPath, arguments ?? [], out TResult? scriptResult))
        {
            return false;
        }

        result = scriptResult;
        return true;
    }

    public Task<TResult?> GetResultAsync<TResult>(string scriptRelativePath, IEnumerable<LuaValue>? arguments = null)
    {
        var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);
        return scriptService.GetResultAsync<TResult>(scriptPath, arguments ?? []);
    }

    private void AddPathInformationToGlobals()
    {
        // Don't set globals if they've already been set, i.e.: the script path has been loaded.
        if (!string.IsNullOrWhiteSpace(_scriptPath))
        {
            return;
        }

        // Don't set globals if there is no script root path from the settings service.
        if (string.IsNullOrWhiteSpace(settingsService.ScriptRootPath))
        {
            return;
        }

        var fullScriptPath = Path.GetFullPath(settingsService.ScriptRootPath).Replace("\\", "\\\\");
        scriptService.AddToGlobals("SCRIPTS_PATH", fullScriptPath);

        var relativeScriptPath = Path.GetRelativePath(Environment.CurrentDirectory, fullScriptPath).Replace("\\", "\\\\");
        scriptService.AddToGlobals("INCLUDE_PATH", relativeScriptPath);
    }
}
