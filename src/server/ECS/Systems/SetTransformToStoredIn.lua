local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(deltaTime)
	G.Query({"Stored", "Transform"}, function(entity)
		if entity.Stored.storedIn.Transform then
			entity.Transform.cframe = entity.Stored.storedIn.Transform.cframe
		end
	end)
end