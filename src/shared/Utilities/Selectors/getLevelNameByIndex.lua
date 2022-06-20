local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CONFIG = require(ReplicatedStorage.Constants.CONFIG)

local function getLevelNameByIndex(levelIndex)
	local success, result = pcall(function()
		return CONFIG.LevelOrder[levelIndex]
	end)
	if success then
		return result
	end
	return nil
end

return getLevelNameByIndex