local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(deltaTime)
	G.Query({"SpinForNoReason", "Transform"}, function(entity)
		entity.Transform.cframe *= CFrame.Angles(0, 1 * deltaTime, 0)
	end)
end