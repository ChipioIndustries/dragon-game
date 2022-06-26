local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local InterfaceService = require(services.InterfaceService)
local PlayerService = require(services.PlayerService)
local WeaponService = require(services.WeaponService)

WeaponService:init()
PlayerService:init()
InterfaceService:init()