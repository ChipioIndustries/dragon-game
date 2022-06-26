local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local RemoteNames = require(constants.RemoteNames)

local packages = ReplicatedStorage.Packages
local Remotes = require(packages.Remotes)

local levelLoadFinishedRemote = Remotes:getEventAsync(RemoteNames.LevelLoadFinished)
local getLevelLoadedRemote = Remotes:getFunctionAsync(RemoteNames.GetLevelLoaded)

local LevelLoadedService = {}
LevelLoadedService.__index = LevelLoadedService

function LevelLoadedService.new()
	local self = setmetatable({
		_bindings = {};
		_lastLevelLoaded = nil;
		_loadFinishedRemoteConnection = nil;
	}, LevelLoadedService)

	return self
end

function LevelLoadedService:init()
	self._loadFinishedRemoteConnection = levelLoadFinishedRemote.OnClientEvent:Connect(function(levelName)
		self:update(levelName)
	end)
	self:update(getLevelLoadedRemote:InvokeServer())
end

function LevelLoadedService:update(levelName)
	if levelName ~= self._lastLevelLoaded then
		self._lastLevelLoaded = levelName;
		for _handle, binding in pairs(self._bindings) do
			task.spawn(function()
				binding(levelName)
			end)
		end
	end
end

function LevelLoadedService:bindToLevelReady(callback)
	local handle = HttpService:GenerateGUID(false)
	self._bindings[handle] = callback
	if self._lastLevelLoaded then
		callback(self._lastLevelLoaded)
	end
	return handle
end

function LevelLoadedService:getLastLevelName()
	return self._lastLevelLoaded
end

function LevelLoadedService:unbind(handle)
	self._bindings[handle] = nil
end

return LevelLoadedService.new()