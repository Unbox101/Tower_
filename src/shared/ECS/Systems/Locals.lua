local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(deltaTime)
	
	G.Query({"LocalWithin", "Position", "Size"}, function(entity)
		local withinTuple = entity.LocalWithin
		local posTuple = entity.Position
		local sizeTuple = entity.Size
		
		local parent = withinTuple.parent
		local parentPosTuple = parent.Position
		local parentSizeTuple = parent.Size
		
		if not parentPosTuple or not parentSizeTuple or not parent then return false end
		
		local parentSize = parentSizeTuple.size
		local parentPos = parentPosTuple.pos
		local childSize = sizeTuple.size
		local childPos = posTuple.pos
		
		
		if sizeTuple.sizeRatio == nil then
			sizeTuple.sizeRatio = Vector2.new(childSize.X / parentSize.X, childSize.Y / parentSize.Y)
		end
		if posTuple.posRatio == nil then
			posTuple.posRatio = (childPos - parentPos)/parentSize
		end
		--posTuple.pos = (sizeTuple.sizeRatio * parentSize)-- + parentPosTuple.pos
		sizeTuple.size = sizeTuple.sizeRatio * parentSize--parentSize * sizeRatio
		posTuple.pos = parentPos + parentSize * posTuple.posRatio
	end)
	
	--[=[]]
	G.Query({"LocalPos", "Position"}, function(entity)
		local localPosTuple = entity.LocalPos
		local posTuple = entity.Position
		
		local parent = localPosTuple.parent
		local parentPosTuple = parent.Position
		
		if not parentPosTuple or not parent then return false end
		
		if localPosTuple.previousParentPos == nil then
			localPosTuple.previousParentPos = Vector2.new(parentPosTuple.pos.x, parentPosTuple.pos.y)
		end
		if parentPosTuple.pos ~= localPosTuple.previousParentPos then
			
			
			local parentPos = parentPosTuple.pos
			local childPos = posTuple.pos
			local posChange = parentPosTuple.pos-localPosTuple.previousParentPos
			
			posTuple.pos = posTuple.pos + posChange
			
			localPosTuple.previousParentPos = Vector2.new(parentPosTuple.pos.x,parentPosTuple.pos.y)
		end

		
	end)
]=]
--[=[]]
	G.Query({"LocalSize", "Size"}, function(entity)
		local localSizeTuple = entity.LocalSize
		local sizeTuple = entity.Size
		
		local parent = localSizeTuple.parent
		local parentSizeTuple = parent.Size
		
		if not parentSizeTuple or not parent then return false end
		if localSizeTuple.previousParentSize == nil then
			localSizeTuple.previousParentSize = Vector2.new(parentSizeTuple.size.x, parentSizeTuple.size.y)
		end
		if parentSizeTuple.size ~= localSizeTuple.previousParentSize then
			
			
			
			local parentSize = parentSizeTuple.size
			local childSize = sizeTuple.size
			local sizeRatio = Vector2.new(childSize.x/localSizeTuple.previousParentSize.x,childSize.y/localSizeTuple.previousParentSize.y)
			
			sizeTuple.size = parentSize * sizeRatio
			localSizeTuple.previousParentSize = Vector2.new(parentSize.x,parentSize.y)
		end
		
	end)
	]=]
	--[=[]]
	Util.Query({"LocalWithin", "Position"}, function(entity)
		
		local withinTuple = entity.LocalWithin
		local posTuple = entity.Position
		
		local parent = withinTuple.parent
		local parentPosTuple = parent.Position
		local parentSizeTuple = parent.Size
		
		if not parentPosTuple or not parentSizeTuple or not parent then return false end
		if withinTuple.previousParentSize == nil then
			withinTuple.previousParentSize = Vector2.new(parentSizeTuple.size.x, parentSizeTuple.size.y)
		end
		if parentSizeTuple.size ~= withinTuple.previousParentSize then
			
			local parentSize = parentSizeTuple.size
			local childPos = posTuple.pos
			local sizeRatio = Vector2.new(childPos.x/withinTuple.previousParentSize.x,childPos.y/withinTuple.previousParentSize.y)
			
			posTuple.pos = parentPosTuple.pos + sizeRatio * parentSize
			withinTuple.previousParentSize = Vector2.new(parentSize.x,parentSize.y)
		end
		
	end)
	]=]
	
end