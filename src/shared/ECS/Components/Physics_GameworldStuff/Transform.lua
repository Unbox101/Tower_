local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.cframe, "tuple.cframe must not be nil")
		
		tuple.anchoredToECS = G.IfNil(tuple.anchoredToECS, true)
		
		return tuple
	end
})

return false