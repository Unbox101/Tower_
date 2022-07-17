local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local States = {
	DragginEntities = {}
}

local MouseButton1Down = function()
	local mousePos = UserInputService:GetMouseLocation()
	local guiObjectsInteractedWith = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousePos.X - G.GuiInset.X, mousePos.Y - G.GuiInset.Y)
	for i, guiInstance in ipairs(guiObjectsInteractedWith) do
		local guiEntity = G.EntityCaches.Instances[guiInstance]--This is essentially a conversion from an instance to an entity
		if not guiEntity then return end
		
		--handle draggables
		if guiEntity.Draggable and not States.DragginEntities[guiEntity] then
			local offsetGarbage = guiEntity.GuiTransform.position
			if guiEntity.Draggable.adornee then
				offsetGarbage = guiEntity.Draggable.adornee.GuiTransform.position
			end
			guiEntity.Draggable.dragStart = mousePos - offsetGarbage
			States.DragginEntities[guiEntity] = true
			break
		end
		
	end
end

local EveryHeartbeat = function()
	local mousePos = UserInputService:GetMouseLocation()
	for entity,_ in pairs(States.DragginEntities) do
		if entity.Draggable.adornee then
			entity.Draggable.adornee.GuiTransform.position = mousePos - entity.Draggable.dragStart
		else
			entity.GuiTransform.position = mousePos - entity.Draggable.dragStart
		end
	end
end

local MouseButton1Up = function()
	table.clear(States.DragginEntities)
end