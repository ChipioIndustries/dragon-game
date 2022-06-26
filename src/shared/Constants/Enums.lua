local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local Enums = Llama.Dictionary.throwOnNilIndex({
	DefaultBehavior = {
		None = "None";
		Max = "Max";
		Min = "Min";
	};
	AttackType = {
		FireBreath = "FireBreath";
		WingBeat = "WingBeat";
	};
	Weapon = {
		Bat = "Bat";
		WoodenSword = "WoodenSword";
		MetalSword = "MetalSword";
		GoldenSword = "GoldenSword";
	};
	GUIEnvironment = {
		Menu = "Menu";
		Gameplay = "Gameplay";
	};
	Cutscene = {
		LevelIntro = "LevelIntro";
		Death = "Death";
	};
})

return Enums