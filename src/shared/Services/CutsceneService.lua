local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local constants = ReplicatedStorage.Constants
local Enums = require(constants.Enums)

local player = Players.LocalPlayer

local cutscenes = ReplicatedStorage.Classes.Cutscenes

local CutsceneService = {}
CutsceneService.__index = CutsceneService

function CutsceneService.new()
	local self = setmetatable({
		_cutscenes = {};

		_camera = nil;
		_playingCutscene = nil;
		_playingCutsceneFinishedConnection = nil;
		_characterAddedConnection = nil;
	}, CutsceneService)

	return self
end

function CutsceneService:init()
	self._camera = workspace.CurrentCamera
	for _, module in ipairs(cutscenes:GetChildren()) do
		self._cutscenes[module.Name] = require(module)
	end
	local function listenToCharacterDeath(character)
		character:WaitForChild("Humanoid").Died:Connect(function()
			self:play(Enums.Cutscene.Death)
		end)
	end
	if player.Character then
		listenToCharacterDeath(player.Character)
	end
	self._characterAddedConnection = player.CharacterAdded:Connect(listenToCharacterDeath)
end

function CutsceneService:play(cutsceneName)
	-- clean up any previous/running cutscene
	if self._playingCutscene and self._playingCutscene.running then
		self._playingCutscene:destroy()
	end
	if self._playingCutsceneFinishedConnection then
		self._playingCutsceneFinishedConnection:disconnect()
	end

	-- create and run the new cutscene
	self._playingCutscene = self._cutscenes[cutsceneName].new()
	self:_captureCamera()
	self._playingCutsceneFinishedConnection = self._playingCutscene.finished:connect(function()
		self:_releaseCamera()
	end)
	task.spawn(function()
		self._playingCutscene:play(self._camera)
	end)

	return self._playingCutscene
end

function CutsceneService:_captureCamera()
	self._camera.CameraType = Enum.CameraType.Scriptable
end

function CutsceneService:_releaseCamera()
	self._camera.CameraType = Enum.CameraType.Custom
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		self._camera.CameraSubject = player.Character.Humanoid
	end
end

return CutsceneService.new()