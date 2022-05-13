local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
local Soup = G.Soup

local currentVersion = 4

return function(player : Player)
	local profile = G.ProfileService.GetPlayerProfileAsync(player)
	
	if profile.Data.version ~= currentVersion then
		profile.Data.PlayerEntity = nil
		profile.Data.version = currentVersion
	end
	
	local justLoaded = true
	local playerEntity = G.ReplicationUtil.FullDeserializeEntity(profile.Data.PlayerEntity)
	
	task.spawn(function()
		while player do
			task.wait(5)
			G.Functions.SavePlayer(player, playerEntity)
		end
	end)
	
	Soup.CreateComponent(playerEntity, "Name", {
		name = player.DisplayName
	})
	Soup.CreateComponent(playerEntity, "Unique", {})
	Soup.CreateComponent(playerEntity, "Serializable")
	Soup.CreateComponent(playerEntity, "Transform", {
		cframe = CFrame.new(0,10,0),
		anchoredToECS = false
	})
	Soup.CreateComponent(playerEntity, "Inventory", {
		capacity = 9,
		inventory = {}
	})
	
	if #playerEntity.Inventory.inventory == 0 then
		print("no item in inv. making item")
		local testItem = G.Soup.CreateEntity()
		G.Soup.CreateComponent(testItem, "Transform", {
			cframe = CFrame.new(1,2,3)
		})
		Soup.CreateComponent(testItem, "Serializable")
		Soup.CreateComponent(testItem, "Unique", {})
		Soup.CreateComponent(testItem, "Name",{name = "test item funnie"})
		table.insert(playerEntity.Inventory.inventory, testItem)
	else
		print("test item loaded successfully!")
	end
	
	Soup.CreateComponent(playerEntity, "Replicate",{
		replicateTo = {player},
		hasAuthorityOver = {
			{component = "Humanoid", value = "currentJumps"},
			{}
		}
	})
	Soup.CreateComponent(playerEntity, "HumanoidSettings",{
		totalJumps = 2,
		currentJumps = 2
	})
	Soup.CreateComponent(playerEntity, "Player",{
		userId = player.UserId
	})
	
	player.CharacterAppearanceLoaded:Connect(function(character)
		--init stuffs
		local humanoid = character:FindFirstChild("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if justLoaded then
			justLoaded = false
			rootPart.CFrame = playerEntity.Transform.cframe
		end
		playerEntity.Transform.cframe = rootPart.CFrame
		humanoid.BreakJointsOnDeath = false
		
		
		
		--handle on died
		humanoid.Died:Connect(function()
			G.Functions.SavePlayer(player, playerEntity)
			task.delay(3, function()
				player:LoadCharacter()
			end)
			G.Functions.RagdollCharacter(character)
			Soup.DeleteComponent(playerEntity, "Character")
			Soup.DeleteComponent(playerEntity, "Instance")
			
		end)
		--make character only stuff
		Soup.CreateComponent(playerEntity, "Character", {})
		Soup.CreateComponent(playerEntity, "Instance",{
			instance = character
		})
		--save... duh doi
		G.Functions.SavePlayer(player, playerEntity)
	end)
	
	player:LoadCharacter()
end