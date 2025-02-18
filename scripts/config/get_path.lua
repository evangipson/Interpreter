local string_gsub = string.gsub
local app_settings = require(INCLUDE_PATH() .. '\\app_settings')

local function get_path()
    if app_settings.path == nil then
        return "Could not find path to scripts."
    end

    local formatted_path = string_gsub(app_settings.path, '\\\\', '\\')
    return formatted_path
end

return get_path