local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Soup.ConstructComponent(script.Name, {
	constructor = function(entity, tuple)
		
		if tuple.pos then
			tuple.localPos = Vector2.new(tuple.pos[1],tuple.pos[3])
			tuple.globalPos = Vector2.new(tuple.pos[2],tuple.pos[4])
		end
		if tuple.size then
			tuple.localSize = Vector2.new(tuple.size[1],tuple.size[3])
			tuple.globalSize = Vector2.new(tuple.size[2],tuple.size[4])
		end
		
		tuple.localPos = tuple.localPos or Vector2.zero
		tuple.globalPos = tuple.globalPos or Vector2.zero
		
		tuple.localSize = tuple.localSize or Vector2.zero
		tuple.globalSize = tuple.globalSize or Vector2.zero
		
		tuple.anchorPoint = tuple.anchorPoint or Vector2.zero
		
		tuple.posBoundsParent = tuple.posBoundsParent
		tuple.sizeBoundsParent = tuple.sizeBoundsParent
		
		assert(tuple.instance, "tuple.instance must not be nil!")
		
		if not tuple.mainUI then
			if tuple.parent then-- this is a quality of life feature
				tuple.posParent = tuple.parent
				tuple.sizeParent = tuple.parent
			end
			if typeof(tuple.posParent) == "Instance" and tuple.posParent:IsA("GuiBase") then-- this will be for seamless integration with non-entity based ui elements.
				tuple.posParent = {
					Frame = {
						localPos = Vector2.zero,
						globalPos = Vector2.zero,
						
						localSize = Vector2.zero,
						globalSize = tuple.posParent.AbsoluteSize
					}
				}
			else
				tuple.posParent = tuple.posParent or G.MainGuiEntity
			end
			if typeof(tuple.sizeParent) == "Instance" and tuple.sizeParent:IsA("GuiBase") then--same as above
				tuple.sizeParent = {
					Frame = {
						localPos = Vector2.zero,
						globalPos = Vector2.zero,
						
						localSize = Vector2.zero,
						globalSize = tuple.sizeParent.AbsoluteSize
					}
				}
			else
				tuple.sizeParent = tuple.sizeParent or G.MainGuiEntity
			end
			
			
		end
		G.EntityCaches.GuiEntities[tuple.instance] = entity
		return tuple
	end,
	destructor = function(entity)
		G.EntityCaches.GuiEntities[entity.FrameComponent.instance] = nil
	end
})

return false
