using Interpreter.Logic.Services;
using Interpreter.Domain.Extensions;

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

    public dynamic? Run(string scriptRelativePath, IEnumerable<string>? arguments = null)
    {
        var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);

        var result = arguments?.Any() == true
            ? scriptService.TryGetResult(scriptPath, [.. arguments], out dynamic? argsResult) ? argsResult : default
            : scriptService.TryGetResult(scriptPath, out dynamic? noArgResult) ? noArgResult : default;

        return result is string resultString
            ? resultString.TryGetJsonObject()
            : result;
    }

    public async Task<dynamic?> RunAsync(string scriptRelativePath, IEnumerable<string>? arguments = null)
    {
        var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);

        var result = arguments?.Any() == true
            ? await scriptService.GetResultAsync<dynamic>(scriptPath, [.. arguments])
            : await scriptService.GetResultAsync<dynamic>(scriptPath);

        return result is string resultString
            ? resultString.TryGetJsonObject()
            : result;
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
        Environment.SetEnvironmentVariable("Interpreter:ScriptsPath", fullScriptPath);

        var relativeScriptPath = Path.GetRelativePath(Environment.CurrentDirectory, fullScriptPath).Replace("\\", "\\\\");
        scriptService.ConfigureStandardLibraries(relativeScriptPath);
    }
}
