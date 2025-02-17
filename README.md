# Interpreter
A .NET 9 web api that attempts to defer as much business logic as possible to lua scripts.

The purpose is to mitigate the need to rebuild or redeploy the .NET application in order to see changes in the output or logic of the appplication, and allow for higher speed of development.

## Architecture
### Backend
Inside the `src` directory, there are three projects in the .NET 9 backend:
- `Interpreter.Domain`: Data models with no dependencies
- `Interpreter.Logic`: Application logic, mostly to load and run lua scripts
- `Interpreter.API`: Exposes the API and houses the application settings and bootstrap logic

### Scripts
Inside the `scripts` directory, there are many directories and lua files which are invoked by the backend.

**Important: Make sure each lua script returns exactly one `function`, which will be invoked through the backend (either via API or an injected `IServiceManager`).**

## Requirements
- Visual Studio (at least version 17 to support .NET 9)

## Installation
- Download the repo
- Run `dotnet restore`
- Run `dotnet build`
- Run `dotnet run`
- Hit `/scalar/v1` to see Scalar OpenAPI docs

## Development
- The `scripts` directory location can be customized from the application settings
- Change any lua script in the `scripts` directory to change application logic in realtime
- Create any new directories and lua scripts in the `scripts` directory to extend application logic
    - Create a new controller endpoint in `src\Interpreter.API\Controllers\ScriptsController.cs` to see the new behavior, or use the existing `/scripts/run`/`/scripts/run-async` endpoints to invoke the new script