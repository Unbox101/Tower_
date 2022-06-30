local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(player, entity)
	if not player then return end
	local playerEntity = G.EntityCaches.Players[player]
	if G.Functions.StoreEntity(entity, playerEntity, nil) then
		
		G.RemoteCall.UpdateInventoryGuiItems(player, G.DeepKillCopyEntity(playerEntity.Inventory))
		--G.RemoteFunctions.VisuallyStoreEntity(player, entity.Instance.instance, nil)
	end
end