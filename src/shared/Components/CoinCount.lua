local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)
local RoactRodux = require(packages.RoactRodux)

local CoinCount = Roact.Component:extend("CoinCount")

function CoinCount:render()
	local props = self.props
	local coins = props.coins

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1;
		TextColor3 = Color3.new(1, 1, 1);
		TextScaled = true;
		Font = Enum.Font.GothamBlack;
		Size = UDim2.new(1, 0, 0, 50);
		Text = "COINS: " .. tostring(coins);
	})
end

CoinCount = RoactRodux.connect(
	function(state, props)
		return {
			coins = state.coins;
		}
	end
)(CoinCount)

return CoinCount