local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)
local Responses = require(constants.Responses)

local getLevelNameByIndex = require(ReplicatedStorage.Utilities.Selectors.getLevelNameByIndex)

local function setLevel(level)
	assert(getLevelNameByIndex(level), Responses.Actions.InvalidLevelIndex)
	return {
		type = Actions.setLevel;
		data = level;
	}
end

return setLevel