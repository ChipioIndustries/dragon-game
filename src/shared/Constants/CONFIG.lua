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
			EnemyType = "DragonType";
			Strength = "strength";
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
			Humanoid = "Humanoid";
			DamageObject = "DamageObject";
			ParticleEmitter = "ParticleEmitter";
			Tongue = "Tongue";
			Blade = "Blade";
			Handle = "Handle";
			Weapon = "Weapon";
			StrengthDisplayTemplate = "StrengthDisplayTemplate";
		};
		ToolAttachmentName = "RightGripAttachment";
	};
	LevelOrder = {
		"Archipelago";
		"Northada";
		"CastlePlanet";
		"Volcano";
		"Hell";
	};
	Interface = {
		Defaults = {
			Button = {
				BackgroundColor = Color3.fromRGB(0, 120, 180);
				Font = Enum.Font.GothamBlack;
				TextColor = Color3.new(1, 1, 1);
			};
			Corner = {
				Radius = UDim.new(0, 8);
			};
		};
	};
	DefaultSpawnPosition = CFrame.new(0, 0, 0);
})

return CONFIG