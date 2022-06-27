local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)

local constants = ReplicatedStorage.Constants
local Enums = require(constants.Enums)

local components = ReplicatedStorage.Components
local Button = require(components.Button)

local Menu = Roact.Component:extend("Menu")

function Menu:render()
	local props = self.props
	local setEnvironment = props.setEnvironment

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0);
		BackgroundColor3 = Color3.new(0.2, 0.2, 0.2);
		BorderSizePixel = 36;
		BorderColor3 = Color3.new(0.2, 0.2, 0.2);
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical;
			VerticalAlignment = Enum.VerticalAlignment.Center;
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, 8);
		});
		Title = Roact.createElement("TextLabel", {
			Text = "DERGON GAME";
			Font = Enum.Font.Bodoni;
			TextScaled = true;
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 0, 100);
			TextColor3 = Color3.new(1, 1, 1);
			LayoutOrder = 1;
		});
		Play = Roact.createElement(Button, {
			size = UDim2.new(0, 200, 0, 50);
			onClick = function()
				setEnvironment(Enums.GUIEnvironment.Gameplay)
			end;
			layoutOrder = 2;
			text = "PLAY";
		});
	})
end

return Menu