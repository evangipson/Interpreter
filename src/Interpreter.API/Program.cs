using Interpreter.API.Extensions;

namespace Interpreter.API;

/// <summary>
/// The main class for the application.
/// </summary>
internal class Program
{
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    /// <param name="args">
    /// An optional collection of arguments to provide the program when it starts.
    /// </param>
    internal static void Main(string[] args) => WebApplication.CreateBuilder(args)
        .ConfigureBuilder()
        .Build()
        .ConfigureApplication()
        .Run();
}
