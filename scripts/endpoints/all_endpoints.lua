local JsonList = require('base.json_list')
local JsonObject = require('base.json_object')
local table_insert = table.insert

local function create_endpoint_list(directory, scripts)
    local script_info = { [directory] = {} }
    for i, v in ipairs(scripts) do
        table_insert(script_info[directory], setmetatable({
            [v] = directory .. "/" .. v .. ".lua"
        }, { __index = JsonObject }))
    end
    return setmetatable(script_info, { __index = JsonObject })
end

local function create_endpoint(endpoint_name)
    return setmetatable({
        [endpoint_name] = endpoint_name .. ".lua"
    }, {__index = JsonObject})
end

local all_endpoints = JsonList

all_endpoints:add(create_endpoint_list("accounts", { "create_account", "schema" }))
all_endpoints:add(create_endpoint_list("cache", { "get_cache", "set_cache" }))
all_endpoints:add(create_endpoint("config"))
all_endpoints:add(create_endpoint("endpoints"))
all_endpoints:add(create_endpoint_list("numbers", { "add" }))
all_endpoints:add(create_endpoint_list("products", { "create_product", "get_product", "schema" }))

return all_endpoints