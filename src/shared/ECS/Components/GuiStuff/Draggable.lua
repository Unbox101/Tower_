local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		--assert(tuple.adornee, "tuple.adornee must not be nil")
		tuple.adornee = tuple.adornee
		
		return tuple
	end
})

return false