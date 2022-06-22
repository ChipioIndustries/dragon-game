local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local Responses = Llama.Dictionary.throwOnNilIndex({
	LiveOpsService = {
		InitialDataFailed = "failed to initialize with liveops data, using static backup instead:";
		setLiveOpsDataNoData = "No live ops data provided";
	};
	LevelService = {
		InvalidLevelName = "Level %s cannot be loaded because it doesn't exist";
		InvalidLevelNameConfig = "Invalid level name in CONFIG.lua: %s"
	};
	Actions = {
		InvalidLiveOpsType = "LiveOps data must be a table, got %s";
		InvalidLevelIndex = "Level index is not valid";
		InvalidSpawnPosition = "Position must be a CFrame, got %s";
	};
	Selectors = {
		getTaggedInstancesInDirectory = {
			InvalidInstance = "Argument 1 must be an Instance, got %s";
			InvalidTag = "Argument 2 must be a string, got %s";
		}
	};
	Trigger = {
		InvalidInstance = "Argument 2 must be a BasePart, got %s"
	};
	Enemy = {
		NoEnemyRoot = "Enemy %s lacks a valid root part"
	}
})

return Responses