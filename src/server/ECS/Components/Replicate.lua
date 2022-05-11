local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.replicateTo, "tuple.replicateTo must not be nil")
		assert(tuple.hasAuthorityOver, "tuple.hasAuthorityOver must not be nil")
		
		return tuple
	end
})

return false