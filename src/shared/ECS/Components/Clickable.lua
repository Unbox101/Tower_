local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		assert(tuple.clickDetector, "tuple.clickDetector must not be nil")
		assert(tuple.distance, "tuple.distance must not be nil")
		assert(tuple.clickFunction, "tuple.clickFunction must not be nil")
		
		tuple.clickDetector.MaxActivationDistance = math.clamp(tuple.distance - 1, 0, 99999)
		tuple.clickConnection = tuple.clickDetector.MouseClick:Connect(function(player)
			if not entity.Instance then return end
			if (player.Character.HumanoidRootPart.Position - entity.Instance.instance:GetPivot().Position).Magnitude <= tuple.distance then
				tuple.clickFunction(player, entity)
			end
		end)
		
		return tuple
	end,
	destructor = function(entity)
		entity.clickConnection:Disconnect()
	end
})

return false