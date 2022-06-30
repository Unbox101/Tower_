
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Init()

--load new players (other wise known as HARI START or the beginning of everything)
game.Players.CharacterAutoLoads = false
game.Players.PlayerAdded:Connect(function(player)
	
	local testTable = {}
	testTable[1] = "bagingule"
	testTable["hand"] = "sword haha"
	
	--G.RemoteFunctions.PrintTestNumber(player, testTable)
	
	
	G.Functions.CreatePlayerEntity(player)
	local playerEntity = G.EntityCaches.Players[player]
	G.RemoteCall.UpdateInventoryGuiSlots(player, G.DeepKillCopyEntity(playerEntity.Inventory))
end)

--save on quit
game.Players.PlayerRemoving:Connect(function(player)
	G.Functions.SavePlayer(player, G.EntityCaches.Players[player])
end)

--save on close
game:BindToClose(function()
	for i,player in pairs(game.Players:GetPlayers()) do
		G.Functions.SavePlayer(player, G.EntityCaches.Players[player])
	end
end)

--run systems
local processInterval = 0.1
local processTime = 0
G.RunService.Heartbeat:Connect(function(deltaTime)
	debug.profilebegin("applyTransforms")
	G.Systems.ApplyTransforms(deltaTime)
	debug.profileend()
	
	debug.profilebegin("spinForNoReason")
	G.Systems.SpinForNoReasonSystem(deltaTime)
	debug.profileend()
	
	processTime += deltaTime
	
	if processTime > processInterval then
		processTime -= processInterval
		debug.profilebegin("handleReplication")
		G.Systems.HandleReplication(deltaTime)
		debug.profileend()
	end
	
end)