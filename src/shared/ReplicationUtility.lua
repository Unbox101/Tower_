local module = {}

local G
local types
local typeDict
module.Init = function()
	G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
	types = G.types
	typeDict = G.typeDict
end

local entityListReturn = {}

local SerializeFunctions = {
	CFrame = function(val)
		local cframeComponents = {val:GetComponents()}
		for i,v in ipairs(cframeComponents) do
			cframeComponents[i] = v-v%0.01--string.format("%.2f", v)--TODO: do it the string way so that floating point errors dont go burrrr
		end
		return {sType = "CFrame", data = cframeComponents}
	end,
	Vector3 = function(val)
		return {sType = "Vector3", data = {val.x, val.y, val.z}}
	end,
	Entity = function(val)
		if val.Serializable and val.Unique then
			return {sType = "Entity", data = InternalSerialize(val)}--val.Unique.uuid}
		end
	end,
	
}

local DeserializeFunctions = {
	CFrame = function(val)
		return CFrame.new(table.unpack(val))
	end,
	Vector3 = function(val)
		return Vector3.new(table.unpack(val))
	end,
	Entity = function(val)
		return val
	end
}


function InternalSerialize(entity)
	local copy = {}
	for k,v in pairs(entity) do
		
		if k == "Entity" then continue end
		if typeof(k) == "userdata" then continue end
		
		if G.TypeOf(v) == "table" then
			copy[k] = InternalSerialize(v)
		else
			copy[k] = v
			if SerializeFunctions[G.TypeOf(v)] then
				copy[k] = SerializeFunctions[G.TypeOf(v)](v)
			end
		end
		
	end
	return copy
end
--returns a json encoded string of dead, fully serialized, entities. Cframes and all.
function module.FullSerializeEntity(entityIn)
	table.clear(entityListReturn)
	table.insert(entityListReturn, InternalSerialize(entityIn))
	return G.HTTP:JSONEncode(entityListReturn)
end

function InternalDeserialize(table)
	local copy = {}
	for i,v in pairs(table) do
		
		if G.TypeOf(v) == "table" then
			copy[i] = InternalDeserialize(v)
		else
			copy[i] = v
			if G.TypeOf(v) == "Serialized" then
				if DeserializeFunctions[v.sType] then
					copy[i] = DeserializeFunctions[v.sType](v.data)
				end
			end
		end
	end
	return copy
end

--Returns a list of dead entities.
function module.FullDeserializeEntity(stringIn : string)
	if stringIn == nil then
		return G.Soup.CreateEntity()
	end
	local listOfEntitiesToCreate = G.HTTP:JSONDecode(stringIn)
	
	local newEntity
	for _,deadEntity in ipairs(listOfEntitiesToCreate) do
		newEntity = G.Soup.CreateEntity()
		for componentName,componentData in pairs(deadEntity) do
			
			--make sure the data is properly deserialized if it had special serialize instructions
			local formattedComponentData = InternalDeserialize(componentData)
			
			local success,err = pcall(function()
				G.Soup.CreateComponent(newEntity, componentName, formattedComponentData)
			end)
			if not success then
				warn("Could not Deserialize component ", componentName, ". Components that hold instances will not get deserialized properly! If this is intentional, then ignore this message.")
				--warn(err)
			end
		end
	end
	
	return newEntity 
	
end



return module