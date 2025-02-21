local Product = require('products.product')
local JsonResponse = require('base.json_response')

local function schema()
    return JsonResponse:ok(Product:schema())
end

return schema
