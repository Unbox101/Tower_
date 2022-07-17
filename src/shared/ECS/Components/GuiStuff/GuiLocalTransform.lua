local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.parent, "tuple.parent must not be nil")
		tuple.anchorPoint = tuple.anchorPoint or Vector2.zero
		tuple.localPos = tuple.localPos or Vector2.zero
		tuple.localSize = tuple.localSize or Vector2.zero
		
		return tuple
	end
})

return false