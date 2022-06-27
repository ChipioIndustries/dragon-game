local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local RemoteNames = require(constants.RemoteNames)

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local packages = ReplicatedStorage.Packages
local Remotes = require(packages.Remotes)

local classes = ReplicatedStorage.Classes
local Trigger = require(classes.Trigger)

local notificationRemote = Remotes:getEventAsync(RemoteNames.Notification)

local LevelEndTrigger = setmetatable({}, Trigger)
LevelEndTrigger.__index = LevelEndTrigger

function LevelEndTrigger.new(level, instance)
	local function callback(player)
		local result = level:finish()
		if not result then
			local message = StoreService:getState().liveOpsData.Notifications.DefeatAllEnemies
			notificationRemote:FireClient(player, message)
			task.wait(3)
		end
		return result
	end

	local self = setmetatable(Trigger.new(callback, instance), LevelEndTrigger)

	return self
end

return LevelEndTrigger