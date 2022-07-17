local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function()
	G.Query({"Instance", "Character", "Player"}, function(entity)
		if not entity.Instance.instance:FindFirstChild("HumanoidRootPart") then
			if entity.Character and entity.Player then
				G.Functions.PlayerEntityDied(entity)
			end
		end
	end)
end