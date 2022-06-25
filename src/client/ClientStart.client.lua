local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local WeaponService = require(services.WeaponService)
local PlayerService = require(services.PlayerService)

WeaponService:init()
PlayerService:init()