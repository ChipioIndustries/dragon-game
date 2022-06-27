local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local services = ReplicatedStorage.Services
local PlayerService = require(services.PlayerService)
local StoreService = require(services.StoreService)
local SoundService = require(services.SoundService)

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)
local RemoteNames = require(constants.RemoteNames)

local classes = ReplicatedStorage.Classes
local Cooldown = require(classes.Cooldown)

local packages = ReplicatedStorage.Packages
local Remotes = require(packages.Remotes)
local Signal = require(packages.Signal)

local utilities = ReplicatedStorage.Utilities
local getTaggedInstancesInDirectory = require(utilities.Selectors.getTaggedInstancesInDirectory)
local weldTool = require(utilities.weldTool)
local playAnimation = require(utilities.playAnimation)

local swingRemote = Remotes:getEventAsync(RemoteNames.Swing)

local WeaponService = {}
WeaponService.__index = WeaponService

function WeaponService.new()
	local self = setmetatable({
		-- server
		_storeChangedConnection = nil;
		_playerAddedConnection = nil;
		_weapons = nil;
		WeaponSwap = nil;
		-- client
		_userInputConnection = nil;
		_player = nil;
		_swingCooldown = nil;
	}, WeaponService)

	return self
end

function WeaponService:init()
	if RunService:IsServer() then
		self._weapons = ServerStorage.Assets.Weapons
		self._storeChangedConnection = StoreService:getValueChangedSignal("weapon"):connect(function(_newValue, _oldValue)
			task.spawn(function()
				self:_updateWeapons(false)
			end)
		end)
		self._playerAddedConnection = PlayerService.playerAdded:connect(function(player)
			player.CharacterAdded:Connect(function(character)
				while not (
					character:IsDescendantOf(workspace)
				and character:FindFirstChild("HumanoidRootPart")
				) do
					task.wait()
				end
				self:_updateWeapons(true)
			end)
		end)
		self.WeaponSwap = Signal.new()
	elseif RunService:IsClient() then
		self._player = Players.LocalPlayer
		self._swingCooldown = Cooldown.new(StoreService:getState().liveOpsData.Weapons.SwingCooldown)
		self._userInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if
					input.UserInputType == Enum.UserInputType.MouseButton1
					or (
						input.UserInputType == Enum.UserInputType.Gamepad1
						and input.KeyCode == Enum.KeyCode.ButtonR1
					)
				then
					local root = self._player.Character and self._player.Character:FindFirstChild("HumanoidRootPart")
					self._swingCooldown:try(function()
						swingRemote:FireServer()
						playAnimation(self._player, self._getAnimations().Swing)
						SoundService:play(StoreService:getState().liveOpsData.Sounds.Sword.Swing, root)
					end)
				end
			end
		end)
	end
end

function WeaponService:_getPlayerWeapon(player)
	if player.Character then
		local weapon = getTaggedInstancesInDirectory(player.Character, CONFIG.Keys.Tags.Weapon)[1]
		return weapon
	end
	return nil
end

function WeaponService:_getAnimations()
	return StoreService:getState().liveOpsData.Player.Animations
end

if RunService:IsServer() then
	function WeaponService:_giveWeapon(character, weaponName)
		local newWeapon = self._weapons[weaponName]:Clone()
		newWeapon.Parent = character
		weldTool(newWeapon)
		local handle = getTaggedInstancesInDirectory(newWeapon, CONFIG.Keys.Tags.Handle)[1]
		local characterAttachment = character:FindFirstChild(CONFIG.Keys.ToolAttachmentName, true)
		newWeapon.PrimaryPart = handle
		newWeapon:SetPrimaryPartCFrame(characterAttachment.WorldCFrame)
		local handleWeld = Instance.new("WeldConstraint")
		handleWeld.Part1 = handle
		handleWeld.Part0 = characterAttachment.Parent
		handleWeld.Parent = handle
		for _, instance in ipairs(newWeapon:GetDescendants()) do
			if instance:IsA("BasePart") then
				instance.CanCollide = false
			end
		end
	end

	function WeaponService:_updateWeapons(instant)
		local weaponName = StoreService:getState().weapon
		for _, player in ipairs(PlayerService:getPlayers()) do
			if player.Character then
				local oldWeapon = self:_getPlayerWeapon(player)
				local oldWeaponName = oldWeapon and oldWeapon.Name
				if oldWeaponName ~= weaponName then
					if oldWeapon then
						if not instant then
							local animationTrack = playAnimation(player, self._getAnimations().Drop)
							if animationTrack then
								animationTrack.Stopped:Wait()
							end
						end
						oldWeapon:Destroy()
					end
					self.WeaponSwap:fire()
					self:_giveWeapon(player.Character, weaponName)
				end
			end
		end
	end
end

return WeaponService.new()