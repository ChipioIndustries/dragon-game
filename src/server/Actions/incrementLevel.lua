local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)

local function incrementLevel()
	return {
		type = Actions.incrementLevel;
	}
end

return incrementLevel