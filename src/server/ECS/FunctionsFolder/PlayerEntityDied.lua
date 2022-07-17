local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(playerEntity)
	local player = game.Players:GetPlayerByUserId(playerEntity.Player.userId)
	--G.Functions.SavePlayer(player, playerEntity)
	task.delay(3, function()
		player:LoadCharacter()
		G.Functions.SavePlayer(player, playerEntity)
	end)
	--G.Functions.RagdollCharacter(player.Character)
	G.Soup.DeleteComponent(playerEntity, "Character")
	G.Soup.DeleteComponent(playerEntity, "Instance")
end