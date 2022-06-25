local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local services = ReplicatedStorage.Services
local PlayerService = require(services.PlayerService)
local StoreService = require(services.StoreService)

local constants = ReplicatedStorage.Constants
local CONFIG = require(constants.CONFIG)

local classes = ReplicatedStorage.Classes
local Cooldown = require(classes.Cooldown)

local utilities = ReplicatedStorage.Utilities
local getTaggedInstancesInDirectory = require(utilities.Selectors.getTaggedInstancesInDirectory)
local weldTool = require(utilities.weldTool)
local playAnimation = require(utilities.playAnimation)

local WeaponService = {}
WeaponService.__index = WeaponService

function WeaponService.new()
	local self = setmetatable({
		-- server
		_storeChangedConnection = nil;
		_playerAddedConnection = nil;
		_weapons = nil;
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
		self._storeChangedConnection = StoreService:getValueChangedSignal("weapon"):connect(function(newValue, oldValue)
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
	elseif RunService:IsClient() then
		self._player = Players.LocalPlayer
		self._swingCooldown = Cooldown.new(StoreService:getState().liveOpsData.Weapons.SwingCooldown)
		self._userInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					game:GetService("CollectionService"):AddTag(self:_getPlayerWeapon(self._player).Handle, "YEEHAW")
					self._swingCooldown:try(function()
						playAnimation(self._player, self._getAnimations().Swing)
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
		local handleWeld = Instance.new("WeldConstraint", handle)
		handleWeld.Part1 = handle
		handleWeld.Part0 = characterAttachment.Parent
		task.spawn(function()
			while task.wait(0.5) do
				print(game:GetService("CollectionService"):HasTag(handle, "YEEHAW"))
			end
		end)
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
					self:_giveWeapon(player.Character, weaponName)
				end
			end
		end
	end
end

return WeaponService.new()