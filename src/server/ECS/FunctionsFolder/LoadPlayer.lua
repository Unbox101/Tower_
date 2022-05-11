local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
local Soup = G.Soup

local ResurrectEntity = function(table)
	local aliveEntity = table
	if table.Serializable then
		local aliveEntity = G.Soup.CreateEntity()
	end
	for k,v in pairs(table) do
		if typeof(v) == "table" then
			if v.Serializable then
				
			end
		end
		print(k," : ",v)
	end
	return aliveEntity
end

return function(player : Player)
	if G.ProfileService then
		local profile = G.ProfileService.GetPlayerProfileAsync(player)
		
		local deadEntity = G.ReplicationUtil.DeserializeEntity(G.HTTP:JSONDecode(profile.Data.PlayerEntity))
		
	end
end