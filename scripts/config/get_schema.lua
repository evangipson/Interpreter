local app_settings = require('app_settings')

local function get_schema()
    return app_settings:schema()
end

return get_schema
