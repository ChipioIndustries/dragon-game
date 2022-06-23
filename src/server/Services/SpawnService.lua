local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerService = require(ReplicatedStorage.Services.PlayerService)
local LevelService = require(ServerScriptService.Services.LevelService)

local SpawnService = {}
SpawnService.__index = SpawnService

function SpawnService.new()
	local self = setmetatable({
		_playerAddedConnection = nil;
	}, SpawnService)

	return self
end

function SpawnService:init()
	self._playerAddedConnection = PlayerService.playerAdded:connect(function(player)
		player.CharacterAdded:Connect(function(character)
			self:moveCharacterToSpawn(character)
		end)
	end)
end

function SpawnService:moveCharacterToSpawn(character)
	local spawnPosition = LevelService:getSpawnPosition()
	while -- wait for character to finish loading in
		not character:FindFirstChild("HumanoidRootPart")
		or not character:IsDescendantOf(workspace)
	do
		task.wait()
	end
	character.HumanoidRootPart.CFrame = spawnPosition
end

return SpawnService.new()