using Lua;

namespace Interpreter.Logic.Services
{
    public interface IScriptService
    {
        Task<TResult?> GetResult<TResult>(string scriptPath, string functionName, IEnumerable<LuaValue> arguments);
    }
}
