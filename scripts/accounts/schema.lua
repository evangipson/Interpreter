local Account = require('accounts.account')
local JsonResponse = require('base.json_response')

local function schema()
    return JsonResponse:ok(Account:schema())
end

return schema
