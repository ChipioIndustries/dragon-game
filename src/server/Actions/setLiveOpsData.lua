local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Actions = require(ReplicatedStorage.Constants.Actions)

local function setLiveOpsData(liveOpsData)
	return {
		type = Actions.setLiveOpsData;
		data = liveOpsData;
	}
end

return setLiveOpsData