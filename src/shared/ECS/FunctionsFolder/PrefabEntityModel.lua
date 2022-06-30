local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
return function(entity, modelName : string)
	local model = G.ModelsFolder:FindFirstChild(modelName)
	if model then
		local clone = model:Clone()
		G.Soup.CreateComponent(entity, "Instance", {
			instance = clone
		})
		clone.Parent = workspace
		if entity.Transform then
			clone:PivotTo(entity.Transform.cframe)
		end
	end
end