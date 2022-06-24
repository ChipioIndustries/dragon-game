local Cooldown = {}
Cooldown.__index = Cooldown

function Cooldown.new(duration)
	local self = setmetatable({
		_duration = duration;
		_lastEvent = 0;
	}, Cooldown)

	return self
end

function Cooldown:setDuration(duration)
	self._duration = duration
end

function Cooldown:try(callback)
	if tick() - self._lastEvent > self._duration then
		self._lastEvent = tick()
		return callback()
	end
end

return Cooldown