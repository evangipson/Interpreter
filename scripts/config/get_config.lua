local app_settings = require('app_settings')

local function get_config(config_key)
	if config_key == nil then
		return "Cannot get config, no config provided."
	end

	local config_value = app_settings[config_key]
	if config_value == nil then
		return "Cannot get config, no '" .. config_key .. "' config exists."
	end

	return config_value
end

return get_config