local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.mouseLeaveAdornee, "tuple.mouseLeaveAdornee must not be nil")
		assert(tuple.deleteAdornee, "tuple.deleteAdornee must not be nil")
		
		return tuple
	end
})

return false
