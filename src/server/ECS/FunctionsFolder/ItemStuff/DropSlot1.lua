local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local dropRayParams = RaycastParams.new()
dropRayParams.FilterType = Enum.RaycastFilterType.Blacklist



return function(player, clientCFrame)
	
	--local finalDropCFrame = clientCFrame
	local playerEntity = G.EntityCaches.Players[player]
	local itemEntity = playerEntity.Inventory.inventory[1]
	
	dropRayParams.FilterDescendantsInstances = G.TagService:GetTagged("RayIgnore")
	
	local rayResult = workspace:Raycast(clientCFrame.Position, clientCFrame.LookVector * 4, dropRayParams)
	if rayResult then
		clientCFrame = CFrame.lookAt(rayResult.Position, rayResult.Position + clientCFrame.LookVector)
	else
		clientCFrame = clientCFrame + clientCFrame.LookVector * 4
	end
	
	if G.Functions.DropEntity(itemEntity, clientCFrame) then
		G.RemoteCall.UpdateInventoryGuiItems(player, G.DeepKillCopyEntity(playerEntity.Inventory))
	end
end