local app_settings = require('..\\..\\scripts\\app_settings')

local function get_version()
    if app_settings.version == nil then
        return "Could not find version information."
    end
    return app_settings.version
end

return get_version