local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(deltaTime)
	G.Query({"GuiList"}, function(entity)
		local guiList = entity.GuiList.list
		for index, entity in ipairs(guiList) do
			if not entity.Frame then continue end
			entity.Frame.localPos = Vector2.zero
			entity.Frame.globalPos = Vector2.new(entity.Frame.globalPos.X, (index-1) * entity.Frame.instance.AbsoluteSize.Y)
		end
	end)
	
end