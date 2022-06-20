local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StoreService = require(ReplicatedStorage.Services.StoreService)
local CONFIG = require(ReplicatedStorage.Constants.CONFIG)
local Enemy = require(ReplicatedStorage.Classes.Enemy)
local getTaggedInstancesInDirectory = require(ReplicatedStorage.Utilities.Selectors.getTaggedInstancesInDirectory)

local Level = {}
Level.__index = Level

function Level.new(levelService, levelTemplate)
	local self = setmetatable({
		_levelService = levelService;
		_levelTemplate = levelTemplate;
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
	end
end

function Level:destroy()
	self._levelInstance:Destroy()
	for _index, enemy in ipairs(self._enemies) do
		enemy:destroy()
	end
end

return Level