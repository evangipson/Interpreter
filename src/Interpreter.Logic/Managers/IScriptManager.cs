using Lua;

using Interpreter.Logic.Services;

namespace Interpreter.Logic.Managers;

/// <summary>
/// A manager that is responsible for loading and running scripts that are located in a directory defined in the application settings.
/// </summary>
public interface IScriptManager
{
    /// <inheritdoc cref="IScriptService.TryGetResult"/>
    bool TryGetResult<TResult>(string scriptRelativePath, out TResult? result);

    /// <inheritdoc cref="IScriptService.TryGetResult"/>
    bool TryGetResult<TResult>(string scriptRelativePath, IEnumerable<LuaValue> arguments, out TResult? result);

    /// <inheritdoc cref="IScriptService.GetResultAsync"/>
    Task<TResult?> GetResultAsync<TResult>(string scriptRelativePath, IEnumerable<LuaValue>? arguments = null);
}
