local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)
local RoactRodux = require(packages.RoactRodux)

local constants = ReplicatedStorage.Constants
local Enums = require(constants.Enums)

local components = ReplicatedStorage.Components
local Menu = require(components.Menu)
local HUD = require(components.HUD)
local Cutscenes = require(components.Cutscenes)

local App = Roact.Component:extend("App")

function App:init()
	self.setEnvironment = function(environment)
		self:setState({
			environment = environment
		})
	end
	self.setEnvironment(Enums.GUIEnvironment.Menu)
end

function App:render()
	local setEnvironment = self.setEnvironment

	local state = self.state
	local environment = state.environment

	local component
	if environment == Enums.GUIEnvironment.Menu then
		component = Roact.createElement(Menu, {
			setEnvironment = setEnvironment;
		})
	elseif environment == Enums.GUIEnvironment.Gameplay then
		component = Roact.createFragment({
			HUD = Roact.createElement(HUD, {
				setEnvironment = setEnvironment;
			});
			Cutscenes = Roact.createElement(Cutscenes);
		})
	end

	return Roact.createElement(RoactRodux.StoreProvider, {
		store = StoreService;
	}, {
		Interface = Roact.createElement("ScreenGui", {
			ResetOnSpawn = false;
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		}, {
			[environment] = component;
		})
	})
end

return App