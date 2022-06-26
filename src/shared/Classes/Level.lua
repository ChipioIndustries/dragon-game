local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CONFIG = require(ReplicatedStorage.Constants.CONFIG)

local sharedServices = ReplicatedStorage.Services
local PlayerService = require(sharedServices.PlayerService)

local serverServices = ServerScriptService.Services
local LootDropService = require(serverServices.LootDropService)

local getTaggedInstancesInDirectory = require(ReplicatedStorage.Utilities.Selectors.getTaggedInstancesInDirectory)

local classes = ReplicatedStorage.Classes
local LevelEndTrigger = require(classes.LevelEndTrigger)
local Enemy = require(classes.Enemy)

local Level = {}
Level.__index = Level

function Level.new(levelService, levelTemplate)
	local self = setmetatable({
		_levelService = levelService;
		_levelTemplate = levelTemplate;
		_levelEndTrigger = nil;
		_loadedLevel = nil;
		_enemies = {};
		_completed = false;
	}, Level)

	return self
end

function Level:init()
	-- copy level template into Workspace
	local newLevel = self._levelTemplate:Clone()
	newLevel.Parent = workspace
	self._loadedLevel = newLevel

	-- initialize enemies
	local enemySpawns = getTaggedInstancesInDirectory(self._loadedLevel, CONFIG.Keys.Tags.EnemySpawn)
	for _index, enemySpawn in ipairs(enemySpawns) do
		local enemyName = enemySpawn:GetAttribute(CONFIG.Keys.Attributes.EnemyType)
		local enemyStrength = enemySpawn:GetAttribute(CONFIG.Keys.Attributes.Strength)
		local newEnemy = Enemy.new(enemyName, enemyStrength)
		newEnemy:init(enemySpawn.CFrame)
		table.insert(self._enemies, newEnemy)
	end

	-- initialize level end trigger
	local levelEndInstance = getTaggedInstancesInDirectory(self._loadedLevel, CONFIG.Keys.Tags.LevelEnd)[1]
	local levelEndTrigger = LevelEndTrigger.new(self, levelEndInstance)
	levelEndTrigger:init()
	self._levelEndTrigger = levelEndTrigger

	-- respawn players
	PlayerService:respawnAllPlayers()
end

function Level:_canFinish()
	for _, enemy in ipairs(self._enemies) do
		if not enemy.dead then
			return false
		end
	end
	return true
end

function Level:finish()
	if self:_canFinish() then
		self._levelService:nextLevel()
		return true
	end
	return false
end

function Level:getSpawnPosition()
	local playerSpawnInstance = getTaggedInstancesInDirectory(self._loadedLevel, CONFIG.Keys.Tags.PlayerSpawn)[1]
	return playerSpawnInstance.CFrame
end

function Level:destroy()
	self._loadedLevel:Destroy()
	for _index, enemy in ipairs(self._enemies) do
		enemy:destroy()
	end
	self._levelEndTrigger:destroy()
	LootDropService:clear()
end

return Level