local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function()
	local mousePos = G.UserInputService:GetMouseLocation()
	local guiObjectsInteractedWith = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousePos.X - G.GuiInset.X, mousePos.Y - G.GuiInset.Y)
	
	for i, guiInstance in ipairs(guiObjectsInteractedWith) do
		local guiEntity = G.EntityCaches.Instances[guiInstance]
		if not guiEntity then return end
		
		if guiEntity.OpenGuiOnInteract2 then
			warn("OpenGui")
		end
		if guiEntity.CreateGuiOnInteract2 then
			G.GuiPrefabs[guiEntity.CreateGuiOnInteract2.guiToCreate](mousePos)
			continue
			--G.Functions.CreateGuiOnInteract2
		end
		
	end
end