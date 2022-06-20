local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Actions = require(constants.Actions)
local Responses = require(constants.Responses)

local function setLiveOpsData(liveOpsData)
	assert(typeof(liveOpsData) == "table", Responses.Actions.InvalidLiveOpsType:format(typeof(liveOpsData)))
	return {
		type = Actions.setLiveOpsData;
		data = liveOpsData;
	}
end

return setLiveOpsData