local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

if G.IsServer then return function() end end

return function(deltaTime)
	G.Query({"GuiTransform", "Instance"}, function(entity)
		local instance = entity.Instance.instance
		local guiTransform = entity.GuiTransform
		
		if guiTransform.override then
			--local success, err = pcall(function()
				guiTransform.override(guiTransform)
			--end)
			--if not success then
				--warn(err)
			--end
		end
		
		instance.Position = UDim2.fromOffset(guiTransform.position.X, guiTransform.position.Y)
		instance.Size = UDim2.fromOffset(guiTransform.size.X, guiTransform.size.Y)
		
		
		
	end)
	G.Query({"Frame"}, function(entity)
		local ui = entity.Frame
		if ui.mainUI then return end
		
		local posThing = Vector2.new(1,1)
		
		--the actual meat of the sandwich \/ \/ \/
		ui.instance.Size = UDim2.fromOffset(
			(ui.localSize.X * ui.sizeParent.Frame.instance.AbsoluteSize.X) + ui.globalSize.X,
			(ui.localSize.Y * ui.sizeParent.Frame.instance.AbsoluteSize.Y) + ui.globalSize.Y
		)
		ui.instance.Position = UDim2.fromOffset(
			(ui.localPos.X * ui.posParent.Frame.instance.AbsoluteSize.X) + ui.posParent.Frame.instance.AbsolutePosition.X + ui.globalPos.X - (ui.instance.AbsoluteSize.X * ui.anchorPoint.X),
			(ui.localPos.Y * ui.posParent.Frame.instance.AbsoluteSize.Y) + ui.posParent.Frame.instance.AbsolutePosition.Y + ui.globalPos.Y - (ui.instance.AbsoluteSize.Y * ui.anchorPoint.Y)
		)
		
	end)
	
end