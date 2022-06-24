-- a backup to be used in the event of a data store outage,
-- or just a place that doesn't yet have a data store
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local StaticLiveOpsData = Llama.Dictionary.throwOnNilIndex({
	Animations = {
		Death = 9966955888;
		FireBreath = 9966952928;
		Idle = 9966954638;
		Walk = 9966951173;
		WingBeat = 9966957583;
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
		PathRefreshRate = 0.5;
		EyesightDistance = 50;
		Pathfinding = {
			AgentRadius = 6;
			AgentHeight = 5;
			AgentCanJump = false;
			WaypointSpacing = nil;
		}
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
		PathRefreshRate = 0.5;
		EyesightDistance = 50;
		AttackDistance = 16;
		SecondsPerAttack = 3;
		DamageCooldown = 1;
		Damage = 25;
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