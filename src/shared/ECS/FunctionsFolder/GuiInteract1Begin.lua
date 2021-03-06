local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function()
	local mousePos = G.UserInputService:GetMouseLocation()
	local guiObjectsInteractedWith = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousePos.X - G.GuiInset.X, mousePos.Y - G.GuiInset.Y)
	for i, guiInstance in ipairs(guiObjectsInteractedWith) do
		local guiEntity = G.EntityCaches.Instances[guiInstance]
		if not guiEntity then return end--just checking if the gui instance has an entity attached to it
		
		--handle clickin
		if guiEntity.GuiClickable then
			guiEntity.GuiClickable.func()
		end
		
		if guiEntity.OpenAnotherGuiOnInteract then
			G.OpenGui(guiEntity.OpenAnotherGuiOnInteract.guiToOpen)
		end
		
		
		--handle draggables
		if guiEntity.Draggable and not G.States.DragginEntities[guiEntity] then
			local offsetGarbage = guiEntity.GuiTransform.position
			if guiEntity.Draggable.adornee then
				offsetGarbage = guiEntity.Draggable.adornee.GuiTransform.position
			end
			guiEntity.Draggable.dragStart = mousePos - offsetGarbage
			G.States.DragginEntities[guiEntity] = true
			break
		end
		
		--handle resizeables
		if guiEntity.Resizable and not G.States.ResizinEntities[guiEntity] then
			local offsetGarbage = guiEntity.GuiTransform.size
			if guiEntity.Resizable.adornee then
				offsetGarbage = guiEntity.Resizable.adornee.GuiTransform.size * Vector2.new(1,1)
			end
			
			guiEntity.Resizable.resizeStart = mousePos - offsetGarbage
			G.States.ResizinEntities[guiEntity] = true
			break
		end
		
	end
end