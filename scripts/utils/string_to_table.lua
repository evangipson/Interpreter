local table_insert = table.insert

-- Converts a string to a table
local function string_to_table(table_string)
    local table = {}
    -- Sanitize table by removing braces
    table_string = table_string:gsub("{", ""):gsub("}", "")

    -- For every value separated by commas, add to the return table
    for value in table_string:gmatch("([^,]+)") do
        table_insert(table, value)
    end
    return table
end

return string_to_table