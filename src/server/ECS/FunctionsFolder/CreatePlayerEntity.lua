local Players = game:GetService("Players")
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
local Soup = G.Soup

local currentVersion = 4

local function MakeServerPlayer(player : Player)
	local profile = G.ProfileService.GetPlayerProfileAsync(player)
	
	if profile.Data.version ~= currentVersion then
		profile.Data.PlayerEntity = nil
		profile.Data.version = currentVersion
	end
	
	local justLoaded = true
	local playerEntity = G.SerializationUtility.FullDeserializeEntity(profile.Data.PlayerEntity)
	
	--[=[]]
	playerEntity = G.Soup.CreateEntity()
	
	local newPoopEntity = G.Soup.CreateEntity()
	Soup.CreateComponent(newPoopEntity, "Smelly", {
		very = true
	})
	Soup.CreateComponent(newPoopEntity, "Transform", {
		cframe = CFrame.new()
	})
	Soup.CreateComponent(newPoopEntity, "Unique", {})
	Soup.CreateComponent(newPoopEntity, "Inventory", {
		capacity = 30000,
		inventory = {}
	})
	]=]
	
	
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
	Soup.CreateComponent(playerEntity, "HideStoredItems",{})
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
	
	player.CharacterAdded:Connect(function(character)
		--init stuffs
		local humanoid = character:FindFirstChild("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		for i,v in ipairs(character:GetDescendants()) do
			G.TagService:AddTag(v, "RayIgnore")
		end
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

local function MakeClientPlayer(player : Player)
	
end

return MakeServerPlayer
--[=[{
	MakeServerPlayer = MakeServerPlayer,
	MakeClientPlayer = MakeClientPlayer
}]=]