local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

return function(itemEntity, cframe)
	if not itemEntity then return end
	--itemEntity = itemEntity or error("itemEntity must not be nil!")
	local instanceTuple = itemEntity.Instance
	
	--Remove item from previous inventory
	if itemEntity.Stored then
		local previousInvEnt = itemEntity.Stored.storedIn
		local previousSlot = itemEntity.Stored.slot
		previousInvEnt.Inventory.inventory[previousSlot] = false
		if cframe == nil and previousInvEnt.Transform then
			cframe = previousInvEnt.Transform.cframe + previousInvEnt.Transform.cframe.LookVector * 4-- + Vector3.new(math.random(),math.random(),math.random())
		end
		G.Soup.DeleteComponent(itemEntity, "Stored")
	end
	if cframe == nil then error("CFrame was nil while trying to drop an item!") return end
	itemEntity.Transform.cframe = cframe
	--unhide and parent to workspace
	if instanceTuple then
		local instance = instanceTuple.instance
		instanceTuple.hidden = false
		instance.Parent = workspace
		instance:PivotTo(cframe)
	end
	return true
end