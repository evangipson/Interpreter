namespace Interpreter.Domain.Options;

/// <summary>
/// A model for script settings, which live in the application settings.
/// </summary>
public record ScriptSettings
{
    /// <summary>
    /// The relative path to a directory which holds all the scripts this application will use.
    /// </summary>
    public string? Path { get; set; }
}
