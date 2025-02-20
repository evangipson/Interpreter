local create_product = require('products.create_product')

local function get_schema()
    local test_product = create_product()
    return test_product:schema()
end

return get_schema