local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(mousePos)
	local guiObjectsInteractedWith = game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousePos.X - G.GuiInset.X, mousePos.Y - G.GuiInset.Y)
	G.Query({"DeleteGuiOnMouseLeave", "GuiTransform"}, function(entity)
		if os.clock() - entity.DeleteGuiOnMouseLeave.spawnTimestamp < 0.1 then
			entity.DeleteGuiOnMouseLeave.hoveringOver = true
		else
			entity.DeleteGuiOnMouseLeave.hoveringOver = false
		end
		for _, instance in ipairs(guiObjectsInteractedWith) do
			local guiEntity = G.EntityCaches.Instances[instance]
			
			if entity == guiEntity then
				
				entity.DeleteGuiOnMouseLeave.hoveringOver = true
			end
		end
		if not entity.DeleteGuiOnMouseLeave.hoveringOver then
			G.Functions.DeleteGui(entity.DeleteGuiOnMouseLeave.deleteAdornee)
			return
		end
	end)
	
	
end