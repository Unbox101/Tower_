local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		if entity.Instance then
			G.TagService:AddTag(entity.Instance.instance, "Storable")
		end
		return tuple
	end
})

return false