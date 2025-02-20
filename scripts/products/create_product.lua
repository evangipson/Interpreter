local Product = require('products.product')

-- Creates a product and assigns the metatable
local function create_product(name, price, sale, active, as_json)
    local new_product = setmetatable({
        name = (name and name or ""),
        price = (tonumber(price) and tonumber(price) or 0),
        sale = (tonumber(sale) and tonumber(sale) or 0),
        active = (active and active or true)
    },{
        __index = Product
    })

    if as_json then
        return new_product:tojson()
    end

    return new_product
end

return create_product
