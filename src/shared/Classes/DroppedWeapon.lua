local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local sharedServices = ReplicatedStorage.Services
local StoreService = require(sharedServices.StoreService)
local WeaponService = require(sharedServices.WeaponService)

local serverServices = ServerScriptService.Services
local LootDropService = require(serverServices.LootDropService)

local utilities = ReplicatedStorage.Utilities
local clearTags = require(utilities.clearTags)
local weldTool = require(utilities.weldTool)

local actions = ServerScriptService.Actions
local setWeapon = require(actions.setWeapon)

local assets = ServerStorage.Assets
local weapons = assets.Weapons

local DroppedWeapon = {}
DroppedWeapon.__index = DroppedWeapon

function DroppedWeapon.new(weaponName, position)
	if typeof(position) == "Vector3" then
		position = CFrame.new(position)
	end
	local self = setmetatable({
		_weaponName = weaponName;
		_position = position;

		_weapon = nil;
		_triggeredConnection = nil;
	}, DroppedWeapon)

	return self
end

function DroppedWeapon:init()
	-- create weapon
	self._weapon = weapons[self._weaponName]:Clone()
	weldTool(self._weapon)
	-- make sure it won't behave like a working weapon
	clearTags(self._weapon)

	-- setup proximity prompt
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Equip sword"
	prompt.ClickablePrompt = true
	prompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
	prompt.GamepadKeyCode = Enum.KeyCode.ButtonY
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.ObjectText = ("%s - %d damage"):format(self._weaponName, 0)
	prompt.Parent = self._weapon.PrimaryPart
	self._triggeredConnection = prompt.Triggered:Connect(function(player)
		self:_collect(player)
	end)

	-- spawn weapon
	self._weapon.Parent = workspace
	self._weapon:PivotTo(self._position)
end

function DroppedWeapon:_collect(_player)
	local currentWeapon = StoreService:getState().weapon
	StoreService:dispatch(setWeapon(self._weaponName))
	WeaponService.WeaponSwap:wait()
	LootDropService:dropWeapon(currentWeapon, self._weapon.PrimaryPart.CFrame)
	self:destroy()
end

function DroppedWeapon:destroy()
	if self._triggeredConnection then
		self._triggeredConnection:Disconnect()
	end
	if self._weapon then
		self._weapon:Destroy()
	end
end

return DroppedWeapon