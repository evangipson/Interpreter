local os_getenv = os.getenv

local app_settings = {
    name = "Interpreter",
    version = "0.1.0",
    languages = { "C#", "lua" },
    environment = os_getenv("ASPNETCORE_ENVIRONMENT"),
    path = os_getenv("SCRIPTS_PATH") -- SCRIPTS_PATH env variable is set in the SettingsService
}

return app_settings