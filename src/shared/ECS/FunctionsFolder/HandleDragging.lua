local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
if G.IsServer then return G.NilFunc end

return function(mousePos)
	for entity,_ in pairs(G.States.DragginEntities) do
		G.Mouse.Icon = G.Textures.MouseIcons.closedHand
		if not entity.Draggable then return end
		if entity.Draggable.adornee then
			entity.Draggable.adornee.GuiTransform.position = mousePos - entity.Draggable.dragStart
		else
			entity.GuiTransform.position = mousePos - entity.Draggable.dragStart
		end
	end
end