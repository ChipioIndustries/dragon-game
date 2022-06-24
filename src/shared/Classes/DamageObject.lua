local Players = game:GetService("Players")

local DamageObject = {}
DamageObject.__index = DamageObject

function DamageObject.new(object, damage, cooldown)
	local self = setmetatable({
		_cooldown = cooldown;
		_damageAmount = damage;
		_touchedConnection = nil;
	}, DamageObject)

	self._touchedConnection = object.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			self._cooldown:try(function()
				self:_damage(player)
			end)
		end
	end)

	return self
end

function DamageObject:_damage(player)
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(self._damageAmount)
		end
	end
end

function DamageObject:destroy()
	self._touchedConnection:Disconnect()
end

return DamageObject