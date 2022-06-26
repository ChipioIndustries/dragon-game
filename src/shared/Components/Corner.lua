local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)

local cornerDefaults = CONFIG.Interface.Defaults.Corner

local Corner = Roact.Component:extend("UICorner")

function Corner:render()
	local props = self.props
	local radius = props.radius or cornerDefaults.Radius

	return Roact.createElement("UICorner", {
		CornerRadius = radius;
	})
end

local function makeCorner(radius)
	return Roact.createElement(Corner, {
		radius = radius;
	})
end

return makeCorner