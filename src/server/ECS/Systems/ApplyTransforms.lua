local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local bulkParts = {}
local bulkCFrames = {}
local bulkMoveThisFrame = false

local ApplyTransforms = function(entity)
	--if entity.Instance then
		local instanceTuple = entity.Instance
		local transformTuple = entity.Transform
		
		--check if hidden. (As of June 6, 2022 this is only used when storing items in an inventory with the HideStoredItems tag. See CTRL+P "StoreEntity")
		if instanceTuple.hidden == true then return end
		
		local instanceType = (instanceTuple.instance:IsA("BasePart") and 0) or (instanceTuple.instance:IsA("Model") and 1)
		
		if transformTuple.anchoredToECS then
			if instanceType == 0 then
				if transformTuple.cframe ~= instanceTuple.instance.CFrame then
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
		
		
		
	--end
end


return function(deltaTime)
	G.Query({"Transform", "Instance"}, ApplyTransforms)
	--[=[]]
	for _, Entity in ipairs(G.Soup.GetCollection({"Transform"})) do
		if Entity.Instance then
			ApplyTransforms(Entity)
		end
	end
	]=]
	
	if bulkMoveThisFrame then
		workspace:BulkMoveTo(bulkParts, bulkCFrames, Enum.BulkMoveMode.FireCFrameChanged)
		table.clear(bulkParts)
		table.clear(bulkCFrames)
		bulkMoveThisFrame = false
	end
	
end