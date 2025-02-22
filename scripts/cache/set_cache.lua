local Cache = require('cache.cache')
local JsonResponse = require('base.json_response')

local function set_cache(key, val)
    if Cache:set(key, val) == true then
        return JsonResponse:ok('"\'' .. key .. '\' successfully set in cache."')
    end
    return JsonResponse:error(key .. ' not set in cache.')
end

return set_cache