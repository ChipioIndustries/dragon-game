local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)

local function setLastDamage(timestamp)
	return {
		type = Actions.setLastDamage;
		timestamp = timestamp;
	}
end

return setLastDamage