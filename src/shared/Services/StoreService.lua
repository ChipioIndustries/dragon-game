local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local ReplicationMiddleware = require(packages.ReplicationMiddleware)
local Rodux = require(packages.Rodux)

local Reducer = require(ReplicatedStorage.Modules.Reducer)

local replicationMiddleware = ReplicationMiddleware.new()

local store = Rodux.Store.new(Reducer, {}, {
	Rodux.thunkMiddleware;
    replicationMiddleware;
	Rodux.loggerMiddleware;
})

return store