local app_settings = require('config.app_settings')
local JsonResponse = require('base.json_response')

-- Gets a config from `app_settings` by name if `config_key` is provided, otherwise returns all of `app_settings`.
-- If no `app_settings` exists, or no config with `config_key` exists, will return an error response.
local function config(config_key)
    if app_settings == nil then
        return JsonResponse:error("No app_settings defined.")
    end

    if config_key == nil then
        return JsonResponse:ok(app_settings:tojson())
    end

    local config_prop = app_settings:get_prop(config_key)
    if config_prop == nil then
        return JsonResponse:error('Could not find "' .. config_key .. '" property in application settings.')
    end
    return JsonResponse:ok('"' .. config_prop .. '"')
end

return config
