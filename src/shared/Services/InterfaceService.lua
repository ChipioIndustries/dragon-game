local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)

local components = ReplicatedStorage.Components
local App = require(components.App)

local InterfaceService = {}
InterfaceService.__index = InterfaceService

function InterfaceService.new()
	local self = setmetatable({
		_appHandle = nil;
	}, InterfaceService)

	return self
end

function InterfaceService:init()
	local app = Roact.createElement(App)
	self._appHandle = Roact.mount(app, playerGui)
end

return InterfaceService