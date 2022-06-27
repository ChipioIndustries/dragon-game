local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)

local services = ReplicatedStorage.Services
local NotificationReceiverService = require(services.NotificationReceiverService)

local utilities = ReplicatedStorage.Utilities
local getTaggedInstancesInDirectory = require(utilities.Selectors.getTaggedInstancesInDirectory)
local getCurrentLevelName = require(utilities.Selectors.getCurrentLevelName)

local function getLevelIntroKeyframes()
	local keyframes = {}
	for _, instance in ipairs(getTaggedInstancesInDirectory(workspace, CONFIG.Keys.Tags.CutsceneKeyframe)) do
		local index = instance:GetAttribute(CONFIG.Keys.Attributes.KeyframeIndex)
		local fieldOfView = instance:GetAttribute(CONFIG.Keys.Attributes.FieldOfView)

		local keyframe = {}
		keyframe.position = instance.CFrame
		keyframe.fieldOfView = fieldOfView
		if index == 1 then
			keyframe.effect = function()
				NotificationReceiverService:send(getCurrentLevelName():upper())
			end
			keyframe.instant = true
		end

		keyframes[index] = keyframe
	end
	return keyframes
end

return getLevelIntroKeyframes