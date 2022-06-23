local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Responses = require(ReplicatedStorage.Constants.Responses)

local Trigger = {}
Trigger.__index = Trigger

function Trigger.new(callback, instance)
	assert(typeof(callback) == "function", Responses.Trigger.InvalidCallback:format(typeof(callback)))
	assert(typeof(instance) == "Instance" and instance:IsA("BasePart"), Responses.Trigger.InvalidInstance:format(instance.ClassName or typeof(instance)))
	local self = setmetatable({
		_callback = callback;
		_instance = instance;
		_touchedConnection = nil;
	}, Trigger)

	return self
end

function Trigger:activate()
	self:_callback()
	self:destroy()
end

function Trigger:destroy()
	self._touchedConnection:Disconnect()
end

function Trigger:init()
	self._touchedConnection = self._instance.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			self:activate()
		end
	end)
end

return Trigger