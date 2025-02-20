local function print_array(table)
    local array_output = '['
    for i, v in ipairs(table) do
        array_output = array_output .. '"' .. v .. '"'
        if i < #table then
            array_output = array_output .. ','
        end
    end
    return array_output .. ']'
end

return print_array
