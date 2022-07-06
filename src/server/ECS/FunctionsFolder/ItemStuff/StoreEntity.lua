local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local function GetOpenNumericSlot(inventoryTuple)
	for i=1,inventoryTuple.capacity do
		if inventoryTuple.inventory[i]==nil or inventoryTuple.inventory[i]==false then
			return i
		end
	end
end

return function(itemEntity, inventoryEntity, slot)--honestly this is kinda alot for picking up an entity but idk. as long as its robust then i think its fine. i mean really, there's kinda alot to do when you pick something up u kno
	--setup tuples
	local inventoryTuple = inventoryEntity.Inventory
	local instanceTuple = itemEntity.Instance
	--Checks
	if not itemEntity.Storable then return end
	if not inventoryEntity then return end
	if not inventoryTuple then return end
	if not slot then
		slot = GetOpenNumericSlot(inventoryTuple)--TODO: maybe maybe break this outa here into its own function????
	end
	
	if typeof(slot) ~= "string" and typeof(slot) ~= "number" then return end
	--if inventoryEntity.Inventory.inventory[slot] ~= nil and inventoryEntity.Inventory.inventory[slot] ~= false then return end
	
	
	if not inventoryEntity.Inventory.inventory[slot] then
		
		if itemEntity.Stored then
			if inventoryEntity == itemEntity.Stored.storedIn then
				return
			end
		end
		
		
		--hide item if necessary--TODO: break this outa here. It should be a seperate function called seperately
		if instanceTuple then
			if inventoryEntity.HideStoredItems then
				instanceTuple.hidden = true
				instanceTuple.instance.Parent = game.ReplicatedStorage
			else
				instanceTuple.hidden = false
				instanceTuple.instance.Parent = workspace
			end
		end
		
		--Remove item from previous inventory
		if itemEntity.Stored then
			local previousInv = itemEntity.Stored.storedIn
			local previousSlot = itemEntity.Stored.slot
			previousInv.Inventory.inventory[previousSlot] = nil
			G.Soup.DeleteComponent(itemEntity, "Stored")
		end
		
		--add item to new inventory
		inventoryTuple.inventory[slot] = itemEntity
		G.Soup.CreateComponent(itemEntity, "Stored", {
			storedIn = inventoryEntity,
			slot = slot
		})
		return true
	end
	
	
end