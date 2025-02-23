local table_insert = table.insert
local get_kv_from_string = require('utils.get_kv_from_string')
local string_to_table = require('utils.string_to_table')

-- A base implementation of in-memory storage by writing and reading a table
local InMemoryCache = {
    -- A reference to the object which holds the cache
    cache_table = nil,
    -- Sets the `name` and `value` in the cache
    set = function(self, name, value)
        if self.cache_table == nil then
            self.cache_table = {}
        end

        -- This will already update if it exists
        local t = type(value)
        if t == 'nil' then
            self.cache_table[name] = nil
        elseif tonumber(value) then
            self.cache_table[name] = tonumber(value)
        elseif t == 'string' then
            self.cache_table[name] = '"' .. value .. '"'
        elseif t == 'table' then
            self.cache_table[name] = value
        end
        return true
    end,
    -- Gets the value from the `cache_key` if it exists in cache, otherwise returns `nil`
    get = function(self, cache_key)
        if cache_key == nil then
            return nil
        end

        if self.cache_table == nil then
            return nil
        end

        local cached_value = self.cache_table[cache_key]
        if cached_value == nil then
            return nil
        end

        -- extract the value with quotes if the cached value was a string
        local value = cached_value
        if type(cached_value) == 'string' then
            value = cached_value:sub(1, -1)
        end

        -- Handle tables represented as strings
        if type(value) == 'string' and value:sub(2, 2) == '{' and value:sub(-2, -2) == '}' then
            local table_values = {}

            -- extract values from inside the '{' and '}', and trim leading and trailing whitespace
            local table_string = value:sub(3, -3):gsub('^%s*(.-)%s*$', '%1')

            -- handle complex key/value pairs, i.e.: table/array values
            for tv in table_string:gmatch("(([^=,]+)%s*=%s*{[^}]+})") do
                -- add key/value to return table
                local k, v = get_kv_from_string(tv)
                table_values[k] = string_to_table(v)
                -- remove the match from the found line
                table_string = table_string:gsub(tv, "")
            end

            -- handle simple key/value pairs, numbers, nil, and strings
            for kv in table_string:gmatch("([^,]+)") do
                -- if there was a named index...
                if kv:find("=") then
                    -- add key/value to return table
                    local k, v = get_kv_from_string(kv)
                    -- either store as a number or quote-sanitized & trimmed string
                    table_values[k] = tonumber(v) or v:gsub("\"", ""):gsub('^%s*(.-)%s*$', '%1')
                -- otherwise, add it as an array value
                else
                    table_insert(table_values, (tonumber(kv) or kv:gsub("\"", ""):gsub('^%s*(.-)%s*$', '%1')))
                end
            end

            return table_values
        elseif type(value) == 'table' then
            return value
        elseif value == "nil" then
            return nil
        elseif tonumber(value) then
            return tonumber(value)
        end

        return value
    end,
    -- Removes a value from cache with the associated `cache_key`
    remove = function(self, cache_key)
        -- Look for the value in cache
        local cached_value = self:get(cache_key)
        -- If it didn't exist, it can't be removed
        if cached_value == nil then
            return false
        end

        -- Remove the value from cache
        self.cache_table[cache_key] = nil
        return true
    end,
}

return InMemoryCache