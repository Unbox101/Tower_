local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		tuple.destroyOnRemove = tuple.destroyOnRemove or false
		assert(tuple.instance, "tuple.instance must not be nil")
		G.TagService:AddTag(tuple.instance, "entity")
		
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