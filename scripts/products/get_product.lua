local product_list = require('products.product_list')

local function get_product(product_name)
	for _, v in pairs(product_list) do
		if v.name == product_name then
			return v:tojson()
		end
	end

	return "No product with name '" .. product_name .. "' found"
end

return get_product