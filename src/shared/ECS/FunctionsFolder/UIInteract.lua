local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

if G.IsServer then return G.NilFunc end

return function()
	local mousePos = G.UserInputService:GetMouseLocation()
	local guiObjectsInteractedWith = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousePos.X - G.GuiService:GetGuiInset().X, mousePos.Y - G.GuiService:GetGuiInset().Y)
	
	for i, guiInstance in ipairs(guiObjectsInteractedWith) do
		local guiEntity = G.EntityCaches.GuiEntities[guiInstance]
		
		print(guiEntity)
		
	end
end