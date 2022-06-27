local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local services = ReplicatedStorage.Services
local StoreService = require(services.StoreService)
local SoundService = require(services.SoundService)

local actions = ServerScriptService.Actions
local incrementCoins = require(actions.incrementCoins)

local classes = ReplicatedStorage.Classes
local Trigger = require(classes.Trigger)

local assets = ServerStorage.Assets
local coinAsset = assets.Loot.Coin

local Coin = setmetatable({}, Trigger)
Coin.__index = Coin

function Coin.new(position)
	local instance = coinAsset:Clone()
	instance.Position = position
	instance.Parent = workspace
	local self = setmetatable(Trigger.new(function(_player)
		local sound = SoundService:play(StoreService:getState().liveOpsData.Sounds.CoinCollect, instance)
		StoreService:dispatch(incrementCoins(1))
		instance.Transparency = 1
		instance.CanCollide = false
		instance.Anchored = true
		sound.Ended:Wait()
		return true
	end, instance, true), Coin)

	self:init()

	return self
end

return Coin