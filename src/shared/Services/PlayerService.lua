local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local packages = ReplicatedStorage.Packages
local Signal = require(packages.Signal)
local Remotes = require(packages.Remotes)

local playerAddedRemote = Remotes:getEventAsync("playerAdded")

local PlayerService = {}
PlayerService.__index = PlayerService

function PlayerService.new()
	local self = setmetatable({
		playerAdded = Signal.new();
		playerRemoving = Signal.new();
		_loaders = {};
		_addedPlayers = {};
	}, PlayerService)

	return self
end

function PlayerService:addPlayerLoader(loader)
	table.insert(self._loaders, loader)
end

function PlayerService:_addPlayer(player)
	for _index, loader in ipairs(self._loaders) do
		loader(player)
	end
	self._addedPlayers[player.UserId] = true
	self.playerAdded:fire(player)
	if RunService:IsServer() then
		playerAddedRemote:FireAllClients(player)
	end
end

function PlayerService:_removePlayer(player)
	if self._addedPlayers[player.UserId] then
		self.playerRemoving:fire(player)
		self._addedPlayers[player.UserId] = nil
	end
end

function PlayerService:getPlayers()
	local players = {}
	for playerId, _value in pairs(self._addedPlayers) do
		local player = Players:GetPlayerByUserId(playerId)
		if player then
			table.insert(players, player)
		end
	end
	return players
end

function PlayerService:init()
	local function standaloneAddPlayer(player)
		self:_addPlayer(player)
	end

	if RunService:IsServer() then
		Players.PlayerAdded:Connect(standaloneAddPlayer)
		for _index, player in ipairs(Players:GetPlayers()) do
			standaloneAddPlayer(player)
		end
	else
		playerAddedRemote.OnClientEvent:Connect(standaloneAddPlayer)
	end

	Players.PlayerRemoving:Connect(function(player)
		self:_removePlayer(player)
	end)
end

if RunService:IsServer() then
	function PlayerService:respawnAllPlayers()
		for _, player in ipairs(self:getPlayers()) do
			player:LoadCharacter()
		end
	end
end

return PlayerService.new()