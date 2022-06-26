local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)

local HUD = Roact.Component:extend("HUD")

function HUD:render()
	return Roact.createElement("TextButton")
end

return HUD