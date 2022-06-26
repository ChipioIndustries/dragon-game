local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)

local components = ReplicatedStorage.Components
local CoinCount = require(components.CoinCount)
local LevelName = require(components.LevelName)

local HUD = Roact.Component:extend("HUD")

function HUD:render()
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1;
		Size = UDim2.new(0.2, 0, 1, 0);
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical;
			VerticalAlignment = Enum.VerticalAlignment.Center;
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, 8);
		});
		CoinCount = Roact.createElement(CoinCount);
		LevelName = Roact.createElement(LevelName);
	})
end

return HUD