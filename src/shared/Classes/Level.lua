local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CONFIG = require(ReplicatedStorage.Constants.CONFIG)

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
		_levelInstance = nil;
		_enemies = {};
	}, Level)

	return self
end

function Level:finish()
	self._levelService:nextLevel()
end

function Level:init()
	-- copy level template into Workspace
	local newLevel = self._levelTemplate:Clone()
	newLevel.Parent = workspace
	self._loadedLevel = newLevel

	-- initialize enemies
	local enemySpawns = getTaggedInstancesInDirectory(self._loadedLevel, CONFIG.Keys.Tags.EnemySpawn)
	for _index, enemySpawn in ipairs(enemySpawns) do
		local newEnemy = Enemy.new(enemyTemplate)
		table.insert(self._enemies, newEnemy)
	end

	-- initialize level end trigger
	local levelEndInstance = getTaggedInstancesInDirectory(self._loadedLevel, CONFIG.Keys.Tags.LevelEnd)
	local levelEndTrigger = LevelEndTrigger.new(self, levelEndInstance)
	self._levelEndTrigger = levelEndTrigger
end

function Level:destroy()
	self._levelInstance:Destroy()
	for _index, enemy in ipairs(self._enemies) do
		enemy:destroy()
	end
	self._levelEndTrigger:destroy()
end

return Level