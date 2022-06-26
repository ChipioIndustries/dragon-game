local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)
local RoactRodux = require(packages.RoactRodux)

local utilities = ReplicatedStorage.Utilities
local getLevelNameByIndex = require(utilities.Selectors.getLevelNameByIndex)

local LevelName = Roact.Component:extend("LevelName")

function LevelName:render()
	local props = self.props
	local level = props.level

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1;
		TextColor3 = Color3.new(1, 1, 1);
		TextScaled = true;
		Font = Enum.Font.GothamBlack;
		Size = UDim2.new(1, 0, 0, 50);
		Text = tostring(level);
	})
end

LevelName = RoactRodux.connect(
	function(state, props)
		return {
			level = getLevelNameByIndex(state.level);
		}
	end
)(LevelName)

return LevelName