local is_array = require('utils.is_array')

-- Returns a string representation of an array, or table if `as_table` is `true`
local function print_array(table, as_table)
    local print_as_table = as_table or false
    local start_char = print_as_table and '{' or '['
    local end_char = print_as_table and '}' or ']'
    local array_output = start_char
    for i, v in ipairs(table) do
        if is_array(v) then
            array_output = array_output .. print_array(v)
        elseif type(v) == "table" then
            array_output = array_output .. v:tojson()
        elseif tonumber(v) then
            array_output = array_output .. v
        elseif v == true or v == false then
            array_output = array_output .. (v and "true" or "false")
        else
            array_output = array_output .. '"' .. v .. '"'
        end
        if i < #table then
            array_output = array_output .. ','
        end
    end
    return array_output .. end_char
end

return print_array
