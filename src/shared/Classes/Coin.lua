local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)

local actions = ServerScriptService.Actions
local incrementCoins = require(actions.incrementCoins)

local classes = ReplicatedStorage.Classes
local Trigger = require(classes.Trigger)

local assets = ServerStorage.Assets
local coinAsset = assets.Loot.Coin

local Coin = {}
Coin.__index = Coin

function Coin.new(position)
	local instance = coinAsset:Clone()
	instance.Position = position
	local self = setmetatable(Trigger.new(function(_player)
		StoreService:dispatch(incrementCoins(1))
	end, instance, true), Coin)

	return self
end

return Coin