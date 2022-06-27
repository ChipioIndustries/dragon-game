local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local utilities = ReplicatedStorage.Utilities
local getLevelNameByIndex = require(utilities.Selectors.getLevelNameByIndex)

local function getCurrentLevelName()
	return getLevelNameByIndex(StoreService:getState().level)
end

return getCurrentLevelName