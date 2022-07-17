local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

if G.IsServer then return function() end end

return function(deltaTime)
	G.Query({"GuiTransform","Instance"}, function(entity)
		local transform = entity.GuiTransform
		
		if transform.override and transform.doOverride then
			transform.override(transform)
		end
		
		
		transform.absolutePos = transform.position
		transform.absoluteSize = transform.size
		
		--[=[]]
		if entity.Instance then
			local instance = entity.Instance.instance
			instance.Position = UDim2.fromOffset(guiTransform.position.X, guiTransform.position.Y)
			instance.Size = UDim2.fromOffset(guiTransform.size.X, guiTransform.size.Y)
		end
		]=]
		if entity.Instance then
			--print(entity.Instance.instance.Name , transform.absoluteSize)
			local instance = entity.Instance.instance
			instance.Position = UDim2.fromOffset(transform.absolutePos.X,transform.absolutePos.Y)
			instance.Size = UDim2.fromOffset(transform.absoluteSize.X,transform.absoluteSize.Y)
		end
	end)
	G.Query({"GuiTransform", "GuiLocalTransform"}, function(entity)
		local transform = entity.GuiTransform
		local localTransform = entity.GuiLocalTransform
		
		if not entity.GuiLocalTransform then
			print("this should never fire")
		end
		
		--the actual meat of the sandwich \/ \/ \/
		--[=[]]
		guiTransform.absoluteSize = Vector2.new(
			(ui.localSize.X * ui.sizeParent.Frame.instance.AbsoluteSize.X) + ui.globalSize.X,
			(ui.localSize.Y * ui.sizeParent.Frame.instance.AbsoluteSize.Y) + ui.globalSize.Y
		)
		]=]
		transform.absoluteSize = (localTransform.localSize * localTransform.parent.GuiTransform.absoluteSize) + transform.size
		transform.absolutePos = (localTransform.localPos * localTransform.parent.GuiTransform.absoluteSize) + localTransform.parent.GuiTransform.absolutePos + transform.position - (transform.absoluteSize * localTransform.anchorPoint)
		--[=[]]
		guiTransform.position = Vector2.new(
			(localPosTuple.localPos.X * ui.posParent.Frame.instance.AbsoluteSize.X) + ui.posParent.Frame.instance.AbsolutePosition.X + ui.globalPos.X - (ui.instance.AbsoluteSize.X * ui.anchorPoint.X),
			(localPosTuple.localPos.Y * ui.posParent.Frame.instance.AbsoluteSize.Y) + ui.posParent.Frame.instance.AbsolutePosition.Y + ui.globalPos.Y - (ui.instance.AbsoluteSize.Y * ui.anchorPoint.Y)
		)
		]=]
		if entity.Instance then
			local instance = entity.Instance.instance
			instance.Position = UDim2.fromOffset(transform.absolutePos.X,transform.absolutePos.Y)
			instance.Size = UDim2.fromOffset(transform.absoluteSize.X,transform.absoluteSize.Y)
		end
	end)
	
end