local JsonObject = require('base.json_object')
local table_insert = table.insert

-- A base JSON list, which can have items added, can output json, and get a list of all of it's items
local JsonList = {
    -- Adds an item to the items list
    add = function(self, item)
        if type(item) ~= "function" and type(item) ~= "thread" and type(item) ~= "userdata" then
            table_insert(self, item)
        end
    end,
    -- Gets a JSON representation of everything in the items list
    tojson = function(self)
        local output = "["
        local count = 0
        local prop_count = JsonObject.prop_count(self)
        for _, v in ipairs(self) do
            if type(v) ~= "function" and type(v) ~= "thread" and type(v) ~= "userdata" then
                output = output .. JsonObject.tojson(v)
                count = count + 1
                if count < prop_count then
                    output = output .. ","
                end
            end
        end
        return output .. "]"
    end,
    -- Gets a list of all items
    items = function(self)
        local items = {}
        for _, v in pairs(self) do
            if type(v) ~= "function" and type(v) ~= "thread" and type(v) ~= "userdata" then
                table_insert(items, v)
            end
        end
        return items
    end,
}

return JsonList