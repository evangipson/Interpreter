local product_list = require('products.product_list')
local JsonResponse = require('base.json_response')

-- Gets a product by name if `product_name` is provided, otherwise returns all products.
-- If there is no `product_list`, or no product with `product_name` found, will return an error response.
local function get_product(product_name)
    if product_list == nil then
        return JsonResponse:error("No product_list defined.")
    end

	if product_name == nil then
		return JsonResponse:ok(product_list:tojson())
	end

	for _, v in pairs(product_list:items()) do
		if v.name == product_name then
			return JsonResponse:ok(v:tojson())
		end
	end

	return JsonResponse:error("No product with name '" .. product_name .. "' found")
end

return get_product
