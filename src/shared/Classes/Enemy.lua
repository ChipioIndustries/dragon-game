local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local services = ReplicatedStorage.Services
local PlayerService = require(services.PlayerService)
local StoreService = require(services.StoreService)

local serverServices = ServerScriptService.Services
local LootDropService = require(serverServices.LootDropService)
local WeaponDamageService = require(serverServices.WeaponDamageService)

local enemyAssets = ServerStorage.Assets.Dragons

local classes = ReplicatedStorage.Classes
local Cooldown = require(classes.Cooldown)
local DamageObject = require(classes.DamageObject)
local Maid = require(classes.Maid)

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

function Enemy.new(enemyName, strength)
	local self = setmetatable({
		dead = false;

		_maid = Maid.new();
		_name = enemyName;
		_RNG = Random.new();
		_strength = strength;

		_attackTimer = nil;
		_damageCooldown = nil;
		_enemyInstance = nil;
		_fireBreathCheckTimer = nil;
		_pathUpdateTimer = nil;
		_walkingAnimationTrack = nil;

		_animator = nil;
		_humanoid = nil;
		_particleEmitter = nil;
		_root = nil;
		_tongue = nil;
	}, Enemy)

	return self
end

function Enemy:init(spawnPosition)
	-- spawn
	local enemyInstance = enemyAssets[self._name]:Clone()
	enemyInstance.Parent = workspace
	self._enemyInstance = enemyInstance

	-- components
	self._animator = getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.Animator)
	self._humanoid = getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.Humanoid)
	self._particleEmitter = getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.ParticleEmitter)
	self._root = getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.EnemyRoot)
	self._tongue = getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.Tongue)

	-- set enemy position
	self._root.CFrame = spawnPosition

	-- pathfinding
	self._pathUpdateTimer = Timer.new(self:_getLiveOps().PathRefreshRate)
	self:_updatePathTimerRefreshRate()
	self:_bindSignalToMethod(self._pathUpdateTimer.Tick, self._updatePath)
	self._pathUpdateTimer:Start()
	self:_bindSignalToMethod(StoreService:getValueChangedSignal("liveOpsData.Enemy.PathRefreshRate"), self._updatePathTimerRefreshRate)
	self._maid:giveTask(self._humanoid.MoveToFinished:Connect(function(reached)
		if reached then
			table.remove(self._waypoints, 1)
		end
		self:_moveToNextWaypoint()
	end))

	-- animation
	self:_playAnimation(self:_getAnimations().Idle, true)
	self._maid:giveTask(self._humanoid.StateChanged:Connect(function(_oldState, newState)
		if newState == Enum.HumanoidStateType.Running then
			local animationTrack = self:_playAnimation(self:_getAnimations().Walk)
			self._walkingAnimationTrack = animationTrack
		else
			if self._walkingAnimationTrack then
				self._walkingAnimationTrack:Stop()
				self._walkingAnimationTrack = nil;
			end
		end
	end))

	-- attacks
	self._attackTimer = Timer.new(self:_getLiveOps().SecondsPerAttack)
	self:_bindSignalToMethod(self._attackTimer.Tick, self._attemptRandomAttack)
	self._attackTimer:Start()

	-- attack damage
	self._damageCooldown = Cooldown.new(self:_getLiveOps().DamageCooldown)
	self._maid:giveTask(StoreService:getValueChangedSignal("liveOpsData.Enemy.DamageCooldown"):connect(function(newValue, _oldValue)
		self._damageCooldown:setDuration(newValue);
	end))
	local damageParts = getTaggedInstancesInDirectory(self._enemyInstance, CONFIG.Keys.Tags.DamageObject)
	for _, damagePart in ipairs(damageParts) do
		self._maid:giveTask(DamageObject.new(damagePart, self:_getDamage(), self._damageCooldown))
	end

	-- receive damage
	for _, instance in ipairs(self._enemyInstance:GetDescendants()) do
		if instance:IsA("BasePart") then
			self._maid:giveTask(instance.Touched:Connect(function(hit)
				if CollectionService:HasTag(hit, CONFIG.Keys.Tags.Blade) then
					WeaponDamageService:tryDamage(function()
						local weaponName = hit.Parent.Name
						self._humanoid:TakeDamage(StoreService:getState().liveOpsData.Weapons.Damage[weaponName])
					end)
				end
			end))
		end
	end
	self:_bindSignalToMethod(self._humanoid.Died, self._kill)
	local health = self._strength * self:_getLiveOps().HealthMultiplier
	self._humanoid.MaxHealth = health
	self._humanoid.Health = health

	-- strength display
	local diamondTemplate = getFirstTaggedInstance(self._enemyInstance, CONFIG.Keys.Tags.StrengthDisplayTemplate)
	for _index = 1, self._strength do
		local diamond = diamondTemplate:Clone()
		diamond.Visible = true
		diamond.Parent = diamondTemplate.Parent
	end

	-- fire breath query timer
	self._fireBreathCheckTimer = Timer.new(self:_getLiveOps().FireBreathCheckRate)
	self:_bindSignalToMethod(self._fireBreathCheckTimer.Tick, self._damageFacingPlayers)
end

function Enemy:_attemptRandomAttack()
	local target, targetDistance = self:_getTarget()
	if target then
		if targetDistance <= self:_getLiveOps().AttackDistance then
			self:_randomAttack()
		end
	end
end

function Enemy:_bindSignalToMethod(signal, method)
	local connection
	if typeof(signal) == "RBXScriptSignal" then
		connection = signal:Connect(function(...)
			method(self, ...)
		end)
	else
		local connect = signal.Connect or signal.connect
		connection = connect(signal, function(...)
			method(self, ...)
		end)
	end
	self._maid:giveTask(connection)
end

function Enemy:_damageFacingPlayers()
	local origin = self._tongue.Position
	local target = self._tongue.CFrame * Vector3.new(0, 0, -self:_getLiveOps().FireBreath.Distance)
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
	self._particleEmitter.Enabled = false
	self._fireBreathCheckTimer:Stop()
end

function Enemy:_enableFireBreath()
	local particleEmitter = self._particleEmitter
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

function Enemy:_getDamage()
	return self:_getLiveOps().DamageMultiplier
end

function Enemy:_getLiveOps()
	return StoreService:getState().liveOpsData.Enemy
end

function Enemy:_getPosition()
	return self._root.CFrame
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

function Enemy:_kill()
	self.dead = true;
	for _, track in ipairs(self._animator:GetPlayingAnimationTracks()) do
		track:Stop()
	end
	self._root.Anchored = true
	local deathAnimationTrack = self:_playAnimation(self:_getAnimations().Death, false)
	self._attackTimer:Stop()
	self._fireBreathCheckTimer:Stop()
	self._pathUpdateTimer:Stop()
	deathAnimationTrack.Stopped:Wait()
	LootDropService:randomDrop(self:_getPosition().Position)
	self:destroy()
end

function Enemy:_moveToNextWaypoint()
	if self._waypoints[1] then
		self._humanoid:MoveTo(self._waypoints[1].Position)
	end
end

function Enemy:_playAnimation(animationId, looped)
	assert(typeof(animationId) == "number", Responses.Enemy.BadAnimationId:format(typeof(animationId)))
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. tostring(animationId)
	local animationTrack = self._animator:LoadAnimation(animation)
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
			self:_moveToNextWaypoint()
		elseif path.Status ~= Enum.PathStatus.NoPath then
			warn(errorMessage, path.Status)
		end
	end
end

function Enemy:_updatePathTimerRefreshRate()
	self._pathUpdateTimer.Interval = self:_getLiveOps().PathRefreshRate
end

function Enemy:destroy()
	self._maid:destroy()
	self._enemyInstance:Destroy()
end

return Enemy