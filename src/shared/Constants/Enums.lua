local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local Enums = Llama.Dictionary.throwOnNilIndex({
	DefaultBehavior = {
		None = "None";
		Max = "Max";
		Min = "Min";
	}
})

return Enums