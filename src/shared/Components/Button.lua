local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)

local components = ReplicatedStorage.Components
local Corner = require(components.Corner)

local buttonDefaults = CONFIG.Interface.Defaults.Button

local Button = Roact.Component:extend("Button")

function Button:render()
	local props = self.props
	local size = props.size
	local text = props.text
	local onClick = props.onClick
	local layoutOrder = props.layoutOrder
	local font = props.font or buttonDefaults.Font
	local textColor = props.textColor or buttonDefaults.TextColor
	local backgroundColor = props.backgroundColor or buttonDefaults.BackgroundColor

	return Roact.createElement("TextButton", {
		Text = text;
		BackgroundColor3 = backgroundColor;
		TextScaled = true;
		Size = size;
		LayoutOrder = layoutOrder;
		Font = font;
		TextColor3 = textColor;
		[Roact.Event.Activated] = onClick;
	}, {
		Corner()
	})
end

return Button