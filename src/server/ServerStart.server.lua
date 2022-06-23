local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local serverServices = ServerScriptService.Services
local sharedServices = ReplicatedStorage.Services

local LiveOpsService = require(serverServices.LiveOpsService)
local PlayerService = require(sharedServices.PlayerService)
local LevelService = require(serverServices.LevelService)
local SpawnService = require(serverServices.SpawnService)

LiveOpsService:init()
LevelService:init()
SpawnService:init()
PlayerService:init()