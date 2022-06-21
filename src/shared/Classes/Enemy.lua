local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)
local PlayerService = require(services.PlayerService)

local Timer = require(ReplicatedStorage.Packages.Timer)

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)
local Responses = require(constants.Responses)

local getTaggedInstancesInDirectory = require(ReplicatedStorage.Utilities.Selectors.getTaggedInstancesInDirectory)

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemyName)
	local self = setmetatable({
		_name = enemyName;
		_enemyInstance = nil;
		_pathUpdateTimer = nil;
		_pathUpdateTimerConnection = nil;
		_refreshRateChangedConnection = nil;
	}, Enemy)

	return self
end

function Enemy:_getPathRefreshRate()
	return StoreService:getState().liveOpsData.Enemy.PathRefreshRate
end

function Enemy:_updatePathTimerRefreshRate()
	self._pathUpdateTimer.Interval = self:_getPathRefreshRate()
end

function Enemy:_getPosition()
	local root = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.EnemyRoot)[1]
	assert(root, Responses.Enemy.NoEnemyRoot:format(self._name))
	return root.CFrame
end

function Enemy:_getPotentialTargets()
	local humanoidRootParts = {}
	for _index, player in ipairs(PlayerService:getPlayers()) do
		if
			player.Character
			and player.Character:FindFirstChild("HumanoidRootPart")
		then
			table.insert(humanoidRootParts, player.Character.HumanoidRootPart)
		end
	end
	return humanoidRootParts
end

function Enemy:_getTarget()
	local potentialTargets = self:_getPotentialTargets()
	local position = self:_getPosition().Position
	local closestTarget
	local closestDistance = math.huge
	for _index, potentialTarget in ipairs(potentialTargets) do
		local distance = (potentialTarget.Position - position).magnitude
		if distance < closestDistance then
			closestTarget = potentialTarget
			closestDistance = distance
		end
	end
	return closestTarget
end

function Enemy:_updatePath()
	local target = self:_getTarget()
	if target then
		
	end
end

function Enemy:init()
	self:_updatePathTimerRefreshRate()
	self._pathUpdateTimerConnection = self._pathUpdateTimer.Tick:Connect(function()
		self:_updatePath()
	end)
	self._refreshRateChangedConnection = StoreService:getValueChangedSignal("liveOpsData.Enemy.PathRefreshRate"):Connect(function(_newValue, _oldValue)
		self:_updatePathTimerRefreshRate();
	end)
end

return Enemy