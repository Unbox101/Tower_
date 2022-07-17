local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.lodestarId, "tuple.lodestarId must not be nil")
		
		return tuple
	end
})

return false
