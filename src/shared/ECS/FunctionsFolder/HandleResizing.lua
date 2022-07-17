local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
if G.IsServer then return G.NilFunc end

return function(mousePos)
	
	for entity,_ in pairs(G.States.ResizinEntities) do
		G.Mouse.Icon = G.Textures.MouseIcons.resizeDiag
		if not entity.Resizable then return end
		if entity.Resizable.adornee then
			entity.Resizable.adornee.GuiTransform.size = mousePos - entity.Resizable.resizeStart
		else
			entity.GuiTransform.size = mousePos - entity.Resizable.resizeStart
		end
		
	end
end