local os_getenv = os.getenv

local app_settings = {
    name = "Interpreter",
    version = "0.1.0",
    languages = { "C#", "lua" },
    environment = os_getenv("ASPNETCORE_ENVIRONMENT"),
    -- `Interpreter:ScriptsPath` is an environment variable created in IScriptManager in the backend
    path = os_getenv("Interpreter:ScriptsPath")
}

return app_settings