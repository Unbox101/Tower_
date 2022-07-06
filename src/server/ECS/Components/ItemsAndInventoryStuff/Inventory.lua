local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.inventory, "tuple.inventory must not be nil")
		assert(tuple.capacity, "tuple.capacity must not be nil")
		
		--MUAHAHAHAHA IM USING A MIXED TABLE AND YOU CANT STOP MEEEEEEEEEEEEE
		local numericInventory = table.create(tuple.capacity, false)
		for key, val in pairs(tuple.inventory) do
			numericInventory[key] = false
		end
		tuple.inventory = numericInventory
		
		return tuple
	end
})

return false