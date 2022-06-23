local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local CONFIG = Llama.Dictionary.throwOnNilIndex({
	LiveOps = {
		MinimumRefreshRate = 2;
		DefaultRetries = 10;
		DefaultRetryDelay = 1;
	};
	Keys = {
		Attributes = {
			EnemyType = "DragonType"
		};
		DataStore = {
			LiveOps = {
				StoreName = "LiveOps";
				StoreKey = "LiveOpsData";
			}
		};
		LiveOps = {
			RefreshRate = "LiveOpsRefreshRate";
			Retries = "LiveOpsRetries";
			RetryDelay = "LiveOpsRetryDelay";
		};
		Tags = {
			EnemySpawn = "EnemySpawn";
			LevelEnd = "LevelEnd";
			PlayerSpawn = "PlayerSpawn";
			EnemyRoot = "EnemyRoot";
			Animator = "Animator";
		};
	};
	LevelOrder = {
		"Archipelago";
		"Northada";
		"CastlePlanet";
		"Volcano";
		"Hell";
	};
	DefaultSpawnPosition = CFrame.new(0, 0, 0);
})

return CONFIG