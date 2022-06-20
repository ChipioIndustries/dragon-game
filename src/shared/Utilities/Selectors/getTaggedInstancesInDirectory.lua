local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Responses = require(ReplicatedStorage.Constants.Responses)

local function getTaggedInstancesInDirectory(instance, tag)
	assert(typeof(instance) == "Instance", Responses.Selectors.getTaggedInstancesInDirectory.InvalidInstance:format(typeof(instance)))
	assert(typeof(tag) == "string", Responses.Selectors.getTaggedInstancesInDirectory.InvalidTag:format(typeof(tag)))
	local taggedInstances = CollectionService:GetTagged(tag)
	local result = {}
	for _, taggedInstance in ipairs(taggedInstances) do
		if taggedInstance:IsDescendantOf(instance) then
			table.insert(result, taggedInstance)
		end
	end
	return result
end

return getTaggedInstancesInDirectory