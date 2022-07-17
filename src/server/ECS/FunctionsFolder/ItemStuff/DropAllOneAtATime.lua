local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local dropRayParams = RaycastParams.new()
dropRayParams.FilterType = Enum.RaycastFilterType.Blacklist
dropRayParams.FilterDescendantsInstances = G.TagService:GetTagged("ItemHighlightIgnore")



return function(player, clientRootPos, dropPoint)
	
	--local finalDropCFrame = clientCFrame
	local playerEntity = G.EntityCaches.Players[player]
	--local itemEntity = playerEntity.Inventory.inventory[1]
	
	dropRayParams.FilterDescendantsInstances = G.TagService:GetTagged("ItemHighlightIgnore")
	local playerPos = playerEntity.Transform.cframe.Position--server player pos
	
	
	local clientDropSpot =  workspace:Raycast(clientRootPos, (dropPoint - clientRootPos).Unit * 5, dropRayParams)
	local serverDropSpot = workspace:Raycast(playerPos, (dropPoint - playerPos).Unit * 5, dropRayParams)
	
	clientDropSpot = clientDropSpot or {Position = clientRootPos + (dropPoint - clientRootPos).Unit * 5}
	serverDropSpot = serverDropSpot or {Position = playerPos + (dropPoint - playerPos).Unit * 5}
	
	clientDropSpot = clientDropSpot.Position
	serverDropSpot = serverDropSpot.Position
	
	local vel = playerEntity.Instance.instance.HumanoidRootPart.AssemblyLinearVelocity
	local unit = vel.Unit
	if vel.X == 0 and vel.Y == 0 and vel.Z == 0 then
		unit = Vector3.zero
	end
	
	
	clientDropSpot = clientDropSpot + unit
	
	

	local clientToServerValidRay = workspace:Raycast(serverDropSpot, (clientDropSpot - serverDropSpot), dropRayParams)
	clientToServerValidRay = clientToServerValidRay or {Position =  serverDropSpot + (clientDropSpot - serverDropSpot)}
	serverDropSpot = clientToServerValidRay.Position
	
	local actuallyDroppedAnything = false
	
	for i,itemEntity in pairs(playerEntity.Inventory.inventory) do
		if itemEntity then--TODO: fix this. Related to itemEntity = false instead of nil or {an item}
			actuallyDroppedAnything = G.Functions.DropEntity(itemEntity, CFrame.new(serverDropSpot))
			break
		end
	end
	if actuallyDroppedAnything then
		G.RemoteCall.UpdateInventoryGuiItems(player, G.DeepKillCopyEntity(playerEntity.Inventory))
	end
end