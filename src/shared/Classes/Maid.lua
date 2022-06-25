local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Responses = require(ReplicatedStorage.Constants.Responses)


local Maid = {}
Maid.__index = Maid

function Maid.new()
	local self = setmetatable({
		_tasks = {};
		_SUPPORTED_METHODS = {
			"Destroy";
			"destroy";
			"Disconnect";
			"disconnect";
		};
	}, Maid)

	return self
end

function Maid:_getMethod(class)
	for _, method in ipairs(self._SUPPORTED_METHODS) do
		if class[method] then
			return class[method]
		end
	end
	return nil
end

function Maid:giveTask(classOrCallback)
	local taskType = typeof(classOrCallback)
	if
		taskType == "function"
		or (
			taskType == "table"
			and self:_getMethod(classOrCallback)
		)
		or taskType == "RBXScriptConnection"
	then
		table.insert(self._tasks, classOrCallback)
	else
		error(Responses.InvalidMaidTask:format(tostring(classOrCallback)))
	end
end

function Maid:destroy()
	for _, givenTask in ipairs(self._tasks) do
		local taskType = typeof(givenTask)
		if taskType == "function" then
			givenTask()
		elseif taskType == "table" then
			local destroy = self:_getMethod(givenTask)
			if destroy then
				destroy(givenTask)
			end
		elseif taskType == "RBXScriptConnection" and givenTask.Connected then
			givenTask:Disconnect()
		end
	end
end

return Maid