using Lua;

namespace Interpreter.Logic.Services;

/// <summary>
/// A service responsible for loading and running scripts, and providing the script results.
/// </summary>
public interface IScriptService
{
    /// <summary>
    /// Tries to get a result from a function in the script defined by <paramref name="scriptPath"/>, and puts the
    /// <typeparamref name="TResult"/> output into <paramref name="result"/>.
    /// </summary>
    /// <typeparam name="TResult">
    /// The type of <paramref name="result"/> to get back.
    /// </typeparam>
    /// <param name="scriptPath">
    /// The location of the script, whose root can be modified in the application settings.
    /// </param>
    /// <param name="result">
    /// An <see langword="out"/> parameter, which contains the result of the function defined in the script.
    /// </param>
    /// <returns>
    /// <see langword="true"/> if the script was ran successfully, <see langword="false"/> otherwise.
    /// </returns>
    bool TryGetResult<TResult>(string scriptPath, out TResult? result);

    /// <summary>
    /// Tries to get a result from a function, in the script defined, which is provided by <paramref name="scriptPath"/>
    /// and given <paramref name="arguments"/>, and puts the <typeparamref name="TResult"/> output into <paramref name="result"/>.
    /// </summary>
    /// <typeparam name="TResult">
    /// The type of <paramref name="result"/> to get back.
    /// </typeparam>
    /// <param name="scriptPath">
    /// The location of the script, whose root can be modified in the application settings.
    /// </param>
    /// <param name="arguments">
    /// A collection of values that will be used as arguments to the script.
    /// </param>
    /// <param name="result">
    /// An <see langword="out"/> parameter, which contains the result of the function defined in the script.
    /// </param>
    /// <returns>
    /// <see langword="true"/> if the script was ran successfully, <see langword="false"/> otherwise.
    /// </returns>
    bool TryGetResult<TResult>(string scriptPath, IEnumerable<LuaValue> arguments, out TResult? result);

    /// <summary>
    /// Tries to get a result from a function in the script defined by <paramref name="scriptPath"/>.
    /// <para>
    /// Will also provide the collection of <paramref name="arguments"/> to the script, if they are provided.
    /// </para>
    /// </summary>
    /// <typeparam name="TResult">
    /// The type of <paramref name="result"/> to get back.
    /// </typeparam>
    /// <param name="scriptPath">
    /// The location of the script, whose root can be modified in the application settings.
    /// </param>
    /// <param name="arguments">
    /// An optional collection of values that will be used as arguments to the script, defaults to <see langword="null"/>.
    /// </param>
    /// <returns>
    /// An awaitable <see cref="Task"/> which contains the <typeparamref name="TResult"/> result if the script was run successfully, <see langword="default"/> otherwise.
    /// </returns>
    Task<TResult?> GetResultAsync<TResult>(string scriptPath, IEnumerable<LuaValue>? arguments = null);

    /// <summary>
    /// Runs the provided lua <paramref name="script"/>, and returns the results.
    /// </summary>
    /// <param name="script">
    /// The lua script to run.
    /// </param>
    /// <returns>
    /// The results of the <paramref name="script"/>, as a <see cref="ValueTask"/> with a collection of <see cref="LuaValue"/>.
    /// </returns>
    ValueTask<LuaValue[]> RunAsync(string script);

    /// <summary>
    /// Adds a value to the lua environment's globals, to be accessed from lua.
    /// </summary>
    /// <param name="name">
    /// The name of the lua entity to add to globals.
    /// </param>
    /// <param name="value">
    /// The value of the lua entity to add to globals.
    /// </param>
    void AddToGlobals(string name, LuaValue value);
}
