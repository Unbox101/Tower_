local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(deltaTime)
	G.Query({"GuiObjectTag", "Instance"}, function(entity)
		local instance = entity.Instance.instance :: GuiObject
		if entity.Position then
			local posTuple = entity.Position
			instance.Position = UDim2.fromOffset(posTuple.pos.X, posTuple.pos.Y)
		end
		if entity.Size then
			local sizeTuple = entity.Size
			instance.Size = UDim2.fromOffset(sizeTuple.size.X, sizeTuple.size.Y)
		end
	end)
	
end