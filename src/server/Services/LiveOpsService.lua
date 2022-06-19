local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local StoreService = require(ReplicatedStorage.Services.StoreService)
local CONFIG = require(ReplicatedStorage.Constants.CONFIG)
local Promise = require(ReplicatedStorage.Packages.Promise)
local setLiveOpsData = require(ServerScriptService.Actions.setLiveOpsData)

local dataStore = DataStoreService:GetDataStore(CONFIG.Keys.DataStore.LiveOps.StoreName)

local LiveOpsService = {}
LiveOpsService.__index = LiveOpsService

function LiveOpsService.new()
	local self = setmetatable({
		_data = nil;
	}, LiveOpsService)

	return self
end

function LiveOpsService:init()
	self:_update():catch(function(failure)
		warn("failed to initialize with liveops data, using static backup instead:", failure)

	end)
	task.spawn(function()
		while true do
			local refreshRate = CONFIG.MinimumLiveOpsRefreshRate
			if self._data then
				refreshRate = math.max(self._data.LiveOpsRefreshRate or refreshRate) or refreshRate
			end
			task.wait(refreshRate)
			self:_update():catch(function(failure)

			end)
		end
	end)
end

function LiveOpsService:_setLiveOpsData(data)
	assert(data, "No live ops data")
	self._data = data
	return Promise.resolve(StoreService:dispatch(setLiveOpsData(data)))
end

function LiveOpsService:_update()
	local getAsync = Promise.promisify(dataStore.GetAsync)
	return getAsync(dataStore, CONFIG.Keys.DataStore.LiveOps.StoreKey):andThen(function(result)
		return self:_setLiveOpsData(result)
	end)
end

return LiveOpsService.new()