-- Returns `true` if `a1` and `a2` have equality for every value, `false` otherwise.
local function are_arrays_equal(a1, a2)
    local set = {}
    for _, v in ipairs(a1) do
        set[tostring(v)] = true
    end

    for _, v in ipairs(a2) do
        if set[tostring(v)] ~= true then
            return false
        end
    end

    return true
end

return are_arrays_equal