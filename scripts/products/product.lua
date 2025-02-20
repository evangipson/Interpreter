-- A product's fields
local product_fields = {
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

-- Creates a product and assigns the metatable
local function create_product(name, price, sale, active)
    -- Create the new product
    local new_product = {
        name = (name and name or ""),
        price = (price and price or 0),
        sale = (sale and sale or 0),
        active = (active and active or true)
    }

    -- Set information about that product
    local metatable = {
        -- Set the fields it can index with []
        __index = product_fields,
        -- Set what happens when tostring() is called
        __tostring = product_fields.__tostring,
        -- Set what happens when tojson() is called
        tojson = product_fields.tojson
    }

    -- Assign the metatable to the new_product
    setmetatable(new_product, metatable)

    -- Give back the new product, which can now use [] indexing and tostring()
    return new_product
end

return create_product