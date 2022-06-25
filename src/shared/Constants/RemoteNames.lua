local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local RemoteNames = Llama.Dictionary.throwOnNilIndex({
	Swing = "Swing";
})

return RemoteNames