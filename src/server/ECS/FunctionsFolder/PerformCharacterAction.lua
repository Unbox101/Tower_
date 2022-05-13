
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.TheeRemoteEvent.OnServerEvent:Connect(function(stuff)
	print(stuff)
	if stuff.thee == "control" then
		
	end
end)

return function(actionData)
	
end