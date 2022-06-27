-- a backup to be used in the event of a data store outage,
-- or just a place that doesn't yet have a data store
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Llama = require(ReplicatedStorage.Packages.Llama)

local StaticLiveOpsData = Llama.Dictionary.throwOnNilIndex({
	Sounds = {
		Sword = {
			Swing = 8680211166;
			Hit = 7171761940;
		};
		Enemy = {
			FireBreath = 6371871210;
		};
		CoinCollect = 3612595830;
	};
	Coin = {
		MaxVelocity = {
			Rotation = 5;
			Translation = 10;
		};
		SpawnPositionVariation = 8;
	};
	Cutscene = {
		easingDirection = Enum.EasingDirection.InOut.Name;
		easingStyle = Enum.EasingStyle.Sine.Name;
		studsPerSecond = 40;
		deathHeight = 20;
	};
	LiveOps = {
		RefreshRate = 5;
		Retries = 3;
		RetryDelay = 0.5;
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
	Notifications = {
		Died = "YOU DIED";
		DefeatAllEnemies = "DEFEAT ALL ENEMIES TO CONTINUE";
	};
	Lighting = {
		Archipelago = {};
		CastlePlanet = {
			Brightness = 10;
		};
		Hell = {
			Brightness = 0;
			OutdoorAmbient = {
				R = 165;
				G = 165;
				B = 165;
			};
		};
		Northada = {
			Ambient = {
				R = 150;
				G = 150;
				B = 150;
			};
			Brightness = 0;
		};
		Volcano = {
			Ambient = {
				R = 130;
				G = 87;
				B = 0;
			};
			Brightness = 3;
			ColorShift_Top = {
				R = 181;
				G = 248;
				B = 255;
			};
			OutdoorAmbient = {
				R = 127;
				G = 109;
				B = 87;
			};
		};
		Default = {
			Ambient = {
				R = 0,
				G = 0,
				B = 0
			};
			Brightness = 2;
			EnvironmentDiffuseScale = 1;
			EnvironmentSpecularScale = 1;
			OutdoorAmbient = {
				R = 127;
				G = 127;
				B = 127;
			};
			ShadowSoftness = 0;
		}
	};
})

return StaticLiveOpsData

--[[
game:GetService("DataStoreService"):GetDataStore("LiveOps"):SetAsync("LiveOpsData", {
	Sounds = {
		Sword = {
			Swing = 8680211166;
			Hit = 7171761940;
		};
		Enemy = {
			FireBreath = 6371871210;
		};
		CoinCollect = 3612595830;
	};
	Coin = {
		MaxVelocity = {
			Rotation = 5;
			Translation = 10;
		};
		SpawnPositionVariation = 8;
	};
	Cutscene = {
		easingDirection = Enum.EasingDirection.InOut.Name;
		easingStyle = Enum.EasingStyle.Sine.Name;
		studsPerSecond = 40;
		deathHeight = 20;
	};
	LiveOps = {
		RefreshRate = 5;
		Retries = 3;
		RetryDelay = 0.5;
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
	Notifications = {
		Died = "YOU DIED";
		DefeatAllEnemies = "DEFEAT ALL ENEMIES TO CONTINUE";
	};
	Lighting = {
		Archipelago = {};
		CastlePlanet = {
			Brightness = 10;
		};
		Hell = {
			Brightness = 0;
			OutdoorAmbient = {
				R = 165;
				G = 165;
				B = 165;
			};
		};
		Northada = {
			Ambient = {
				R = 150;
				G = 150;
				B = 150;
			};
			Brightness = 0;
		};
		Volcano = {
			Ambient = {
				R = 130;
				G = 87;
				B = 0;
			};
			Brightness = 3;
			ColorShift_Top = {
				R = 181;
				G = 248;
				B = 255;
			};
			OutdoorAmbient = {
				R = 127;
				G = 109;
				B = 87;
			};
		};
		Default = {
			Ambient = {
				R = 0,
				G = 0,
				B = 0
			};
			Brightness = 2;
			EnvironmentDiffuseScale = 1;
			EnvironmentSpecularScale = 1;
			OutdoorAmbient = {
				R = 127;
				G = 127;
				B = 127;
			};
			ShadowSoftness = 0;
		}
	};
})
]]