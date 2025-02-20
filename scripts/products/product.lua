local JsonObject = require('base.json_object')

-- The definition for a product
local Product = {
    -- The name of the product
    name = "",
    -- The active status of the product
    active = false,
    -- The price of the product
    price = 0,
    -- The sale amount the product
    sale = 0,
    -- Display a product
    __tostring = function(self)
        local output = '\n'
        output = output .. '\t' .. 'name: ' .. self.name .. '\n'
        output = output .. '\t' .. 'active: ' .. (self.active and "true" or "false") .. '\n'
        output = output .. '\t' .. 'price: ' .. self.price .. '\n'
        output = output .. '\t' .. 'sale: ' .. self.sale .. '\n'
        return tostring(output)
    end,
    prop_count = JsonObject.prop_count,
    get_prop = JsonObject.get_prop,
    schema = JsonObject.schema,
    tojson = JsonObject.tojson,
}

return Product
