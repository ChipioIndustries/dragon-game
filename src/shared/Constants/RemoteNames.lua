local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local RemoteNames = Llama.Dictionary.throwOnNilIndex({
	GetLevelLoaded = "GetLevelLoaded";
	LevelLoadFinished = "LevelLoadFinished";
	Notification = "Notification";
	Swing = "Swing";
})

return RemoteNames