local os_getenv = os.getenv
local JsonObject = require('base.json_object')
local Cache = require('cache.distributed_cache')

local app_settings = {
    name = "Interpreter",
    version = "0.1.0",
    languages = { "C#", "lua" },
    environment = os_getenv("ASPNETCORE_ENVIRONMENT"),
    -- `Interpreter:ScriptsPath` is an environment variable created in IScriptManager in the backend
    path = os_getenv("Interpreter:ScriptsPath"),
    -- Should be a require() to in-memory, distributed, or hybrid cache
    cache = Cache,
    prop_count = JsonObject.prop_count,
    get_prop = JsonObject.get_prop,
    schema = JsonObject.schema,
    tojson = JsonObject.tojson,
}

return setmetatable(app_settings, { __index = app_settings })