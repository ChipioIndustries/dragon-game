local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local classes = ReplicatedStorage.Classes
local Cutscene = require(classes.Cutscenes.Cutscene)

local Death = setmetatable({}, Cutscene)
Death.__index = Death

function Death.new()
	local self = setmetatable(Cutscene.new(), Death)

	return self
end

function Death:_getKeyframes()
	local liveOpsData = StoreService:getState().liveOpsData.Cutscene
	local cameraCFrame = workspace.CurrentCamera.CFrame
	local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local characterPosition = humanoidRootPart and humanoidRootPart.Position or cameraCFrame.Position
	local position = CFrame.lookAt(cameraCFrame.Position + Vector3.new(0, liveOpsData.deathHeight, 0), characterPosition)

	local keyframes = {
		{
			yieldEvent = player.CharacterAdded;
			position = position;
			fieldOfView = 70; -- default field of view
			studsPerSecond = liveOpsData.deathHeight / Players.RespawnTime
		}
	}

	return keyframes
end

return Death