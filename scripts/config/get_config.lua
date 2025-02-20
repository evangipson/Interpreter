local app_settings = require('app_settings')
local print_array = require('utils.print_array')

local function get_config(config_key)
    if config_key == nil then
        return app_settings:tojson()
    end

    local config_value = app_settings[config_key]
    if type(config_value) == "table" then
        return print_array(config_value)
    elseif config_value then
        return config_value
    end
    return "Cannot get config, no '" .. config_key .. "' config exists."
end

return get_config
