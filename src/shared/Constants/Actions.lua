local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local Actions = Llama.Dictionary.throwOnNilIndex({
	setLiveOpsData = "setLiveOpsData";
	incrementLevel = "incrementLevel";
	setLevel = "setLevel";
	setSpawnPosition = "setSpawnPosition";
	setWeapon = "setWeapon";
	setLastDamage = "setLastDamage";
	setLastSwing = "setLastSwing";
})

return Actions