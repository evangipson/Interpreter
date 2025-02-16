using Lua;

namespace Interpreter.Logic.Managers
{
    public interface IScriptManager
    {
        Task<TResult?> GetResult<TResult>(string scriptRelativePath, string functionName, IEnumerable<LuaValue> arguments);
    }
}
