local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local ServerStorage = game:GetService("ServerStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)
local PlayerService = require(services.PlayerService)

local enemyAssets = ServerStorage.Assets.Dragons

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
		_humanoidMovedConnection = nil;
	}, Enemy)

	return self
end

function Enemy:_getPathRefreshRate()
	return self:_getLiveOps().PathRefreshRate
end

function Enemy:_getPathfindingConfiguration()
	return self:_getLiveOps().Pathfinding
end

function Enemy:_getLiveOps()
	return StoreService:getState().liveOpsData.Enemy
end

function Enemy:_updatePathTimerRefreshRate()
	self._pathUpdateTimer.Interval = self:_getPathRefreshRate()
end

function Enemy:_getRoot()
	local root = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.EnemyRoot)[1]
	assert(root, Responses.Enemy.NoEnemyRoot:format(self._name))
	return root
end

function Enemy:_getPosition()
	local root = self:_getRoot()
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
	return closestTarget, closestDistance
end

function Enemy:_updatePath()
	local target = self:_getTarget()
	if target then
		local path = PathfindingService:CreatePath(self:_getPathfindingConfiguration())
		local success, errorMessage = pcall(function()
			path:ComputeAsync(self:_getPosition().Position, target.Position)
		end)
		if success and path.Status == Enum.PathStatus.Success then
			self._waypoints = path:GetWaypoints()
			self:_moveToNextWaypoint()
		else
			warn(errorMessage, path.Status)
		end
	end
end

function Enemy:_moveToNextWaypoint()
	self._enemyInstance.Humanoid:MoveTo(self._waypoints[1].Position)
end

function Enemy:init(spawnPosition)
	local enemyInstance = enemyAssets[self._name]:Clone()
	enemyInstance.Parent = workspace
	self._enemyInstance = enemyInstance
	self:_getRoot().CFrame = spawnPosition
	self._pathUpdateTimer = Timer.new(self:_getPathRefreshRate())
	self:_updatePathTimerRefreshRate()
	self._pathUpdateTimerConnection = self._pathUpdateTimer.Tick:Connect(function()
		self:_updatePath()
	end)
	self._refreshRateChangedConnection = StoreService:getValueChangedSignal("liveOpsData.Enemy.PathRefreshRate"):connect(function(_newValue, _oldValue)
		self:_updatePathTimerRefreshRate();
	end)
	self._humanoidMovedConnection = self._enemyInstance.Humanoid.MoveToFinished:Connect(function(reached)
		if reached then
			table.remove(self._waypoints, 1)
		end
		self:_moveToNextWaypoint()
	end)
end

function Enemy:destroy()
	self._pathUpdateTimerConnection:Disconnect()
	self._refreshRateChangedConnection:disconnect()
	self._humanoidMovedConnection:Disconnect()
	self._enemyInstance:Destroy()
end

return Enemy