local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)

local function decrementCoins(coinsToSubtract)
	return {
		type = Actions.decrementCoins;
		coinsToSubtract = coinsToSubtract;
	}
end

return decrementCoins