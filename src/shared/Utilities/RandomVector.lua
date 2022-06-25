local RandomVector = {
	_RNG = Random.new();
}

function RandomVector:_getBidirectionalUnit()
	return self._RNG:NextNumber(-1, 1)
end

function RandomVector:get(maxVelocity)
	return Vector3.new(
		self:getBidirectionalUnit(),
		self:getBidirectionalUnit(),
		self:getBidirectionalUnit()
	) * maxVelocity
end

return RandomVector