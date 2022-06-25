local function playAnimation(player, animationId)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local animator = player.Character.Humanoid:FindFirstChild("Animator")
		if animator then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://" .. tostring(animationId)
			local animationTrack = animator:LoadAnimation(animation)
			animationTrack:Play()
			return animationTrack
		end
	end
	return nil
end

return playAnimation