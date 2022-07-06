local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
return function(playerhuh)
	G.ReadyClients[playerhuh] = playerhuh
end