local string_find = string.find
local table_insert = table.insert
local io_open = io.open
local get_kv_from_string = require('utils.get_kv_from_string')
local string_to_table = require('utils.string_to_table')

-- A base implementation of persistent storage by writing and reading a file
local DistributedCache = {
    -- A reference to the file which holds the cache
    cache_file = nil,
    -- Closes the cache file if it's open
    close_cache_file = function(self)
        if self.cache_file then
            self.cache_file:close()
        end
        self.cache_file = nil
    end,
    flush_cache = function(self)
        if self.cache_file then
            self.cache_file:flush()
        end
    end,
    -- Gets the cache file, after closing it to make sure it has exclusive access
    get_cache_file = function(self, mode)
        self:close_cache_file()
        self.cache_file = io_open('./cachefile.cache', mode)
        return self.cache_file
    end,
    -- Sets the `name` and `value` in the cache
    set = function(self, name, value)
        -- Update if it already exists
        local cached_value = self:get(name)
        if cached_value then
            local cache_file = self:get_cache_file('r')
            if cache_file == nil then
                self:close_cache_file()
                return false
            end

            -- Find cache_key from the start of the line, using ^ to make sure the key is at the start of the line.
            local search_string = "^" .. name .. "="
            -- Read the whole cache file into memory
            local cache_content = {}
            local line_count = 1
            local target_line = 0
            for line in cache_file:lines() do
                -- Try and find the cache_key from the start of the line
                local start_index, _ = string_find(line, search_string)
                if start_index then
                    target_line = line_count
                end
                table_insert(cache_content, line)
                line_count = line_count + 1
            end
            -- Update the correct line in the cache_content table
            cache_content[target_line] = name .. '="' .. value .. '"'
            -- Re-open the cache file in write mode
            cache_file = self:get_cache_file('w')
            -- Write the whole file back out
            for _, cached_file_value in ipairs(cache_content) do
                cache_file:write(cached_file_value .. '\n')
            end
        -- write it for the first time if it's new
        else
            local cache_file = self:get_cache_file('a')
            if cache_file == nil then
                self:close_cache_file()
                return false
            end

            cache_file:write('\n' .. name .. '=')
            local t = type(value)
            if t == 'nil' then
                cache_file:write('nil')
            elseif t == 'number' then
                cache_file:write(value)
            elseif t == 'string' then
                cache_file:write('"' .. value .. '"')
            elseif t == 'table' then
                local i, v = next(value, nil)
                cache_file:write('{')
                while i do
                    self:set(i, v)
                    cache_file:write(',')
                    i, v = next(value, i)
                end
                cache_file:write('}')
            end
        end

        -- force the buffer to flush to write the contents to disk
        self:flush_cache()

        self:close_cache_file()
        return true
    end,
    -- Gets the value from the `cache_key` if it exists in cache, otherwise returns `nil`
    get = function(self, cache_key)
        if cache_key == nil then
            return nil
        end

        local cache_file = self:get_cache_file('r')
        if cache_file == nil then
            self:close_cache_file()
            return nil
        end

        -- Find cache_key from the start of the line, using ^ to make sure the key is at the start of the line.
        local search_string = "^" .. cache_key .. "="

        for line in cache_file:lines() do
            -- Try and find the cache_key from the start of the line
            local start_index, end_index = string_find(line, search_string)
            if start_index then
                self:close_cache_file()
                -- extract the value with quotes
                local value = line:sub(end_index + 1, -1)

                -- Handle cached tables
                if value:sub(2, 2) == '{' and value:sub(-2, -2) == '}' then
                    local table_values = {}

                    -- extract values from inside the '{' and '}', and trim whitespace
                    local table_string = value:sub(3, -3):gsub("%s+", "")

                    -- handle complex key/value pairs, i.e.: table/array values
                    for tv in table_string:gmatch("(([^=,]+)={[^}]+})") do
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
                            -- either store as a number or quote-sanitized string
                            table_values[k] = tonumber(v) or v:gsub("\"", "")
                        -- otherwise, add it as an array value
                        else
                            table_insert(table_values, (tonumber(kv) or kv:gsub("\"", "")))
                        end
                    end

                    return table_values
                elseif value == "nil" then
                    return nil
                elseif tonumber(value) then
                    return tonumber(value)
                end

                return tostring(value)
            end
        end

        self:close_cache_file()
        return nil
    end
}

return DistributedCache