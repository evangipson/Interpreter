local product_list = require('products.product_list')

local function get_all_products()
	local output = '['
	for i, v in pairs(product_list) do
		output = output .. v:tojson()
		if i < #product_list then
			output = output .. ','
		end
	end
	return output .. ']'
end

return get_all_products