local create_account = require('accounts.create_account')

local function get_schema()
    return create_account():schema()
end

return get_schema
