local function weldTool(tool)
	local handle = tool.Handle
	for _, part in ipairs(tool:GetDescendants()) do
		if part:IsA("BasePart") and part ~= handle then
			local weld = Instance.new("WeldConstraint")
			weld.Parent = handle
			weld.Part0 = handle
			weld.Part1 = part
		end
	end
end

return weldTool