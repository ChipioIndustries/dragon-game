--[[
	run the following command:
	remodel run extractModels.lua
]]
local game = remodel.readPlaceFile("build.rbxl")

local ServerStorage = game:GetService("ServerStorage")

local function extractDirectory(directory, target)
	for _, model in ipairs(directory:GetChildren()) do
		remodel.writeModelFile(model, target .. model.Name .. ".rbxmx")
	end
end

extractDirectory(ServerStorage.Assets.Levels, "assets/Levels/")
extractDirectory(ServerStorage.Assets.Dragons, "assets/Dragons/")
extractDirectory(ServerStorage.Assets.Dragons, "assets/Weapons/")
