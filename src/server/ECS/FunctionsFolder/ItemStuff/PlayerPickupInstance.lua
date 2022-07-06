local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))



return function(player, instance)
	if not player then return end
	if not G.EntityCaches.Instances[instance] then return end
	local entity = G.EntityCaches.Instances[instance]
	local playerEntity = G.EntityCaches.Players[player]
	if playerEntity.Transform and entity.Transform then
		if (playerEntity.Transform.cframe.Position - entity.Transform.cframe.Position).Magnitude > 11 then
			return
		end
	end
	if G.Functions.StoreEntity(entity, playerEntity, nil) then
		
		G.RemoteCall.UpdateInventoryGuiItems(player, G.DeepKillCopyEntity(playerEntity.Inventory))
		--G.RemoteFunctions.VisuallyStoreEntity(player, entity.Instance.instance, nil)
	end
end