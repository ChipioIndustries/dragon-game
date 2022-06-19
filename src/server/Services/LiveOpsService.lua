local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local StoreService = require(ReplicatedStorage.Services.StoreService)
local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)
local Enums = require(constants.Enums)
local StaticLiveOpsData = require(constants.StaticLiveOpsData)
local Promise = require(ReplicatedStorage.Packages.Promise)
local setLiveOpsData = require(ServerScriptService.Actions.setLiveOpsData)

local LiveOpsService = {}
LiveOpsService.__index = LiveOpsService

function LiveOpsService.new()
	local self = setmetatable({
		_data = nil;
		_dataStore = DataStoreService:GetDataStore(CONFIG.Keys.DataStore.LiveOps.StoreName);
	}, LiveOpsService)

	return self
end

function LiveOpsService:init()
	self:_update():catch(function(failure)
		warn("failed to initialize with liveops data, using static backup instead:", failure)
		self:_setLiveOpsData(StaticLiveOpsData)
	end)
	task.spawn(function()
		while true do
			local refreshRate = self:_getMaxRetries()
			task.wait(refreshRate)
			self:_update():catch(warn)
		end
	end)
end

function LiveOpsService:_setLiveOpsData(data)
	assert(data, "No live ops data")
	self._data = data
	return Promise.resolve(StoreService:dispatch(setLiveOpsData(data)))
end

function LiveOpsService:_update()
	local getAsync = Promise.promisify(self._dataStore.GetAsync)
	return Promise.retryWithDelay(
		getAsync,
		self:_getMaxRetries(),
		self:_getRetryDelay(),
		self._dataStore,
		CONFIG.Keys.DataStore.LiveOps.StoreKey
	):andThen(function(result)
		return self:_setLiveOpsData(result)
	end)
end

function LiveOpsService:_getSettingOrDefault(settingName, default, defaultBehavior)
	local setting = default
	if self._data then
		setting = self._data[settingName] or default
		if defaultBehavior ~= Enums.DefaultBehavior.None then
			setting = math[defaultBehavior:lower()](setting, default)
		end
	end
	return setting
end

function LiveOpsService:_getRefreshRate()
	return self:_getSettingOrDefault(
		CONFIG.Keys.LiveOps.RefreshRate,
		CONFIG.MinimumLiveOpsRefreshRate,
		Enums.DefaultBehavior.Max
	)
end

function LiveOpsService:_getMaxRetries()
	return self:_getSettingOrDefault(
		CONFIG.Keys.LiveOps.Retries,
		CONFIG.DefaultLiveOpsRetries,
		Enums.DefaultBehavior.None
	)
end

function LiveOpsService:_getRetryDelay()
	return self:_getSettingOrDefault(
		CONFIG.Keys.LiveOps.RetryDelay,
		CONFIG.DefaultLiveOpsRetryDelay,
		Enums.DefaultBehavior.Min
	)
end

return LiveOpsService.new()