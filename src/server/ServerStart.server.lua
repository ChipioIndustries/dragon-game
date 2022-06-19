local ServerScriptService = game:GetService("ServerScriptService")

local Services = ServerScriptService.Services

local LiveOpsService = require(Services.LiveOpsService)
local PlayerService = require(Services.PlayerService)

LiveOpsService:init()
PlayerService:init()