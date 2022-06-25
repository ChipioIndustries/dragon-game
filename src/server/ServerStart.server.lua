local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local serverServices = ServerScriptService.Services
local sharedServices = ReplicatedStorage.Services

local LevelService = require(serverServices.LevelService)
local LiveOpsService = require(serverServices.LiveOpsService)
local LootDropService = require(serverServices.LootDropService)
local PlayerService = require(sharedServices.PlayerService)
local SpawnService = require(serverServices.SpawnService)
local WeaponService = require(sharedServices.WeaponService)
local WeaponDamageService = require(serverServices.WeaponDamageService)

LiveOpsService:init()
LevelService:init()
SpawnService:init()
WeaponService:init()
WeaponDamageService:init()
PlayerService:init()
LootDropService:init()