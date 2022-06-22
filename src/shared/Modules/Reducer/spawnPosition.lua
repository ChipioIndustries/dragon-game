local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)
local CONFIG = require(constants.CONFIG)

local function spawnPositionReducer(state, action)
	state = state or CONFIG.DefaultSpawnPosition
	if action.type == Actions.setSpawnPosition then
		return action
	end
	return state
end

return spawnPositionReducer