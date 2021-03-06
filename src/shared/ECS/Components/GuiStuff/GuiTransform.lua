local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		tuple.position = tuple.position or Vector2.zero
		tuple.size = tuple.size or Vector2.zero
		
		tuple.absolutePos = tuple.position
		tuple.absoluteSize = tuple.size
		
		return tuple
	end
})

return false