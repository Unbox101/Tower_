local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
if G.IsServer then
	return G.NilFunc
end

local cursorRaycastParams = RaycastParams.new()
cursorRaycastParams.IgnoreWater = true
cursorRaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
cursorRaycastParams.FilterDescendantsInstances = G.TagService:GetTagged("Character")

local IconTable = {
	["Draggable"] = G.Textures.MouseIcons.openHand,
	["Resizable"] = G.Textures.MouseIcons.resizeDiag,
	["Clickable"] = G.Textures.MouseIcons.pointer
}
local rayResult = nil--{Instance = G.Mouse.Target}
return function()
	cursorRaycastParams.FilterDescendantsInstances = G.TagService:GetTagged("Character")
	G.Mouse.Icon = G.Textures.MouseIcons.default--set to default at beginning of frame
	
	local mousePos = G.UserInputService:GetMouseLocation()
	local mouseToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mousePos.X, mousePos.Y)
	
	--rayResult.Instance = G.Mouse.Target
	rayResult = workspace:Raycast(mouseToWorldRay.Origin, mouseToWorldRay.Direction * 500, cursorRaycastParams)
	if rayResult then
		if rayResult.Instance then--custom logic for click detector mouse icon updating. this is dumb but i dont care :trollgarlic:
			local clickDetector = rayResult.Instance:FindFirstChildWhichIsA("ClickDetector")
			if clickDetector then
				G.Mouse.Icon = G.Textures.MouseIcons.pointer
			end
		end
	end
	
	local guiObjectsInteractedWith = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousePos.X - G.GuiInset.X, mousePos.Y - G.GuiInset.Y)
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