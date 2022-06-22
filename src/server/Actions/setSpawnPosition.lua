local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)
local Responses = require(constants.Responses)

local function setSpawnPosition(position)
	assert(typeof(position) == "CFrame", Responses.Actions.InvalidSpawnPosition:format(typeof(position)))
	return {
		type = Actions.setSpawnPosition;
		position = position;
	}
end

return setSpawnPosition