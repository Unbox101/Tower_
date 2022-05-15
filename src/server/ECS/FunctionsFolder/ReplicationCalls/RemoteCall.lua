local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local theeRemote = G.TheeRemoteEvent

--THIS is on the backburnder for now. maaaaybe it wont even be needed?

if G.IsServer then
	local clientCanCall = {
		
	}
	theeRemote.OnServerEvent:Connect(function(thee)
		if thee.thee ~= "remoteCall" then return end
		
		
		
	end)
else
	theeRemote.OnClientEventt:Connect(function(thee)
		if thee.thee ~= "remoteCall" then return end
		
		
		
	end)
end


return {
	
}