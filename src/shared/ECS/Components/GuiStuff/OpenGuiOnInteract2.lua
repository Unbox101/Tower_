local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.guiToOpen, "tuple.guiToOpen must not be nil")
		
		return tuple
	end
})

return false
