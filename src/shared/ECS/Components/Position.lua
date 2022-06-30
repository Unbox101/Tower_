local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		tuple.pos = tuple.pos or Vector2.new()
		
		return tuple
	end
})

return false