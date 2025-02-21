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
    prop_count = JsonObject.prop_count,
    get_prop = JsonObject.get_prop,
    schema = JsonObject.schema,
    tojson = JsonObject.tojson,
}

return Product
