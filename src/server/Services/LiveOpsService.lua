local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local StoreService = require(ReplicatedStorage.Services.StoreService)

local packages = ReplicatedStorage.Packages
local Promise = require(packages.Promise)
local Timer = require(packages.Timer)
local Llama = require(packages.Llama)

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)
local Enums = require(constants.Enums)
local Responses = require(constants.Responses)
local StaticLiveOpsData = require(constants.StaticLiveOpsData)

local setLiveOpsData = require(ServerScriptService.Actions.setLiveOpsData)

local LiveOpsService = {}
LiveOpsService.__index = LiveOpsService

function LiveOpsService.new()
	local self = setmetatable({
		_data = nil;
		_dataStore = DataStoreService:GetDataStore(CONFIG.Keys.DataStore.LiveOps.StoreName);
		_updateLoopTimer = nil;
		_updateTimerConnection = nil;
	}, LiveOpsService)

	return self
end

function LiveOpsService:_getMaxRetries()
	return self:_getSettingOrDefault(
		CONFIG.Keys.LiveOps.Retries,
		CONFIG.LiveOps.DefaultRetries,
		Enums.DefaultBehavior.None
	)
end

function LiveOpsService:_getRefreshRate()
	return self:_getSettingOrDefault(
		CONFIG.Keys.LiveOps.RefreshRate,
		CONFIG.LiveOps.MinimumRefreshRate,
		Enums.DefaultBehavior.Max
	)
end

function LiveOpsService:_getRetryDelay()
	return self:_getSettingOrDefault(
		CONFIG.Keys.LiveOps.RetryDelay,
		CONFIG.LiveOps.DefaultRetryDelay,
		Enums.DefaultBehavior.Min
	)
end

function LiveOpsService:_getSettingOrDefault(settingName, default, defaultBehavior)
	local setting = default
	if self._data and self._data.LiveOps then
		setting = self._data.LiveOps[settingName] or default
		if defaultBehavior ~= Enums.DefaultBehavior.None then
			setting = math[defaultBehavior:lower()](setting, default)
		end
	end
	return setting
end

function LiveOpsService:init()
	-- update timer when interval changes
	self._updateLoopTimer = Timer.new(self:_getRefreshRate())
	self._stateChangeConnection = StoreService:getValueChangedSignal(table.concat({
		"liveOpsData",
		CONFIG.Keys.LiveOps.RefreshRate
	}, ".")):connect(function()
		self:_updateTimer()
	end)

	-- get initial liveops data
	self:_update():catch(function(failure)
		warn(Responses.LiveOpsService.InitialDataFailed, failure)
		self:_setLiveOpsData(StaticLiveOpsData)
	end):await()


	-- bind update function to timer
	self._updateTimerConnection = self._updateLoopTimer.Tick:Connect(function()
		self:_update():catch(warn)
	end)
	self._updateLoopTimer:Start()
end

function LiveOpsService:_setLiveOpsData(data)
	assert(data, Responses.LiveOpsService.setLiveOpsDataNoData)
	if not Llama.Dictionary.equalsDeep(data, self._data) then
		self._data = data
		return Promise.resolve(StoreService:dispatch(setLiveOpsData(data)))
	else
		return Promise.resolve()
	end
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

function LiveOpsService:_updateTimer()
	local refreshRate = self:_getRefreshRate()
	self._updateLoopTimer.Interval = refreshRate
end


return LiveOpsService.new()