local is_array = require('utils.is_array')
local print_array = require('utils.print_array')

-- Gets a key/value as a string, to write to a file or table
local function get_kv_as_string(key, value)
    local value_to_write = key .. '='
    local t = type(value)
    if t == 'nil' then
        value_to_write = value_to_write .. 'nil'
    elseif t == 'number' then
        value_to_write = value_to_write .. value
    elseif t == 'boolean' then
        value_to_write = value_to_write .. (value and "true" or "false")
    elseif t == 'string' then
        value_to_write = value_to_write .. '"' .. value .. '"'
    elseif is_array(value) then
        value_to_write = value_to_write .. print_array(value, true)
    elseif t == 'table' then
        local i, v = next(value, nil)
        value_to_write = value_to_write .. '"{'
        while i do
            value_to_write = value_to_write .. get_kv_as_string(i, v)
            i, v = next(value, i)
            if i then
                value_to_write = value_to_write .. ','
            end
        end
        value_to_write = value_to_write .. '}"'
    end

    return value_to_write
end

return get_kv_as_string