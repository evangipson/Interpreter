local app_settings = require('app_settings')
local JsonResponse = require('base.json_response')

-- Gets a config from `app_settings` by name if `config_key` is provided, otherwise returns all of `app_settings`.
-- If no `app_settings` exists, or no config with `config_key` exists, will return an error response.
local function get_config(config_key)
    if app_settings == nil then
        return JsonResponse:error("No app_settings defined.")
    end

    if config_key == nil then
        return JsonResponse:ok(app_settings:tojson())
    end

    return JsonResponse:ok(app_settings:get_prop(config_key))
end

return get_config
