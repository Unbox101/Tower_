local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.position, "tuple.position must not be nil")
		assert(tuple.size, "tuple.size must not be nil")
		
		return tuple
	end
})

return false