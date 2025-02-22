-- Returns `true` if the `table` is an `array`, and `false` otherwise
local function is_array(table)
    if type(table) ~= "table" then
        return false
    end

    local i = 0
    for _ in pairs(table) do
        i = i + 1
        if table[i] == nil then
            return false
        end
    end
    return true
end

return is_array