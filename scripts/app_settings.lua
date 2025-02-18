local os_getenv = os.getenv

local app_settings = {
    name = "Interpreter",
    version = "0.1.0",
    languages = { "C#", "lua" },
    environment = os_getenv("ASPNETCORE_ENVIRONMENT"),
    path = SCRIPTS_PATH()
}

return app_settings