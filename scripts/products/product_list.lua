local product = {
	name = "",
	price = 0,
	active = false,
	sale = 0,
	create = function(self, name, price, active, sale)
		self.name = name or ""
		self.price = price or 0
		self.active = active or false
		self.sale = sale or 0
		return self
	end
}

return {
	product:create("ticket", 11.99, true, 1.00),
	product:create("child_ticket", 5.99, true),
	product:create("old_ticket", 14.99),
	product:create("hamburger", 7.99, true)
}