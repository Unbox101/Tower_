
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))










G.Init()

local keyboardInput = G.Enums.InputType.Keyboard
local mouseInput = G.Enums.InputType.Mouse
local defaultConfig = {
	keyboardControls = {
		
		--movement
		jump = {{key = Enum.KeyCode.Space, type = keyboardInput}},
		
		--interact
		primaryInteract = {{key = "1", type = mouseInput}},
		secondaryInteract = {{key = "2", type = mouseInput}},
		freeMouse = {{key = Enum.KeyCode.B, type = keyboardInput}},
		
		--combat
		attack = {{key = "1", type = mouseInput}},
		
		--guis
		inventory = {{key = Enum.KeyCode.Tab, type = keyboardInput}},
		options = {{key = Enum.KeyCode.Backquote,type = keyboardInput}},
		
		--gui movement
		primaryGuiInteract = {{key = "1", type = mouseInput}},
		
		
	}
}

game.Players.CharacterAutoLoads = false
game.Players.PlayerAdded:Connect(function(player)
	G.Functions.CreatePlayerEntity(player)
end)

game.Players.PlayerRemoving:Connect(function(player)
	print("Save on quit:",player)
	G.Functions.SavePlayer(player, G.EntityCaches.Players[player])
end)

game:BindToClose(function()
	print("Save on close")
	for i,player in pairs(game.Players:GetPlayers()) do
		G.Functions.SavePlayer(player, G.EntityCaches.Players[player])
		
		G.ProfileService.DisconnectSavePlayer(player)
	end
	
    task.wait(1)
end)

local processInterval = 0.1
local processTime = 0
G.RunService.Heartbeat:Connect(function(deltaTime)
	
	debug.profilebegin("applyTransforms")
	G.Systems.ApplyTransforms(deltaTime)
	debug.profileend()
	
	
	
	processTime += deltaTime
	
	if processTime > processInterval then
		processTime -= processInterval
		debug.profilebegin("handleReplication")
		G.Systems.HandleReplication(deltaTime)
		debug.profileend()
	end
	
end)