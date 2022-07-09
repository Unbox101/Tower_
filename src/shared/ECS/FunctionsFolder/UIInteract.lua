local Players = game:GetService("Players")
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

if G.IsServer then return G.NilFunc end

local dragginEntities = {}
local resizinEntities = {}



G.Functions.UIInteractRelease = function()
	local mousePos = G.UserInputService:GetMouseLocation()
	
	for entity,_ in pairs(dragginEntities) do--release all currently draggin entities
		if dragginEntities[entity] then
			dragginEntities[entity] = nil
		end
	end
	
	for entity,_ in pairs(resizinEntities) do--release all currently resizin entities
		if resizinEntities[entity] then
			resizinEntities[entity] = nil
		end
	end
end

G.Functions.HandleDraggin = function()
	local mousePos = G.UserInputService:GetMouseLocation()
	--move all currently draggin entities
	for entity,_ in pairs(dragginEntities) do
		G.Mouse.Icon = G.Textures.MouseIcons.drag
		if entity.Draggable.adornee then
			entity.Draggable.adornee.GuiTransform.position = mousePos - entity.Draggable.dragStart
		else
			entity.GuiTransform.position = mousePos - entity.Draggable.dragStart
		end
		--entity oriented design :trollgarlic:
	end
	--move all currently resizin entities
	for entity,_ in pairs(resizinEntities) do
		G.Mouse.Icon = G.Textures.MouseIcons.resizeDiag
		if entity.Resizable.adornee then
			entity.Resizable.adornee.GuiTransform.size = mousePos - entity.Resizable.resizeStart
		else
			--entity.GuiTransform.size = mousePos - entity.Resizable.resizeStart
		end
		
	end
end

return function()
	
	
	
	
end