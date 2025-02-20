local os_getenv = os.getenv
local print_array = require('utils.print_array')

local app_settings_metatable = {
    name = "",
    version = "",
    languages = {},
    environment = "",
    path = "",
    -- Gets the schema of app_settings
    schema = function(self)
        return '{' ..
            '"name":"' .. type(self.name) .. '",' ..
            '"version":"' .. type(self.version) .. '",' ..
            '"languages":"' .. type(self.languages) .. '",' ..
            '"environment":"' .. type(self.environment) .. '",' ..
            '"path":"' .. type(self.path) .. '"' ..
        '}'
    end,
    -- Get the JSON representation of app_settings
    tojson = function(self)
        return '{' ..
            '"name":"' .. self.name .. '",' ..
            '"version":"' .. self.version .. '",' ..
            '"languages":' .. print_array(self.languages) .. ',' ..
            '"environment":"' .. self.environment .. '",' ..
            '"path":"' .. self.path .. '"' ..
        '}'
    end,
}

local app_settings = setmetatable({
    name = "Interpreter",
    version = "0.1.0",
    languages = { "C#", "lua" },
    environment = os_getenv("ASPNETCORE_ENVIRONMENT"),
    -- `Interpreter:ScriptsPath` is an environment variable created in IScriptManager in the backend
    path = os_getenv("Interpreter:ScriptsPath")
}, {
    __index = app_settings_metatable,
    schema = app_settings_metatable.schema
})

return app_settings
