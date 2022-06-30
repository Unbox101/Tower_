local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.localPos, "tuple.localPos must not be nil")
		assert(tuple.globalPos, "tuple.globalPos must not be nil")
		--assert(tuple.parent, "tuple.parent must not be nil")
		
		return tuple
	end
})

return false