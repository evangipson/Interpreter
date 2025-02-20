local create_product = require('products.create_product')

local function get_schema()
    return create_product():schema()
end

return get_schema
