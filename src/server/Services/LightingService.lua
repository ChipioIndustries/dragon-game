local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local LightingService = {}
LightingService.__index = LightingService

function LightingService.new()
	local self = setmetatable({
		_overwriteCache = {};
	}, LightingService)

	return self
end

function LightingService:init()
	self:_write(StoreService:getState().liveOpsData.Lighting.Default)
end

function LightingService:_recoverOverwriteCache()
	self:_write(self._overwriteCache)
	self._overwriteCache = {}
end

function LightingService:_write(description)
	for key, value in pairs(description) do
		if typeof(value) == "table" then
			value = Color3.fromRGB(value.R, value.G, value.B)
		end
		Lighting[key] = value
	end
end

function LightingService:_cacheOverwrite(description)
	for key, _value in pairs(description) do
		self._overwriteCache[key] = Lighting[key]
	end
end

function LightingService:loadDescription(description)
	self:_recoverOverwriteCache()
	self:_cacheOverwrite(description)
	self:_write(description)
end

return LightingService.new()