# Interpreter
A .NET 9 web api that attempts to defer as much business logic as possible to lua scripts.

The purpose is to mitigate the need to rebuild or redeploy the .NET application in order to see changes in the output or logic of the appplication, and allow for higher speed of development.

## Installation
- Download the repo
- Run `dotnet restore`
- Run `dotnet build`
- Run `dotnet run`

## Development
- Change or create any behaviors in the `scripts` directory
- Create a new controller endpoint in the `src\Interpreter.API\Controllers\ScriptsController.cs` file to call that script
- Note: To change the `scripts` location, update the application settings