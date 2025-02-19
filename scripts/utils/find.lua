local function find(someTable, someValue, someKey)
	for _, value in pairs(someTable) do
		if value[someKey] == someValue then
			return value
		end
	end

	return nil
end

return find