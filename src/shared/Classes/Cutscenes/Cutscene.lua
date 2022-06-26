local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local packages = ReplicatedStorage.Packages
local Signal = require(packages.Signal)

local Cutscene = {}
Cutscene.__index = Cutscene

--[[
	keyframe:
	CFrame position
	number fieldOfView
	optional bool instant
	optional easingDirection
	optional easingStyle
	optional function effect
	optional number studsPerSecond
	optional signal yieldEvent
]]

function Cutscene.new()
	local self = setmetatable({
		running = false;
		_currentTween = nil;
		finished = Signal.new();
	}, Cutscene)

	return self
end

function Cutscene:play(camera)
	local keyframes = self:_getKeyframes()
	self.running = true
	local liveOpsData = StoreService:getState().liveOpsData.Cutscene
	for _index, keyframe in ipairs(keyframes) do
		if self.running then
			local fieldOfView = keyframe.fieldOfView
			local position = keyframe.position

			local effect = keyframe.effect
			local instant = keyframe.instant
			local yieldEvent = keyframe.yieldEvent
			local easingDirection = keyframe.easingDirection or Enum.EasingDirection[liveOpsData.easingDirection]
			local easingStyle = keyframe.easingStyle or Enum.EasingStyle[liveOpsData.easingStyle]
			local studsPerSecond = keyframe.studsPerSecond or liveOpsData.studsPerSecond

			if effect then
				effect()
			end

			if instant then
				camera.CFrame = position
				camera.FieldOfView = fieldOfView
			else
				local distance = (position.Position - camera.CFrame.Position).Magnitude
				local duration = distance / studsPerSecond
				local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
				local tween = TweenService:Create(camera, tweenInfo, {
					CFrame = position;
					FieldOfView = fieldOfView;
				})
				self._currentTween = tween
				tween:Play()
				task.wait(duration)
				if yieldEvent then
					yieldEvent:wait()
				end
			end
		end
	end
	self:destroy()
	self.finished:fire()
end

function Cutscene:destroy()
	self.running = false
	if self._currentTween and self._currentTween.PlaybackState == Enum.PlaybackState.Playing then
		self._currentTween:Cancel()
	end
end

return Cutscene