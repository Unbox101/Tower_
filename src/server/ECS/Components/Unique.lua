local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		tuple.uuid = tuple.uuid or G.HTTP:GenerateGUID(false)
		G.EntityCaches.Unique[tuple.uuid] = entity
		return tuple
	end,
	destructor = function(entity)
		G.EntityCaches.Unique[entity.Unique.uuid] = nil
	end
})

return false