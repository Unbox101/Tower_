local module = {}
module.__index = module

local CollectionService = game:GetService("CollectionService")

local TaggedTables = {}
local TagConnections = {}



local StartTracking = function(tag : string)
	TaggedTables[tag] = CollectionService:GetTagged(tag)
	TagConnections[tag] = {}
	
	TagConnections[tag].InstanceAddedSignal = CollectionService:GetInstanceAddedSignal(tag)
	TagConnections[tag].InstanceRemovedSignal = CollectionService:GetInstanceRemovedSignal(tag)
	
	TagConnections[tag].InstanceAddedSignal:Connect(function(instance)
		--table.insert(TaggedTables[tag], instance)
		TaggedTables[tag][#TaggedTables[tag]+1] = instance --better than table.insert or so i've heard >->
	end)
	TagConnections[tag].InstanceRemovedSignal:Connect(function(instance)
		local findSpot = table.find(TaggedTables[tag], instance)
		if findSpot then
			table.remove(TaggedTables[tag],findSpot)
		end
	end)
	
end

local StopTracking = function(tag : string)
	TaggedTables[tag] = nil
	TagConnections[tag].InstanceAddedSignal:Disconnect()
	TagConnections[tag].InstanceRemovedSignal:Disconnect()
end

module.GetTagged = function(_, tag : string)
	if TaggedTables[tag] == nil then
		StartTracking(tag)
	end
	return TaggedTables[tag]
end

module.AddTag = function(_, instance : Instance, tag : string)
	if TaggedTables[tag] == nil then
		StartTracking(tag)
	end
	CollectionService:AddTag(instance, tag)
end

module.RemoveTag = function(_, instance : Instance, tag : string)
	CollectionService:RemoveTag(instance, tag)
end



return module