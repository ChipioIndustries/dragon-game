local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)
local Enums = require(constants.Enums)

local function weaponReducer(state, action)
	state = state or Enums.Weapon.GoldenSword
	if action.type == Actions.setWeapon then
		return action.weapon
	end
	return state
end

return weaponReducer