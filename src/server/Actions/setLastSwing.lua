local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)

local function setLastSwing(timestamp)
	return {
		type = Actions.setLastSwing;
		timestamp = timestamp;
	}
end

return setLastSwing