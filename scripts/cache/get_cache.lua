local Cache = require('config.app_settings').cache
local JsonResponse = require('base.json_response')
local JsonObject = require('base.json_object')
local is_array = require('utils.is_array')
local print_array = require('utils.print_array')

local function get_cache(cache_key)
    local cache_value = Cache:get(cache_key)
    if cache_value == nil then
        return JsonResponse:error('Failed to get \'' .. cache_key .. '\' out of cache.')
    end

    if is_array(cache_value) then
        return JsonResponse:ok(print_array(cache_value))
    elseif type(cache_value) == "table" then
        cache_value = setmetatable(cache_value, {__index = JsonObject})
        return JsonResponse:ok(cache_value:tojson())
    end
    return JsonResponse:ok(cache_value)
end

return get_cache