local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.gui, "tuple.gui must not be nil")
		assert(tuple.inventoryCopy, "tuple.inventoryCopy must not be nil")
		
		return tuple
	end
})

return false