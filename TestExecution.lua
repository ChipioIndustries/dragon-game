local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")

local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

local TestEZ = require(ReplicatedStorage.DevPackages.TestEZ)

TestEZ.TestBootstrap:run(
	{
		ReplicatedStorage,
		StarterPlayer,
		StarterPlayerScripts,
		ServerScriptService
	},
	TestEZ.Reporters.TextReporter
)