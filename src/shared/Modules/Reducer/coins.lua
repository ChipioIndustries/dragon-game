local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)

local function coinsReducer(state, action)
	state = state or 0
	if action.type == Actions.incrementCoins then
		return state + action.coinsToAdd
	elseif action.type == Actions.decrementCoins then
		return state + action.coinsToSubtract
	end
	return state
end

return coinsReducer