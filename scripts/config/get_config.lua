local app_settings = require('app_settings')

local function get_config(config_key)
    if config_key == nil then
        return "Cannot get config, no config provided."
    end

    local config_value = app_settings[config_key]
    if config_value and type(config_value) == "table" then
        local array_output = '['
        for i, v in ipairs(config_value) do
            array_output = array_output .. '"' .. v .. '"'
            if i < #config_value then
                array_output = array_output .. ','
            end
        end
        return array_output .. ']'
    elseif config_value then
        return config_value
    end
    return "Cannot get config, no '" .. config_key .. "' config exists."
end

return get_config
