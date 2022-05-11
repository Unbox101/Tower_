local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(player : Player, entity)
	if G.ProfileService then
		local profile = G.ProfileService.GetPlayerProfileAsync(player)
		
		local fullSave = ""
		local success, err = pcall(function()
			fullSave = G.ReplicationUtil.FullSerializeEntity(entity)
		end)
		
		if success and profile then
			profile.Data.PlayerEntity = fullSave
			--print(profile)
		else
			print(err)
		end
		
		
		--print("FullSave = ", fullSave)
	end
end