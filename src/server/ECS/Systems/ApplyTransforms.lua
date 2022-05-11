local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local bulkParts = {}
local bulkCFrames = {}
local bulkMoveThisFrame = false

local ApplyTransforms = function(entity)
	if entity.Instance then
		
		local instanceTuple = entity.Instance
		local transformTuple = entity.Transform
		
		local instanceType = (instanceTuple.instance:IsA("BasePart") and 0) or (instanceTuple.instance:IsA("Model") and 1)
		
		if transformTuple.anchoredToECS == true then
			if instanceType == 0 then
				if transformTuple.cframe ~= instanceTuple.instance:GetPivot() then
					bulkParts[#bulkParts+1] = instanceTuple.instance
					bulkCFrames[#bulkCFrames+1] = transformTuple.cframe
					bulkMoveThisFrame = true
				end
			elseif instanceType == 1 then
				if transformTuple.cframe ~= instanceTuple.instance:GetPivot() then
					instanceTuple.instance:PivotTo(transformTuple.cframe)
				end
			end
		else
			if instanceType == 0 then
				transformTuple.cframe = instanceTuple.instance.CFrame
			elseif instanceType == 1 then
				transformTuple.cframe = instanceTuple.instance:GetPivot()
			end
		end
		
		
		
	end
end

return function(deltaTime)
	G.Query({"Transform"}, ApplyTransforms)
	
	if bulkMoveThisFrame then
		workspace:BulkMoveTo(bulkParts, bulkCFrames, Enum.BulkMoveMode.FireCFrameChanged)
		table.clear(bulkParts)
		table.clear(bulkCFrames)
		bulkMoveThisFrame = false
	end
	
end