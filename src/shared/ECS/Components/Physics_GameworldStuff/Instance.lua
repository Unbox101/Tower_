local ServerScriptService = game:GetService("ServerScriptService")
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.instance, "tuple.instance must not be nil")
		tuple.destroyOnRemove = tuple.destroyOnRemove
		tuple.hidden = tuple.hidden
		
		return tuple
	end,
	destructor = function(entity)
		local instanceTuple = entity.Instance
		if instanceTuple.destroyOnRemove then
			print("Destroying instance connected to component")
			instanceTuple.instance:Destroy()
		end
	end
})

return false