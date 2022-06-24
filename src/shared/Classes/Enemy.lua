local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local ContentProvider = game:GetService("ContentProvider")
local ServerStorage = game:GetService("ServerStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)
local PlayerService = require(services.PlayerService)

local enemyAssets = ServerStorage.Assets.Dragons

local classes = ReplicatedStorage.Classes
local Cooldown = require(classes.Cooldown)
local DamageObject = require(classes.DamageObject)

local Timer = require(ReplicatedStorage.Packages.Timer)

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)
local Enums = require(constants.Enums)
local Responses = require(constants.Responses)

local getTaggedInstancesInDirectory = require(ReplicatedStorage.Utilities.Selectors.getTaggedInstancesInDirectory)

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemyName)
	local self = setmetatable({
		_name = enemyName;
		_RNG = Random.new();
		_enemyInstance = nil;
		_pathUpdateTimer = nil;
		_pathUpdateTimerConnection = nil;
		_refreshRateChangedConnection = nil;
		_humanoidMovedConnection = nil;
		_stateChangedConnection = nil;
		_walkingAnimationTrack = nil;
		_attackTimer = nil;
		_attackTimerConnection = nil;
		_damageCooldown = nil;
		_damageCooldownChangedConnection = nil;
		_damageObjects = {};
	}, Enemy)

	return self
end

function Enemy:_getPathRefreshRate()
	return self:_getLiveOps().PathRefreshRate
end

function Enemy:_getPathfindingConfiguration()
	return self:_getLiveOps().Pathfinding
end

function Enemy:_getEyesightDistance()
	return self:_getLiveOps().EyesightDistance
end

function Enemy:_getAnimations()
	return self:_getLiveOps().Animations
end

function Enemy:_getLiveOps()
	return StoreService:getState().liveOpsData.Enemy
end

function Enemy:_updatePathTimerRefreshRate()
	self._pathUpdateTimer.Interval = self:_getPathRefreshRate()
end

function Enemy:_getAttackRate()
	return self:_getLiveOps().SecondsPerAttack
end

function Enemy:_getAttackDistance()
	return self:_getLiveOps().AttackDistance
end

function Enemy:_getDamageCooldown()
	return self:_getLiveOps().DamageCooldown
end

function Enemy:_getDamage()
	return self:_getLiveOps().Damage
end

function Enemy:_getRoot()
	local root = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.EnemyRoot)[1]
	assert(root, Responses.Enemy.NoEnemyRoot:format(self._name))
	return root
end

function Enemy:_getAnimator()
	local animator = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.Animator)[1]
	assert(animator, Responses.Enemy.NoEnemyAnimator:format(self._name))
	return animator
end

function Enemy:_getPosition()
	local root = self:_getRoot()
	return root.CFrame
end

function Enemy:_getHumanoid()
	local humanoid = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.Humanoid)[1]
	assert(humanoid, Responses.Enemy.NoEnemyHumanoid:format(self._name))
	return humanoid
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
	local closestDistance = self:_getEyesightDistance()
	for _index, potentialTarget in ipairs(potentialTargets) do
		local distance = (potentialTarget.Position - position).magnitude
		if distance < closestDistance then
			closestTarget = potentialTarget
			closestDistance = distance
		end
	end
	return closestTarget, closestDistance
end

function Enemy:_playAnimation(animationId, looped)
	assert(typeof(animationId) == "number", Responses.Enemy.BadAnimationId:format(typeof(animationId)))
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. tostring(animationId)
	local animator = self:_getAnimator()
	local animationTrack = animator:LoadAnimation(animation)
	animationTrack.Looped = looped or false
	animationTrack:Play()
	return animationTrack
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
		elseif path.Status ~= Enum.PathStatus.NoPath then
			warn(errorMessage, path.Status)
		end
	end
end

function Enemy:_moveToNextWaypoint()
	if self._waypoints[1] then
		self:_getHumanoid():MoveTo(self._waypoints[1].Position)
	end
end

function Enemy:_randomAttack()
	local attackNames = {}
	for attackName, _value in pairs(Enums.AttackType) do
		table.insert(attackNames, attackName)
	end
	local attackName = attackNames[self._RNG:NextInteger(1, #attackNames)]
	self:_playAnimation(self:_getAnimations()[attackName])
	if self[attackName] then
		self[attackName](self)
	end
end

function Enemy:_attemptRandomAttack()
	local target, targetDistance = self:_getTarget()
	if target then
		if targetDistance <= self:_getAttackDistance() then
			self:_randomAttack()
		end
	end
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
	self._pathUpdateTimer:Start()
	self._refreshRateChangedConnection = StoreService:getValueChangedSignal("liveOpsData.Enemy.PathRefreshRate"):connect(function(_newValue, _oldValue)
		self:_updatePathTimerRefreshRate();
	end)
	self._humanoidMovedConnection = self:_getHumanoid().MoveToFinished:Connect(function(reached)
		if reached then
			table.remove(self._waypoints, 1)
		end
		self:_moveToNextWaypoint()
	end)
	self:_playAnimation(self:_getAnimations().Idle, true)
	self._stateChangedConnection = self:_getHumanoid().StateChanged:Connect(function(_oldState, newState)
		if newState == Enum.HumanoidStateType.Running then
			local animationTrack = self:_playAnimation(self:_getAnimations().Walk)
			self._walkingAnimationTrack = animationTrack
		else
			if self._walkingAnimationTrack then
				self._walkingAnimationTrack:Stop()
				self._walkingAnimationTrack = nil;
			end
		end
	end)
	self._attackTimer = Timer.new(self:_getAttackRate())
	self._attackTimerConnection = self._attackTimer.Tick:Connect(function()
		self:_attemptRandomAttack()
	end)
	self._attackTimer:Start()
	self._damageCooldown = Cooldown.new(self:_getDamageCooldown())
	self._damageCooldownChangedConnection = StoreService:getValueChangedSignal("liveOpsData.Enemy.DamageCooldown"):connect(function(newValue, _oldValue)
		self._damageCooldown:setDuration(newValue);
	end)
	local damageParts = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.DamageObject)
	for _, damagePart in ipairs(damageParts) do
		local newDamageObject = DamageObject.new(damagePart, self:_getDamage(), self._damageCooldown)
		table.insert(self._damageObjects, newDamageObject)
	end
end

function Enemy:destroy()
	self._pathUpdateTimerConnection:Disconnect()
	self._attackTimerConnection:Disconnect()
	self._refreshRateChangedConnection:disconnect()
	self._damageCooldownChangedConnection:disconnect()
	self._humanoidMovedConnection:Disconnect()
	self._enemyInstance:Destroy()
	for _, damageObject in ipairs(self._damageObjects) do
		damageObject:destroy()
	end
end

return Enemy