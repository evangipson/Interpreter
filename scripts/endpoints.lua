local JsonResponse = require('base.json_response')
local all_endpoints = require('endpoints.all_endpoints')

local function endpoints()
    return JsonResponse:ok(all_endpoints:tojson())
end

return endpoints