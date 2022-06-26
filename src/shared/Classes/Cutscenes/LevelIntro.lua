local ReplicatedStorage = game:GetService("ReplicatedStorage")

local classes = ReplicatedStorage.Classes
local Cutscene = require(classes.Cutscenes.Cutscene)

local utilities = ReplicatedStorage.Utilities
local getLevelIntroKeyframes = require(utilities.Selectors.getLevelIntroKeyframes)

local LevelIntro = setmetatable({}, Cutscene)
LevelIntro.__index = LevelIntro

function LevelIntro.new()
	local self = setmetatable(Cutscene.new(), LevelIntro)

	return self
end

function LevelIntro:_getKeyframes()
	return getLevelIntroKeyframes()
end

return LevelIntro