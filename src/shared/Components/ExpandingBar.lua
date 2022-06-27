local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)
local Flipper = require(packages.Flipper)

local ExpandingBar = Roact.Component:extend("ExpandingBar")

function ExpandingBar:init()
	local props = self.props
	local onComplete = props.onComplete

	self.barWidth, self.setBarWidth = Roact.createBinding(0)
	self.motor = Flipper.SingleMotor.new(0)
	self.motor:onStep(function(value)
		self.setBarWidth(value)
	end)
	self.motor:onComplete(onComplete or function() end)
	self.motor:setGoal(Flipper.Spring.new(1, {
		frequency = 0.5;
		dampingRatio = 1;
	}))
end

function ExpandingBar:render()
	local props = self.props
	local anchorPoint = props.anchorPoint
	local position = props.position
	local transparency = props.transparency

	return Roact.createElement("Frame", {
		AnchorPoint = anchorPoint;
		BackgroundColor3 = Color3.new(1, 1, 1);
		BackgroundTransparency = transparency;
		BorderSizePixel = 0;
		Position = position;
		Size = self.barWidth:map(function(value)
			return UDim2.new(value, 0, 0, 4);
		end);
	})
end

return ExpandingBar