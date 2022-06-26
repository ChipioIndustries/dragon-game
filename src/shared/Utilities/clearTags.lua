local CollectionService = game:GetService("CollectionService")

local function clearTags(instance)
	local tags = CollectionService:GetTags(instance)
	for _, tag in ipairs(tags) do
		CollectionService:RemoveTag(instance, tag)
	end
	for _, child in ipairs(instance:GetChildren()) do
		clearTags(child)
	end
end

return clearTags