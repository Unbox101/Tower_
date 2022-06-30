local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local performAction = function(playerEntity, actionData)
	--TODO;;;---;;;
	--print(actionData)
	--print("CompareTime = ", G.Time())
end

if G.IsServer then
	G.TheeRemoteEvent.OnServerEvent:Connect(function(player, actionData)
		if actionData.thee ~= "control" then return end
		
		performAction(G.EntityCaches.Players[player], actionData)
		
	end)
end

return performAction