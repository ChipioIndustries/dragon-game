local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local StoreService = require(ReplicatedStorage.Services.StoreService)

local Level = require(ReplicatedStorage.Classes.Level)

local constants = ReplicatedStorage.Constants
local Responses = require(constants.Responses)
local CONFIG = require(constants.CONFIG)

local getLevelNameByIndex = require(ReplicatedStorage.Utilities.Selectors.getLevelNameByIndex)

local LevelService = {}
LevelService.__index = LevelService

function LevelService.new()
	local self = setmetatable({
		_levels = ServerStorage.Assets.Levels;
		_loadedLevel = nil;
	}, LevelService)

	return self
end

function LevelService:getCurrentLevel()
	return self._loadedLevel
end

function LevelService:init()
	-- check level name validity
	for _index, levelName in ipairs(CONFIG.LevelOrder) do
		assert(self._levels:FindFirstChild(levelName), Responses.LevelService.InvalidLevelNameConfig:format(levelName))
	end

	self.storeChangedConnection = StoreService:getValueChangedSignal("level"):connect(function(newValue, _oldValue)
		local levelName = getLevelNameByIndex(newValue)
		self:_loadLevel(levelName)
	end)
	local initialLevelIndex = StoreService:getState().level
	local levelName = getLevelNameByIndex(initialLevelIndex)
	self:_loadLevel(levelName)
end

function LevelService:_loadLevel(levelName)
	local level = self._levels:FindFirstChild(levelName)
	assert(level, Responses.LevelService.InvalidLevelName)
	self:_unloadLevel()
	self._loadedLevel = Level.new(level)
	self._loadedLevel:init()
	-- TODO: respawn player and enemies from whatever script calls this
end

function LevelService:_unloadLevel()
	if self._loadedLevel then
		self._loadedLevel:destroy()
	end
end

return LevelService.new()