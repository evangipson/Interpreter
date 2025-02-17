namespace Interpreter.Logic.Services;

/// <summary>
/// A service that is responsible for exposing values from the application settings to the rest of the application.
/// </summary>
public interface ISettingsService
{
    /// <summary>
    /// The root path for all of the scripts.
    /// <para>
    /// Will <see langword="throw"/> an <see cref="ArgumentNullException"/> if the value is not defined in the application settings.
    /// </para>
    /// </summary>
    /// <exception cref="ArgumentNullException"></exception>
    string ScriptRootPath { get; }
}
