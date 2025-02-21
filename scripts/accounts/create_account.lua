local Account = require('accounts.account')
local JsonResponse = require('base.json_response')

-- Creates an account and assigns the metatable
local function create_account(owner_name, balance, number, as_json)
    local new_account = setmetatable({
        owner_name = (owner_name and owner_name or ""),
        balance = (tonumber(balance) and tonumber(balance) or 0),
        number = (tonumber(number) and tonumber(number) or 0)
    },{
        __index = Account
    })

    if as_json then
        return JsonResponse:ok(new_account:tojson())
    end

    return new_account
end

return create_account