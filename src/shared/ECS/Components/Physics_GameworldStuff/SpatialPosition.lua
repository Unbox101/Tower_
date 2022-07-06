local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		tuple.dynamic = tuple.dynamic
		tuple.space = tuple.space
		
		
		return tuple
	end
})

return false