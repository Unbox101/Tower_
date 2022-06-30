local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local function itemPhysics(entity)
	local cframe, size = entity.Instance.instance:GetBoundingBox()
end

return function(deltaTime)
	
	G.Query({"Storable", "Instance", "Transform"}, itemPhysics)
	
end