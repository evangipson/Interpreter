local os_getenv = os.getenv
local JsonObject = require('base.json_object')

local app_settings_metatable = {
    name = "",
    version = "",
    languages = {},
    environment = "",
    path = "",
    -- Should be a require() to either memory or distributed cache
    cache = "",
    prop_count = JsonObject.prop_count,
    get_prop = JsonObject.get_prop,
    schema = JsonObject.schema,
    tojson = JsonObject.tojson,
}

local app_settings = setmetatable({
    name = "Interpreter",
    version = "0.1.0",
    languages = { "C#", "lua" },
    environment = os_getenv("ASPNETCORE_ENVIRONMENT"),
    -- `Interpreter:ScriptsPath` is an environment variable created in IScriptManager in the backend
    path = os_getenv("Interpreter:ScriptsPath"),
    cache = require('cache.hybrid_cache'),
}, {
    __index = app_settings_metatable
})

return app_settings
