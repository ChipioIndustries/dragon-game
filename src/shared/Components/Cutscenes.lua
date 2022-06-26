local ReplicatedStorage = game:GetService("ReplicatedStorage")

local constants = ReplicatedStorage.Constants
local Enums = require(constants.Enums)

local services = ReplicatedStorage.Services
local CutsceneService = require(services.CutsceneService)
local LevelLoadedService = require(services.LevelLoadedService)

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)
local RoactRodux = require(packages.RoactRodux)
local Flipper = require(packages.Flipper)

local utilities = ReplicatedStorage.Utilities
local getLevelNameByIndex = require(utilities.Selectors.getLevelNameByIndex)

local Cutscenes = Roact.Component:extend("Cutscenes")

function Cutscenes:init()
	self.lastLevel = LevelLoadedService:getLastLevelName()
	self.coverTransparency, self.setCoverTransparency = Roact.createBinding(0)
	self.motor = Flipper.SingleMotor.new(0)
	self.motor:onStep(function(value)
		self.setCoverTransparency(value)
	end)
	self.levelLoadedHandle = LevelLoadedService:bindToLevelReady(function(_levelName)
		self.motor:setGoal(Flipper.Linear.new(1))
		CutsceneService:play(Enums.Cutscene.LevelIntro)
	end)
end

function Cutscenes:render()
	local lastLevel = self.lastLevel

	local props = self.props
	local level = props.level

	local elements = {
		Cover = Roact.createElement("Frame", {
			BackgroundColor3 = Color3.new(0, 0, 0);
			BackgroundTransparency = self.coverTransparency;
			BorderColor3 = Color3.new(0, 0, 0);
			BorderSizePixel = 36;
			Size = UDim2.new(1, 0, 1, 0);
		})
	}

	if level ~= lastLevel then
		self.lastLevel = level
		self.motor:setGoal(Flipper.Linear.new(0))
	end

	return Roact.createFragment(elements)
end

function Cutscenes:willUnmount()
	LevelLoadedService:unbind(self.levelLoadedHandle)
end

Cutscenes = RoactRodux.connect(
	function(state, _action)
		return {
			level = getLevelNameByIndex(state.level);
		}
	end
)(Cutscenes)

return Cutscenes