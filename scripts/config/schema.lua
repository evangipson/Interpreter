local app_settings = require('app_settings')

local function schema()
    return app_settings:schema()
end

return schema
