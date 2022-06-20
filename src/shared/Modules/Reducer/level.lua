local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)
local Responses = require(constants.Responses)

local getLevelNameByIndex = require(ReplicatedStorage.Utilities.Selectors.getLevelNameByIndex)

local function levelReducer(state, action)
	state = state or 1
	if action.type == Actions.setLevel then
		return action.level
	elseif action.type == Actions.incrementLevel then
		assert(getLevelNameByIndex(state + 1), Responses.Actions.InvalidLevelIndex)
		return state + 1
	end
	return state
end

return levelReducer