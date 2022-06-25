local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

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

local selectors = ReplicatedStorage.Utilities.Selectors
local getTaggedInstancesInDirectory = require(selectors.getTaggedInstancesInDirectory)
local getFirstTaggedInstance = require(selectors.getFirstTaggedInstance)

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
		_fireBreathCheckTimer = {};
		_fireBreathCheckTimerConnection = {};
	}, Enemy)

	return self
end

function Enemy:init(spawnPosition)
	local enemyInstance = enemyAssets[self._name]:Clone()
	enemyInstance.Parent = workspace
	self._enemyInstance = enemyInstance
	self:_getRoot().CFrame = spawnPosition
	self._pathUpdateTimer = Timer.new(self:_getLiveOps().PathRefreshRate)
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
	self._attackTimer = Timer.new(self:_getLiveOps().SecondsPerAttack)
	self._attackTimerConnection = self._attackTimer.Tick:Connect(function()
		self:_attemptRandomAttack()
	end)
	self._attackTimer:Start()
	self._damageCooldown = Cooldown.new(self:_getLiveOps().DamageCooldown)
	self._damageCooldownChangedConnection = StoreService:getValueChangedSignal("liveOpsData.Enemy.DamageCooldown"):connect(function(newValue, _oldValue)
		self._damageCooldown:setDuration(newValue);
	end)
	local damageParts = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.DamageObject)
	for _, damagePart in ipairs(damageParts) do
		local newDamageObject = DamageObject.new(damagePart, self:_getDamage(), self._damageCooldown)
		table.insert(self._damageObjects, newDamageObject)
	end
	self._fireBreathCheckTimer = Timer.new(self:_getLiveOps().FireBreathCheckRate)
	self._fireBreathCheckTimerConnection = self._fireBreathCheckTimer.Tick:Connect(function()
		self:_damageFacingPlayers()
	end)
end

function Enemy:_attemptRandomAttack()
	local target, targetDistance = self:_getTarget()
	if target then
		if targetDistance <= self:_getLiveOps().AttackDistance then
			self:_randomAttack()
		end
	end
end

function Enemy:_damageFacingPlayers()
	local tongue = self:_getTongue()
	local origin = tongue.Position
	local target = tongue.CFrame * Vector3.new(0, 0, -self:_getLiveOps().FireBreath.Distance)
	local yNormalizedTarget = Vector3.new(target.X, origin.Y, target.Z)
	local direction = yNormalizedTarget - origin
	local raycastParams = RaycastParams.new()
	local players = PlayerService:getPlayers()

	local whitelist = {}
	for _, player in ipairs(players) do
		if player.Character then
			for _, element in ipairs(player.Character:GetChildren()) do
				if element:IsA("BasePart") then
					table.insert(whitelist, element)
				end
			end
		end
	end
	raycastParams.FilterDescendantsInstances = whitelist
	raycastParams.FilterType = Enum.RaycastFilterType.Whitelist

	local raycastResult = workspace:Raycast(origin, direction, raycastParams)
	local hit = raycastResult and raycastResult.Instance
	if hit then
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if player and humanoid then
			self._damageCooldown:try(function()
				humanoid:TakeDamage(self:_getDamage())
			end)
		end
	end
end

function Enemy:_disableFireBreath()
	local particleEmitter = self:_getParticleEmitter()
	particleEmitter.Enabled = false
	self._fireBreathCheckTimer:Stop()
end

function Enemy:_enableFireBreath()
	local particleEmitter = self:_getParticleEmitter()
	local liveOps = self:_getLiveOps().FireBreath
	particleEmitter.Speed = NumberRange.new(liveOps.Speed)
	particleEmitter.Lifetime = NumberRange.new(liveOps.Distance / liveOps.Speed)
	particleEmitter.Rate = liveOps.Rate
	particleEmitter.Enabled = true
	self._fireBreathCheckTimer:Start()
end

function Enemy:FireBreath(animationTrack)
	self:_enableFireBreath()
	task.wait(1) -- let the animation run for a bit
	animationTrack:Stop()
	self:_disableFireBreath()
end

function Enemy:_getAnimations()
	return self:_getLiveOps().Animations
end

function Enemy:_getAnimator()
	return getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.Animator)
end

function Enemy:_getDamage()
	return self:_getLiveOps().Damage
end

function Enemy:_getHumanoid()
	return getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.Humanoid)
end

function Enemy:_getLiveOps()
	return StoreService:getState().liveOpsData.Enemy
end

function Enemy:_getParticleEmitter()
	return getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.ParticleEmitter)
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

function Enemy:_getRoot()
	return getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.EnemyRoot)
end

function Enemy:_getTarget()
	local potentialTargets = self:_getPotentialTargets()
	local position = self:_getPosition().Position
	local closestTarget
	local closestDistance = self:_getLiveOps().EyesightDistance
	for _index, potentialTarget in ipairs(potentialTargets) do
		local distance = (potentialTarget.Position - position).magnitude
		if distance < closestDistance then
			closestTarget = potentialTarget
			closestDistance = distance
		end
	end
	return closestTarget, closestDistance
end

function Enemy:_getTongue()
	return getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.Tongue)
end

function Enemy:_moveToNextWaypoint()
	if self._waypoints[1] then
		self:_getHumanoid():MoveTo(self._waypoints[1].Position)
	end
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

function Enemy:_randomAttack()
	local attackNames = {}
	for attackName, _value in pairs(Enums.AttackType) do
		table.insert(attackNames, attackName)
	end
	local attackName = attackNames[self._RNG:NextInteger(1, #attackNames)]
	local animationTrack = self:_playAnimation(self:_getAnimations()[attackName])
	if self[attackName] then
		self[attackName](self, animationTrack)
	end
end

function Enemy:_updatePath()
	local target = self:_getTarget()
	if target then
		local path = PathfindingService:CreatePath(self:_getLiveOps().Pathfinding)
		local success, errorMessage = pcall(function()
			path:ComputeAsync(self:_getPosition().Position, target.Position)
		end)
		if success and path.Status == Enum.PathStatus.Success then
			self._waypoints = path:GetWaypoints()
			--self:_moveToNextWaypoint()
		elseif path.Status ~= Enum.PathStatus.NoPath then
			warn(errorMessage, path.Status)
		end
	end
end

function Enemy:_updatePathTimerRefreshRate()
	self._pathUpdateTimer.Interval = self:_getLiveOps().PathRefreshRate
end

function Enemy:destroy()
	self._pathUpdateTimerConnection:Disconnect()
	self._attackTimerConnection:Disconnect()
	self._refreshRateChangedConnection:disconnect()
	self._damageCooldownChangedConnection:disconnect()
	self._humanoidMovedConnection:Disconnect()
	self._enemyInstance:Destroy()
	self._fireBreathCheckTimerConnection:Disconnect()
	for _, damageObject in ipairs(self._damageObjects) do
		damageObject:destroy()
	end
end

return Enemy