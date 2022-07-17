local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))


local allReplicatedEntities = {}

local replicatedOnClients = {
	
}


local copyEntity = function(entityIn)
	local copy = {}
	for k,v in pairs(entityIn) do
		if k == "Entity" then continue end
		if typeof(k) == "userdata" then continue end
		if typeof(v) == "table" then
			if G.EntityCaches.Entities[v] then continue end
		end
		
		copy[k] = v
		
	end
	return copy
end
--[=[]]
G.TheeRemoteEvent.OnClientEvent:Connect(function()
	
end)
]=]


game.Players.PlayerAdded:Connect(function(player)
	
end)


return function(deltaTime)
	--TODO: todo. this is not done yet
end