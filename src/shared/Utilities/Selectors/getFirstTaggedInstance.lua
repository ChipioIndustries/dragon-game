local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Responses = require(constants.Responses)

local selectors = ReplicatedStorage.Utilities.Selectors
local getTaggedInstancesInDirectory = require(selectors.getTaggedInstancesInDirectory)

local function requireFirstTaggedInstance(instance, tag)
	local result = getTaggedInstancesInDirectory(instance, tag)[1]
	assert(result, Responses.NoTaggedInstance:format(tag, tostring(instance)))
	return result
end

return requireFirstTaggedInstance