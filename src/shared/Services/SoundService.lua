local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local packages = ReplicatedStorage.Packages
local Llama = require(packages.Llama)

local SoundService = {}
SoundService.__index = SoundService

function SoundService.new()
	local self = setmetatable({
		_cachedSounds = {};
	}, SoundService)

	return self
end

function SoundService:init()
	self:_cacheList(StoreService:getState().liveOpsData.Sounds)
	self:_clientPreloadAsync()
end

function SoundService:_clientPreloadAsync()
	if RunService:IsClient() then
		ContentProvider:PreloadAsync(Llama.Dictionary.values(self._cachedSounds))
	end
end

function SoundService:_cacheList(list)
	for key, value in pairs(list) do
		if typeof(value) == "number" then
			local newSound = Instance.new("Sound")
			newSound.SoundId = "rbxassetid://" .. tostring(value)
			newSound.Name = key
			self._cachedSounds[value] = newSound
		elseif typeof(value) == "table" then
			self:_cacheList(value)
		end
	end
end

function SoundService:play(soundId, origin)
	local cloneSound = self._cachedSounds[soundId]:Clone()
	cloneSound.Parent = origin or script
	cloneSound:Play()
	cloneSound.Ended:Connect(function()
		cloneSound:Destroy()
	end)
	return cloneSound
end

return SoundService.new()