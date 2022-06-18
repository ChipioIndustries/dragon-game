local game = remodel.readPlaceFile("dev.rbxl")

local ServerStorage = game:GetService("ServerStorage")

local function extractDirectory(directory, target)
	for _, model in ipairs(directory:GetChildren()) do
		remodel.writeModelFile(model, target .. model.Name .. ".rbxmx")
	end
end

extractDirectory(ServerStorage.Levels, "assets/Levels/")
extractDirectory(ServerStorage.Dragons, "assets/Dragons/")
