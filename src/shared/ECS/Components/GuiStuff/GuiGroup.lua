local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.group, "tuple.group must not be nil")
		
		return tuple
	end,
	destructor = function(entity)
		for i,v in pairs(entity.GuiGroup.group) do
			G.Soup.DeleteEntity(v)
		end
	end
})

return false