local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local Roact = require(packages.Roact)
local Flipper = require(packages.Flipper)

local services = ReplicatedStorage.Services
local NotificationReceiverService = require(services.NotificationReceiverService)

local components = ReplicatedStorage.Components
local ExpandingBar = require(components.ExpandingBar)

local Notifications = Roact.Component:extend("Notifications")

function Notifications:init()
	self:setState({
		message = nil;
	})
	self.signalConnection = NotificationReceiverService.notification:connect(function(message)
		self:setState({
			message = message
		})
	end)
	self.transparency, self.setTransparency = Roact.createBinding(1)
	self.motor = Flipper.SingleMotor.new(1)
	self.motor:onStep(function(value)
		self.setTransparency(value)
	end)
	self.barAnimationComplete = function()
		task.wait(1)
		self.becomingVisible = false
		self.motor:setGoal(Flipper.Linear.new(1))
	end

	self.motor:onComplete(function()
		if not self.becomingVisible then
			self:setState({
				message = Roact.None;
			})
		end
	end)
end

function Notifications:render()
	local state = self.state
	local message = state.message

	local element

	if message then
		self.becomingVisible = true
		self.motor:setGoal(Flipper.Linear.new(0))
		element = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1);
			BackgroundTransparency = 1;
			Position = UDim2.new(0.5, 0, 0.9, 0);
			Size = UDim2.new(1, 0, 0.1, 0);
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(800, 99999999);
			});
			Label = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1;
				Font = Enum.Font.Bodoni;
				Size = UDim2.new(1, 0, 1, 0);
				Text = message;
				TextColor3 = Color3.new(1, 1, 1);
				TextScaled = true;
				TextTransparency = self.transparency;
			});
			TopBar = Roact.createElement(ExpandingBar, {
				anchorPoint = Vector2.new(0.5, 0);
				position = UDim2.new(0.5, 0, 0, 0);
				transparency = self.transparency;
				onComplete = self.barAnimationComplete;
			});
			BottomBar = Roact.createElement(ExpandingBar, {
				anchorPoint = Vector2.new(0.5, 1);
				position = UDim2.new(0.5, 0, 1, 0);
				transparency = self.transparency;
			})
		})
	else
		element = Roact.createFragment({})
	end


	return element
end

function Notifications:willUnmount()
	self.signalConnection:disconnect()
end

return Notifications