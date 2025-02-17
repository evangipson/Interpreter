using Microsoft.Extensions.Options;

using Interpreter.Domain.Options;

namespace Interpreter.Logic.Services;

/// <inheritdoc cref="ISettingsService"/>
public class SettingsService(IOptions<ScriptSettings> scriptSettingsOptions) : ISettingsService
{
    private string? _scriptRootPath;
    public string ScriptRootPath
    {
        get
        {
            SetScriptPathEnvironmentVariable();

            return _scriptRootPath ??= scriptSettingsOptions.Value.Path
                ?? throw new ArgumentNullException($"{nameof(SettingsService)}: Unable to find scripts root path, ensure ScriptSettings:Path is set in application settings.");
        }
    }

    private void SetScriptPathEnvironmentVariable()
    {
        // Don't set the env variable if it's already been set, i.e.: the root path has been filled.
        if (!string.IsNullOrWhiteSpace(_scriptRootPath))
        {
            return;
        }

        // Don't set the env variable if there is no app setting.
        if (string.IsNullOrWhiteSpace(scriptSettingsOptions.Value.Path))
        {
            return;
        }

        var absoluteScriptPath = Path.GetFullPath(scriptSettingsOptions.Value.Path);
        Environment.SetEnvironmentVariable("SCRIPTS_PATH", absoluteScriptPath);
    }
}
