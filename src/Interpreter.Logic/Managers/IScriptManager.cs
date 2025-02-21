namespace Interpreter.Logic.Managers;

/// <summary>
/// A manager that is responsible for loading and running scripts that are located in a directory defined in the application settings.
/// </summary>
public interface IScriptManager
{
    /// <summary>
    /// Runs the script that lives at <paramref name="scriptRelativePath"/>, and passes along the
    /// <paramref name="arguments"/> that are provided, then captures and returns the result as
    /// a <see langword="dynamic"/> type.
    /// </summary>
    /// <param name="scriptRelativePath">
    /// The path to the script to run, relative to the "ScriptSettings:Path" application setting.
    /// </param>
    /// <param name="arguments">
    /// An optional collection of <see langword="string"/> arguments to provide the script.
    /// </param>
    /// <returns>
    /// A <see langword="dynamic"/> script result, defaults to <see langword="null"/>.
    /// </returns>
    dynamic? Run(string scriptRelativePath, IEnumerable<string>? arguments = null);

    /// <summary>
    /// Runs the script that lives at <paramref name="scriptRelativePath"/>, and passes along the
    /// <paramref name="arguments"/> that are provided, then captures and returns the
    /// <typeparamref name="TResult"/> result.
    /// </summary>
    /// <typeparam name="TResult">
    /// The type of result from running the script.
    /// </typeparam>
    /// <param name="scriptRelativePath">
    /// The path to the script to run, relative to the "ScriptSettings:Path" application setting.
    /// </param>
    /// <param name="arguments">
    /// An optional collection of <see langword="string"/> arguments to provide the script.
    /// </param>
    /// <returns>
    /// A <typeparamref name="TResult"/> script result, defaults to <see langword="null"/>.
    /// </returns>
    TResult? Run<TResult>(string scriptRelativePath, IEnumerable<string>? arguments = null);

    /// <summary>
    /// Runs the script that lives at <paramref name="scriptRelativePath"/> asynchronously, and
    /// passes along the <paramref name="arguments"/> that are provided, then captures and returns
    /// the result as a <see cref="Task"/> with a <see langword="dynamic"/> type.
    /// </summary>
    /// <param name="scriptRelativePath">
    /// The path to the script to run, relative to the "ScriptSettings:Path" application setting.
    /// </param>
    /// <param name="arguments">
    /// An optional collection of <see langword="string"/> arguments to provide the script.
    /// </param>
    /// <returns>
    /// A <see cref="Task"/> filled with a <see langword="dynamic"/> script result, defaults to <see langword="null"/>.
    /// </returns>
    Task<dynamic?> RunAsync(string scriptRelativePath, IEnumerable<string>? arguments = null);

    /// <summary>
    /// Runs the script that lives at <paramref name="scriptRelativePath"/> asynchronously, and
    /// passes along the <paramref name="arguments"/> that are provided, then captures and returns
    /// the result as a <see cref="Task"/> filled with the <typeparamref name="TResult"/> result.
    /// </summary>
    /// <typeparam name="TResult">
    /// The type of result from running the script.
    /// </typeparam>
    /// <param name="scriptRelativePath">
    /// The path to the script to run, relative to the "ScriptSettings:Path" application setting.
    /// </param>
    /// <param name="arguments">
    /// An optional collection of <see langword="string"/> arguments to provide the script.
    /// </param>
    /// <returns>
    /// A <see cref="Task"/> filled with a <typeparamref name="TResult"/> script result, defaults to <see langword="null"/>.
    /// </returns>
    Task<TResult?> RunAsync<TResult>(string scriptRelativePath, IEnumerable<string>? arguments = null);
}
