using Microsoft.Extensions.Options;

using Interpreter.Domain.Options;

namespace Interpreter.Logic.Services
{
    public class SettingsService(IOptions<ScriptSettings> scriptSettingsOptions) : ISettingsService
    {
        public string ScriptRootPath => scriptSettingsOptions.Value.Path
            ?? throw new ArgumentNullException($"{nameof(SettingsService)}: Unable to find scripts root path, ensure ScriptSettings.Path is set in application settings.");
    }
}
