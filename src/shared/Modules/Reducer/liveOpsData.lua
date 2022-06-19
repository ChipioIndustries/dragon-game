local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local Actions = require(ReplicatedStorage.Constants.Actions)

local function liveOpsDataReducer(state, action)
	if action.type == Actions.setLiveOpsData then
		if not Llama.Dictionary.equalsDeep(state or {}, action.data) then
			return action.data
		end
	end
	return state
end

return liveOpsDataReducer