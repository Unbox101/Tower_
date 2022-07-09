local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
if G.IsServer then return G.NilFunc end

return function()
	for entity,_ in pairs(G.States.DragginEntities) do
		G.States.DragginEntities[entity] = nil
	end
	for entity,_ in pairs(G.States.ResizinEntities) do
		G.States.ResizinEntities[entity] = nil
	end
end