-- a backup to be used in the event of a data store outage,
-- or just a place that doesn't yet have a data store
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local StaticLiveOpsData = Llama.Dictionary.throwOnNilIndex({
	Coin = {
		MaxVelocity = {
			Rotation = 5;
			Translation = 10;
		};
		SpawnPositionVariation = 8;
	};
	LiveOps = {
		RefreshRate = 5;
		Retries = 3;
		RetryDelay = 0.5;
	};
	Environment = {
		Skybox = {};
		Lighting = {};
	};
	Enemy = {
		HealthMultiplier = 100;
		PathRefreshRate = 1;
		EyesightDistance = 50;
		AttackDistance = 18;
		SecondsPerAttack = 3;
		DamageCooldown = 1;
		DamageMultiplier = 10;
		CoinMultiplier = 5;
		FireBreathCheckRate = 0.1;
		Pathfinding = {
			AgentRadius = 6;
			AgentHeight = 5;
			AgentCanJump = false;
			WaypointSpacing = nil;
		};
		Animations = {
			Death = 9966955888;
			FireBreath = 9966952928;
			Idle = 9966954638;
			Walk = 9966951173;
			WingBeat = 9966957583;
		};
		FireBreath = {
			Rate = 400;
			Speed = 50;
			Distance = 18;
		};
	};
	Player = {
		Animations = {
			Swing = 10015552104;
			Drop = 10015590832;
		}
	};
	Weapons = {
		Damage = {
			Bat = 10;
			WoodenSword = 25;
			MetalSword = 50;
			GoldenSword = 100;
		};
		SwingCooldown = 1;
	};
	Levels = {
		Archipelago = {
			Environment = {
				Skybox = {
					CelestialBodiesShown = true;
					SkyboxBk = 591058823;
					SkyboxDn = 591059876;
					SkyboxFt = 591058104;
					SkyboxLf = 591057861;
					SkyboxRt = 591057625;
					SkyboxUp = 591059642;
				};
				Lighting = {
					Brightness = 3;
					EnvironmentDiffuseScale = 1;
					EnvironmentSpecularScale = 1;
					ShadowSoftness = 0.5;
				};
			}
		}
	};
})

return StaticLiveOpsData

--[[
game:GetService("DataStoreService"):GetDataStore("LiveOps"):SetAsync("LiveOpsData", {
	Coin = {
		MaxVelocity = {
			Rotation = 5;
			Translation = 10;
		};
		SpawnPositionVariation = 8;
	};
	LiveOps = {
		RefreshRate = 5;
		Retries = 3;
		RetryDelay = 0.5;
	};
	Environment = {
		Skybox = {};
		Lighting = {};
	};
	Enemy = {
		HealthMultiplier = 100;
		PathRefreshRate = 1;
		EyesightDistance = 50;
		AttackDistance = 18;
		SecondsPerAttack = 3;
		DamageCooldown = 1;
		DamageMultiplier = 10;
		CoinMultiplier = 5;
		FireBreathCheckRate = 0.1;
		Pathfinding = {
			AgentRadius = 6;
			AgentHeight = 5;
			AgentCanJump = false;
			WaypointSpacing = nil;
		};
		Animations = {
			Death = 9966955888;
			FireBreath = 9966952928;
			Idle = 9966954638;
			Walk = 9966951173;
			WingBeat = 9966957583;
		};
		FireBreath = {
			Rate = 400;
			Speed = 50;
			Distance = 18;
		};
	};
	Player = {
		Animations = {
			Swing = 10015552104;
			Drop = 10015590832;
		}
	};
	Weapons = {
		Damage = {
			Bat = 10;
			WoodenSword = 25;
			MetalSword = 50;
			GoldenSword = 100;
		};
		SwingCooldown = 1;
	};
	Levels = {
		Archipelago = {
			Environment = {
				Skybox = {
					CelestialBodiesShown = true;
					SkyboxBk = 591058823;
					SkyboxDn = 591059876;
					SkyboxFt = 591058104;
					SkyboxLf = 591057861;
					SkyboxRt = 591057625;
					SkyboxUp = 591059642;
				};
				Lighting = {
					Brightness = 3;
					EnvironmentDiffuseScale = 1;
					EnvironmentSpecularScale = 1;
					ShadowSoftness = 0.5;
				};
			}
		}
	};
})
]]