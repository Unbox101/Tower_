local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local chunkSize = 100

return function(deltaTime)--its sad but the client must handle their own spatial queries
	G.Query({"SpatialPosition", "Transform", "Instance"}, function(entity)
		local transformTuple = entity.Transform
		local spatialTuple = entity.SpatialPosition
		local instanceTuple = entity.Instance
		
		local pos = transformTuple.cframe.Position
		
		local nextChunk = Vector3.new(math.floor(pos.X/chunkSize), math.floor(pos.Y/chunkSize), math.floor(pos.Z/chunkSize))
		
		if nextChunk ~= spatialTuple.previousChunk then--update only if moved
			if spatialTuple.previousChunk then
				G.Spaces[spatialTuple.previousChunk][instanceTuple.instance] = nil
			end
			
			--move to new chunk
			if not G.Spaces[nextChunk] then
				G.Spaces[nextChunk] = {}
			end
			G.Spaces[nextChunk][instanceTuple.instance] = true
			spatialTuple.previousChunk = nextChunk
		end
		
	end)
end