local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local packages = ReplicatedStorage.Packages
local Remotes = require(packages.Remotes)

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local actions = ServerScriptService.Actions
local setLastSwing = require(actions.setLastSwing)
local setLastDamage = require(actions.setLastDamage)

local constants = ReplicatedStorage.Constants
local RemoteNames = require(constants.RemoteNames)

local swingRemote = Remotes:getEventAsync(RemoteNames.Swing)

local WeaponDamageService = {}
WeaponDamageService.__index = WeaponDamageService

function WeaponDamageService.new()
	local self = setmetatable({
		_swingRemoteConnection = nil;
	}, WeaponDamageService)

	return self
end

function WeaponDamageService:init()
	self._swingRemoteConnection = swingRemote.OnServerEvent:connect(function(_player)
		self:swing()
	end)
end

function WeaponDamageService:swing()
	StoreService:dispatch(setLastSwing(tick()))
end

function WeaponDamageService:tryDamage(callback)
	local state = StoreService:getState()
	if state.lastDamage < state.lastSwing then
		StoreService:dispatch(setLastDamage(tick()))
		callback()
	end
end

return WeaponDamageService.new()