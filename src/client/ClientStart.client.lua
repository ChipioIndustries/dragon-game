local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local InterfaceService = require(services.InterfaceService)
local PlayerService = require(services.PlayerService)
local WeaponService = require(services.WeaponService)
local CutsceneService = require(services.CutsceneService)
local LevelLoadedService = require(services.LevelLoadedService)

LevelLoadedService:init()
WeaponService:init()
PlayerService:init()
CutsceneService:init()
InterfaceService:init()