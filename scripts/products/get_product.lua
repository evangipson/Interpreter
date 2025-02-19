local find = require('utils.find')
local product_list = require('products.product_list')

local function get_product(product_name)
	local output = ""

	for index, data in ipairs(product_list) do
		output = output .. tostring(index) .. '\n'

		for key, value in pairs(data) do
			output = output .. '\t' .. tostring(key) .. ' : ' .. tostring(value) .. '\n'
		end
	end

	return output
	-- local product = find(product_list, product_name, "name")
	-- if product then
	-- 	return product
	-- end

	-- return "No product with name '" .. product_name .. "' found"
end

return get_product