local app_settings = require('..\\..\\scripts\\app_settings')

local function get_path()
    if app_settings.path == nil then
        return "Could not find path to scripts."
    end
    return app_settings.path
end

return get_path