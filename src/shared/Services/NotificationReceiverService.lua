local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Remotes = require(packages.Remotes)
local Signal = require(packages.Signal)

local constants = ReplicatedStorage.Constants
local RemoteNames = require(constants.RemoteNames)

local notificationRemote = Remotes:getEventAsync(RemoteNames.Notification)

local NotificationReceiverService = {}
NotificationReceiverService.__index = NotificationReceiverService

function NotificationReceiverService.new()
	local self = setmetatable({
		notification = Signal.new();

		_notificationConnection = nil;
	}, NotificationReceiverService)

	return self
end

function NotificationReceiverService:init()
	self._notificationConnection = notificationRemote.OnClientEvent:Connect(function(message)
		self:send(message)
	end)
end

function NotificationReceiverService:send(message)
	self.notification:fire(message)
end

return NotificationReceiverService.new()