local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.totalJumps, "tuple.player must not be nil")
		assert(tuple.currentJumps, "tuple.currentJumps must not be nil")
		
		return tuple
	end
})

return false