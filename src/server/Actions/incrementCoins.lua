local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)

local function incrementCoins(coinsToAdd)
	return {
		type = Actions.incrementCoins;
		coinsToAdd = coinsToAdd;
	}
end

return incrementCoins