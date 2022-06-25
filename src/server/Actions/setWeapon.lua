local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)
local Responses = require(constants.Responses)
local Enums = require(constants.Enums)

local function setWeapon(weapon)
	assert(Enums.Weapon[weapon], Responses.Actions.InvalidWeapon:format(weapon))
	return {
		type = Actions.setWeapon;
		weapon = weapon;
	}
end

return setWeapon