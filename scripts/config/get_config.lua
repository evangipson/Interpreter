local app_settings = require('app_settings')

local function get_config(config_key)
    if config_key == nil then
        return app_settings:tojson()
    end
    return app_settings:get_prop(config_key)
end

return get_config
