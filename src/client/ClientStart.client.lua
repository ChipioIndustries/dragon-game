local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local InterfaceService = require(services.InterfaceService)
local PlayerService = require(services.PlayerService)
local WeaponService = require(services.WeaponService)
local CutsceneService = require(services.CutsceneService)
local LevelLoadedService = require(services.LevelLoadedService)
local NotificationReceiverService = require(services.NotificationReceiverService)
local SoundService = require(services.SoundService)

LevelLoadedService:init()
WeaponService:init()
PlayerService:init()
CutsceneService:init()
NotificationReceiverService:init()
InterfaceService:init()
SoundService:init()