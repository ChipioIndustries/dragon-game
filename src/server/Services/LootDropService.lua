local ReplicatedStorage = game:GetService("ReplicatedStorage")

local classes = ReplicatedStorage.Classes
local Coin = require(classes.Coin)

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local packages = ReplicatedStorage.Packages
local Llama = require(packages.Llama)

local constants = ReplicatedStorage.Constants
local Enums = require(constants.Enums)

local utilities = ReplicatedStorage.Utilities
local RandomVector = require(utilities.RandomVector)

local LootDropService = {}
LootDropService.__index = LootDropService

function LootDropService.new()
	local self = setmetatable({
		_lootCache = {};
		_RNG = Random.new();
	}, LootDropService)

	return self
end

function LootDropService:init()

end

function LootDropService:clear()
	for _key, loot in pairs(self._lootCache) do
		loot:destroy()
	end
	self._lootCache = {}
end

function LootDropService:_cacheLootObject(loot)
	table.insert(self._lootCache, loot)
end

function LootDropService:dropCoin(position)
	local newCoin = Coin.new(position)
	local maxVelocity = StoreService:getState().liveOpsData.Coin.MaxVelocity
	local mass = newCoin._instance.AssemblyMass
	-- newCoin._instance:ApplyImpulse(RandomVector:get(maxVelocity.Translation) * mass)
	newCoin._instance:ApplyAngularImpulse(RandomVector:get(maxVelocity.Rotation) * mass)
	self:_cacheLootObject(newCoin)
end

function LootDropService:dropWeapon(weaponName, position)

end

function LootDropService:randomDrop(position, coinCount)
	coinCount = coinCount or 5
	local randomWeaponName = Llama.Dictionary.keys(Enums.Weapon)[self._RNG:NextInteger(1, Llama.Dictionary.count(Enums.Weapon))]
	self:dropWeapon(randomWeaponName, position)
	for i = 1, coinCount do
		local coinPosition = position + RandomVector:noY(StoreService:getState().liveOpsData.Coin.SpawnPositionVariation)
		self:dropCoin(coinPosition)
	end
end

return LootDropService.new()