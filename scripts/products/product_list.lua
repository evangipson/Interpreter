local create_product = require('products.product')

local ticket = create_product("ticket", 11.99, 1.00)
local child_ticket = create_product("child_ticket", 5.99)
local old_ticket = create_product("old_ticket", 14.99)
local hamburger = create_product("hamburger", 7.99)

old_ticket.active = false

return { ticket, child_ticket, old_ticket, hamburger }