local ReplicatedStorage = game:GetService("ReplicatedStorage")

local services = ReplicatedStorage.Services
local PlayerService = require(services.PlayerService)

PlayerService:init()