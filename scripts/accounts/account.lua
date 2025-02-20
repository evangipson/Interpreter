-- An account
local Account = {
	-- The name of the account owner
	owner_name = "",
	-- The active status of the account
	active = false,
	-- The account number
	number = 0,
    -- The account balance
    balance = 0,
	-- Creates a new account
	create = function(self, owner_name, balance, number)
		self.owner_name = owner_name
        self.balance = balance
		self.number = number
        self.active = true
        return self
	end,
    -- Deposits an amount into the account
    deposit = function(self, amount)
        self.balance = self.balance + amount
    end,
}

return Account