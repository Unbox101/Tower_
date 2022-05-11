local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.startData, "tuple.startData must not be nil")
		assert(tuple.endData, "tuple.startData must not be nil")
		
		return tuple
	end
})

return false