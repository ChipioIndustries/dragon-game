local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)

local sharedReducers = script

local reducers = {}

local function addReducers(path)
	for _, file in ipairs(path:GetChildren()) do
		reducers[file.Name] = require(file)
	end
end

addReducers(sharedReducers)

return Rodux.combineReducers(reducers)