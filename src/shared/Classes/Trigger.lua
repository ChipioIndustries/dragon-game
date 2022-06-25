local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Responses = require(constants.Responses)

local Trigger = {}
Trigger.__index = Trigger

function Trigger.new(callback, instance, destroyInstanceOnActivation)
	assert(typeof(callback) == "function", Responses.Trigger.InvalidCallback:format(typeof(callback)))
	assert(typeof(instance) == "Instance" and instance:IsA("BasePart"), Responses.Trigger.InvalidInstance:format(instance.ClassName or typeof(instance)))
	local self = setmetatable({
		_callback = callback;
		_destroyInstanceOnActivation = destroyInstanceOnActivation;
		_instance = instance;
		_touchedConnection = nil;
	}, Trigger)

	return self
end

function Trigger:init()
	self._touchedConnection = self._instance.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			self:activate(player)
		end
	end)
end

function Trigger:activate(player)
	self:_callback(player)
	self:destroy()
end

function Trigger:destroy()
	if self._touchedConnection.Connected then
		self._touchedConnection:Disconnect()
	end
	if self._instance and self._destroyInstanceOnActivation then
		self._instance:Destroy()
	end
end

return Trigger