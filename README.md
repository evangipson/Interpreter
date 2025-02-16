# Interpreter
A .NET 9 web api that attempts to defer as much business logic as possible to lua scripts.

The purpose is to mitigate the need to rebuild or redeploy the .NET application in order to see changes in the output or logic of the appplication, and allow for higher speed of development.

## Installation
- Download the repo
- Run `dotnet restore`
- Run `dotnet build`
- Run `dotnet run`

## Development
- Hit `/scalar/v1` to see Scalar OpenAPI docs
- The `scripts` directory can be customized from the application settings
- Change or create any behaviors in the `scripts` directory
    - When creating a new behavior, create a new controller endpoint in `src\Interpreter.API\Controllers\ScriptsController.cs` to see the new behavior