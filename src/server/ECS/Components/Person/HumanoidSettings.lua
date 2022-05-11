local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		tuple.totalJumps = tuple.totalJumps or 1
		tuple.currentJumps = tuple.currentJumps or tuple.totalJumps
		
		return tuple
	end
})

return false