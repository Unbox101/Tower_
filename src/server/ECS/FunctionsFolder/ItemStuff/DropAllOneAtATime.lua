local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local dropRayParams = RaycastParams.new()
dropRayParams.FilterType = Enum.RaycastFilterType.Blacklist
dropRayParams.FilterDescendantsInstances = G.TagService:GetTagged("Character")



return function(player, clientRootPos, dropSpot)
	
	--local finalDropCFrame = clientCFrame
	local playerEntity = G.EntityCaches.Players[player]
	--local itemEntity = playerEntity.Inventory.inventory[1]
	
	dropRayParams.FilterDescendantsInstances = G.TagService:GetTagged("RayIgnore")
	local playerPos = playerEntity.Transform.cframe.Position
	local rayStart = clientRootPos
	if (clientRootPos-playerPos).Magnitude > 2 then
		rayStart = playerPos
	end
	
	local rayResult = workspace:Raycast(rayStart, (dropSpot-rayStart).Unit * 5, dropRayParams)
	if rayResult then
		dropSpot = rayResult.Position
	else
		
		dropSpot = rayStart + (dropSpot-rayStart).Unit * 5
	end
	
	local actuallyDroppedAnything = false
	
	for i,itemEntity in pairs(playerEntity.Inventory.inventory) do
		if itemEntity then--TODO: fix this
			actuallyDroppedAnything = G.Functions.DropEntity(itemEntity, CFrame.new(dropSpot))
			break
		end
	end
	if actuallyDroppedAnything then
		G.RemoteCall.UpdateInventoryGuiItems(player, G.DeepKillCopyEntity(playerEntity.Inventory))
	end
end