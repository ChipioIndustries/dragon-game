local RandomVector = {
	_RNG = Random.new();
}

function RandomVector:_getBidirectionalUnit()
	return self._RNG:NextNumber(-1, 1)
end

function RandomVector:get(maxVelocity)
	return Vector3.new(
		self:_getBidirectionalUnit(),
		self:_getBidirectionalUnit(),
		self:_getBidirectionalUnit()
	) * maxVelocity
end

function RandomVector:noY(maxVelocity)
	return Vector3.new(
		self:_getBidirectionalUnit(),
		0,
		self:_getBidirectionalUnit()
	) * maxVelocity
end

return RandomVector