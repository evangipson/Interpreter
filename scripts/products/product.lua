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
    -- Gets the schema of a product
    schema = function(self)
        return '{' ..
            '"name":"' .. type(self.name) .. '",' ..
            '"active":"' .. type(self.active) .. '",' ..
            '"price":"' .. type(self.price) .. '",' ..
            '"sale":"' .. type(self.sale) .. '"' ..
            '}'
    end,
    -- Get the JSON representation of a product
    tojson = function(self)
        return '{' ..
            '"name":"' .. self.name .. '",' ..
            '"active":' .. (self.active and "true" or "false") .. ',' ..
            '"price":' .. self.price .. ',' ..
            '"sale":' .. self.sale ..
            '}'
    end,
}

return Product
