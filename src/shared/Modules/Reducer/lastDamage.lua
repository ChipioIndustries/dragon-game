local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)

local function lastDamageReducer(state, action)
	state = state or 0
	if action.type == Actions.setLastDamage then
		return action.timestamp
	end
	return state
end

return lastDamageReducer