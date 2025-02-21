local create_product = require('products.create_product')
local JsonList = require('base.json_list')

-- A JsonList of all products
local product_list = JsonList

-- Add dummy list of products to the product list
product_list:add(create_product("ticket", 11.99, 1.00))
product_list:add(create_product("child_ticket", 5.99))
product_list:add(create_product("old_ticket", 14.99))
product_list:add(create_product("hamburger", 7.99))

return product_list
