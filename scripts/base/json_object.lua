local print_array = require('utils.print_array')
local JsonResponse = require('base.json_response')

-- A base object that defines a way to get schema and return JSON
local JsonObject = {
    -- Gets the number of properties that will be in schema/tojson
    prop_count = function(self)
        local prop_count = 0
        for _, v in pairs(self) do
            if type(v) == "string" or type(v) == "number" or type(v) == "boolean" or type(v) == "table" then
                prop_count = prop_count + 1
            end
        end
        return prop_count
    end,
    -- Gets a property by name
    get_prop = function(self, prop_name)
        if prop_name == nil then
            return JsonResponse:error("Cannot get property, no property name provided.")
        end

        local prop = self[prop_name]
        if type(prop) == "table" then
            return JsonResponse:ok(print_array(prop))
        elseif prop then
            return JsonResponse:ok(prop)
        end

        return JsonResponse:error("Cannot get property, no '" .. prop_name .. "' property exists.")
    end,
    -- Gets the schema of an object
    schema = function(self)
        local prop_count = 0
        local length = self:prop_count()
        local schema = '{'
        for i, v in pairs(self) do
            if type(v) == "string" or type(v) == "number" or type(v) == "boolean" or type(v) == "table" then
                schema = schema .. '"' .. tostring(i) .. '":"' .. type(v) .. '"'
                prop_count = prop_count + 1
            end
            if prop_count < length then
                schema = schema .. ','
            end
        end
        return schema .. '}'
    end,
    -- Get the JSON representation of an object
    tojson = function(self)
        local prop_count = 0
        local length = self:prop_count()
        local json = '{'
        for i, v in pairs(self) do
            if type(v) == "string" or type(v) == "number" or type(v) == "boolean" or type(v) == "table" then
                prop_count = prop_count + 1
            end

            if type(v) == "string" then
                json = json .. '"' .. tostring(i) .. '":"' .. v .. '"'
            elseif type(v) == "boolean" then
                json = json .. '"' .. tostring(i) .. '":' .. (v and "true" or "false")
            elseif type(v) == "number" then
                json = json .. '"' .. tostring(i) .. '":' .. v
            elseif type(v) == "table" then
                json = json .. '"' .. tostring(i) .. '":' .. print_array(v)
            end

            if prop_count < length then
                json = json .. ','
            end
        end
        return json .. '}'
    end,
}

return JsonObject