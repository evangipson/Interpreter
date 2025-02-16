using Lua;

using Interpreter.Logic.Services;

namespace Interpreter.Logic.Managers
{
    public class ScriptManager(ISettingsService settingsService, IScriptService scriptService) : IScriptManager
    {
        private string ScriptPath => settingsService.ScriptRootPath;

        public Task<TResult?> GetResult<TResult>(string scriptRelativePath, string functionName, IEnumerable<LuaValue> arguments)
        {
            var scriptPath = Path.Combine(ScriptPath, scriptRelativePath);
            return scriptService.GetResult<TResult>(scriptPath, functionName, arguments);
        }
    }
}
