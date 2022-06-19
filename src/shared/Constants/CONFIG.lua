local CONFIG = {
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
	}
}

return CONFIG