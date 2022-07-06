local ServerScriptService = game:GetService("ServerScriptService")
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.instance, "tuple.instance must not be nil")
		tuple.destroyOnRemove = tuple.destroyOnRemove
		tuple.hidden = tuple.hidden
		
		G.TagService:AddTag(tuple.instance, "Instance")
		G.TagService:AddTag(tuple.instance, "Entity")
		
		if entity.Storable then
			G.TagService:AddTag(tuple.instance, "Storable")
		end
		G.EntityCaches.Instances[tuple.instance] = entity
		return tuple
	end,
	destructor = function(entity)
		local instanceTuple = entity.Instance
		if instanceTuple.destroyOnRemove then
			print("Destroying instance connected to component")
			instanceTuple.instance:Destroy()
		end
		G.EntityCaches.Instances[instanceTuple.instance] = nil
	end
})

return false