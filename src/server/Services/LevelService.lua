local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local packages = ReplicatedStorage.Packages
local Remotes = require(packages.Remotes)

local StoreService = require(ReplicatedStorage.Services.StoreService)

local Level = require(ReplicatedStorage.Classes.Level)

local constants = ReplicatedStorage.Constants
local Responses = require(constants.Responses)
local CONFIG = require(constants.CONFIG)
local RemoteNames = require(constants.RemoteNames)

local setLevel = require(ServerScriptService.Actions.setLevel)
local incrementLevel = require(ServerScriptService.Actions.incrementLevel)

local getLevelNameByIndex = require(ReplicatedStorage.Utilities.Selectors.getLevelNameByIndex)

local levelLoadFinishedRemote = Remotes:getEventAsync(RemoteNames.LevelLoadFinished)
local getLevelLoadedRemote = Remotes:getFunctionAsync(RemoteNames.GetLevelLoaded)

local LevelService = {}
LevelService.__index = LevelService

function LevelService.new()
	local self = setmetatable({
		_levels = ServerStorage.Assets.Levels;
		_loadedLevel = nil;
		_lastLoadedLevel = nil;

		_storeChangedConnection = nil;

	}, LevelService)

	return self
end

function LevelService:getCurrentLevel()
	return self._loadedLevel
end

function LevelService:getSpawnPosition()
	local currentLevel = self:getCurrentLevel()
	if currentLevel then
		return currentLevel:getSpawnPosition()
	end
	return CFrame.new()
end

function LevelService:nextLevel()
	local currentLevel = StoreService:getState().level
	if getLevelNameByIndex(currentLevel + 1) then
		StoreService:dispatch(incrementLevel())
	else
		StoreService:dispatch(setLevel(1))
	end
end

function LevelService:init()
	-- check level name validity
	for _index, levelName in ipairs(CONFIG.LevelOrder) do
		assert(self._levels:FindFirstChild(levelName), Responses.LevelService.InvalidLevelNameConfig:format(levelName))
	end

	self._storeChangedConnection = StoreService:getValueChangedSignal("level"):connect(function(newValue, _oldValue)
		local levelName = getLevelNameByIndex(newValue)
		self:_loadLevel(levelName)
	end)

	local initialLevelIndex = StoreService:getState().level
	local levelName = getLevelNameByIndex(initialLevelIndex)
	self:_loadLevel(levelName)

	getLevelLoadedRemote.OnServerInvoke = function(_player)
		return self._lastLoadedLevel
	end
end

function LevelService:_broadcastLevelLoaded(levelName)
	levelLoadFinishedRemote:FireAllClients(levelName)
	self._lastLoadedLevel = levelName
end

function LevelService:_loadLevel(levelName)
	local level = self._levels:FindFirstChild(levelName)
	assert(level, Responses.LevelService.InvalidLevelName)
	self:_unloadLevel()
	self._loadedLevel = Level.new(self, level)
	self._loadedLevel:init()
	self:_broadcastLevelLoaded(levelName)
end

function LevelService:_unloadLevel()
	if self._loadedLevel then
		self._loadedLevel:destroy()
	end
end

return LevelService.new()