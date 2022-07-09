local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
if G.IsServer then
	return G.NilFunc
end

local IconTable = {
	["Draggable"] = G.Textures.MouseIcons.pointer,
	["Resizable"] = G.Textures.MouseIcons.resizeDiag
}

return function()
	local mousePos = G.UserInputService:GetMouseLocation()
	local guiObjectsInteractedWith = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousePos.X - G.GuiService:GetGuiInset().X, mousePos.Y - G.GuiService:GetGuiInset().Y)
	G.Mouse.Icon = G.Textures.MouseIcons.default
	for i, guiInstance in ipairs(guiObjectsInteractedWith) do
		
		local guiEntity = G.EntityCaches.Instances[guiInstance]
		if not guiEntity then return end
		
		for component, textureID in pairs(IconTable) do
			if guiEntity[component] then
				G.Mouse.Icon = textureID
			end
		end
		break
	end
end