local G = {}

--roblox services
G.TextChatService = game:GetService("TextChatService")
G.ContextActionService = game:GetService("ContextActionService")
G.CollectionService = game:GetService("CollectionService")
G.RunService = game:GetService("RunService")
G.HTTP = game:GetService("HttpService")
local MemoryStoreService = game:GetService("MemoryStoreService")

--ummmmm name? plz? TODO: needs a name
G.IsClient = G.RunService:IsClient()
G.IsServer = G.RunService:IsServer()

--folders
local SharedFolder = game.ReplicatedStorage:WaitForChild("Shared")
local ServerFolder
if G.IsServer then
	ServerFolder = game.ServerScriptService:FindFirstChild("Server")
end
G.ModelsFolder = game.ReplicatedStorage:WaitForChild("Models")

--custom services
G.Soup = require(script.Parent.Soup)
G.Enums = require(script.Parent.Enums)
G.TagService = require(script.Parent.TagService)
G.DebugDraw = require(script.Parent.DebugDraw).DrawPart
G.SerializationUtility = require(script.Parent.SerializationUtility)
if G.IsServer then
	G.ProfileService = require(ServerFolder.ProfileManager)
end

--variables
local TheeRemoteEvent = game.ReplicatedStorage:FindFirstChild("TheeRemoteEvent") or Instance.new("RemoteEvent", game.ReplicatedStorage)
TheeRemoteEvent.Name = "TheeRemoteEvent"
G.TheeRemoteEvent = TheeRemoteEvent
G.SystemChatChannel = G.TextChatService:FindFirstChild("RBXSystem", true)
G.GeneralChatChannel = G.TextChatService:FindFirstChild("RBXGeneral", true)
G.SharedECS = SharedFolder.ECS
G.ReadyClients = {}
if G.IsServer then 
	G.ServerECS = ServerFolder.ECS
	G.ReplicationFolder = game.ReplicatedStorage:FindFirstChild("ReplicationFolder") or Instance.new("Folder", game.ReplicatedStorage)
	G.ReplicationFolder.Name = "ReplicationFolder"
	--various sorted maps
	G.GlobalPlayerPosMap = MemoryStoreService:GetSortedMap("GlobalPlayerPosMap")
else
	G.ReplicationFolder = game.ReplicatedStorage:WaitForChild("ReplicationFolder",10)
end

--ECS tables
G.Systems = {}
G.Functions = {}
G.EntityCaches = {
	Players = {},
	Unique = {},
	Serializable = {},
	Entities = {}
}

--custom typeof
G.CrapTypeTable = {}
function G.BindType(tableIn : table, typeIn)
	G.CrapTypeTable[tableIn] = typeIn
end
function G.TypeOf(thing)
	if typeof(thing) == "table" then
		if thing.sType then
			return "Serialized"
		end
		local customType = G.CrapTypeTable[thing]
		if customType then
			return customType
		end
	end
	return typeof(thing)
end

--Soup Mods
G.Soup.OldCreateEntity = G.Soup.CreateEntity
G.Soup.CreateEntity = function()
	local entity = G.Soup.OldCreateEntity()
	G.CrapTypeTable[entity] = "Entity"
	G.EntityCaches.Entities[entity] = entity--necessary for serialization. or at least its the only solution i've thought of for now.
	return entity
end

G.Soup.OldDeleteEntity = G.Soup.DeleteEntity
G.Soup.DeleteEntity = function(entity, ...)
	G.CrapTypeTable[entity] = nil
	G.EntityCaches.Entities[entity] = nil
	G.Soup.OldDeleteEntity(entity, ...)
end

--ECS initialization functions
local RequireComponents = function(folder)
	for i,v in ipairs(folder.Components:GetDescendants()) do
		if not v:IsA("ModuleScript") then continue end
		require(v)
	end
end
local RequireSystems = function(folder)
	for i,v in ipairs(folder.Systems:GetDescendants()) do
		if not v:IsA("ModuleScript") then continue end
		G.Systems[v.Name] = require(v)
	end
end
local RequireFunctions = function(folder)
	for i,v in ipairs(folder.FunctionsFolder:GetDescendants()) do
		if not v:IsA("ModuleScript") then continue end
		G.Functions[v.Name] = require(v)
	end
end
--call this at the root of it all, hari satus, at the begining of the game
--defers initialization of ECS modules. only needed cuz i wanted auto require-ing of Functions,Systems,and Components
G.Initialized = false
G.Init = function()
	G.SerializationUtility.Init()
	RequireFunctions(G.SharedECS)
	RequireSystems(G.SharedECS)
	RequireComponents(G.SharedECS)
	if G.IsServer then
		RequireFunctions(G.ServerECS)
		RequireSystems(G.ServerECS)
		RequireComponents(G.ServerECS)
	end
	G.Initialized = true
end

--global helper functions
local call = true
G.Query = function(components, func)
    for _, component in ipairs(G.Soup.GetCollection(components[1])) do
		local entity = component.Entity
		call = true
		for _,v in ipairs(components) do
			if not entity[v] then call = false break end
		end
		if call then
			func(entity)
		end
    end
end

G.Spawn = function(...)
	
	local entityOut = G.Soup.CreateEntity()
	
	for i,constructorTuple in ipairs({...}) do
		G.Soup.CreateComponent(entityOut, constructorTuple.name, constructorTuple.data)
	end
	
	return entityOut
end

G.Clone = function(thing : Instance, parent : Instance?)
	local ret = thing:Clone()
	ret.Parent = parent
	return ret
end

G.Time = function()
	return workspace:GetServerTimeNow()
end

G.IfNil = function(value, ifNil)
	if value == nil then
		return ifNil
	end
	return value
end

G.DeepKillCopyEntity = function(entityIn)
	local copy = {}
	for k,v in pairs(entityIn) do
		if k == "Entity" then continue end--yup this would crash for cyclic reasons
		if k == "Stored" then continue end--yup this would crash for cyclic reasons
		if typeof(k) == "userdata" then continue end--get rid of the collectionIndex
		if typeof(v) == "table" then
			copy[k] = G.DeepKillCopyEntity(v)
		else
			copy[k] = v
		end
	end
	return copy
end

return G