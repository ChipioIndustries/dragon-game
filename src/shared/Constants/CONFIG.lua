local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local CONFIG = Llama.Dictionary.throwOnNilIndex({
	MinimumLiveOpsRefreshRate = 2;
	DefaultLiveOpsRetries = 10;
	DefaultLiveOpsRetryDelay = 1;
	Keys = {
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
		}
	};
	LevelOrder = {
		"Archipelago";
		"Northada";
		"CastlePlanet";
		"Volcano";
		"Hell";
	};
})

return CONFIG