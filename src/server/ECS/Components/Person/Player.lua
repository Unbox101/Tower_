local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.userId, "tuple.player must not be nil")
		tuple.player = game.Players:GetPlayerByUserId(tuple.userId)
		
		assert(tuple.player, "tuple.player was nil! tuple.userId's player must be in game and/or the userId must be valid!")
		G.EntityCaches.Players[tuple.player] = entity
		
		return tuple
	end,
	destructor = function(entity, tuple)
		G.EntityCaches.Players[entity.Player.player] = nil
	end
})

return false