using Microsoft.Extensions.Options;

using Interpreter.Domain.Options;

namespace Interpreter.Logic.Services;

/// <inheritdoc cref="ISettingsService"/>
public class SettingsService(IOptions<ScriptSettings> scriptSettingsOptions) : ISettingsService
{
    private string? _scriptRootPath;
    public string ScriptRootPath => _scriptRootPath ??= scriptSettingsOptions.Value.Path
                ?? throw new ArgumentNullException($"{nameof(SettingsService)}: Unable to find scripts root path, ensure ScriptSettings:Path is set in application settings.");
}
