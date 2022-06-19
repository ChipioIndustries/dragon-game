-- a backup to be used in the event of a data store outage,
-- or just a place that doesn't yet have a data store

local StaticLiveOpsData = {
	LiveOpsRefreshRate = 5;
	LiveOpsRetries = 3;
	LiveOpsRetryDelay = 0.5;
}

return StaticLiveOpsData