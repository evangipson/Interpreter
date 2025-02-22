local table_insert = table.insert

-- Gets a key and value from a string, separated by an equals sign
local function get_kv_from_string(kv_string)
    -- fill up match table
    local key_and_value = {}
    for kv in kv_string:gmatch("([^=]+)") do
        table_insert(key_and_value, kv)
    end

    -- set key and value to 1st and 2nd entry in match table
    local k = key_and_value[1]
    local v = key_and_value[2]

    -- give back trimmed key and value
    return k:gsub("%s+", ""), v
end

return get_kv_from_string