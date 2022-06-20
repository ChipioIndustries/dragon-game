local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trigger = require(ReplicatedStorage.Classes.Trigger)

local LevelEndTrigger = setmetatable({}, Trigger)
LevelEndTrigger.__index = LevelEndTrigger

function LevelEndTrigger.new(level, instance)
	local function callback()
		level:finish()
	end

	local self = setmetatable(Trigger.new(callback, instance), LevelEndTrigger)

	return self
end

return LevelEndTrigger