local G = {}

--basically this entire script is
--[[
	1: A list of functions G.Functions
	2: A list of functions G.Systems (dont ask xd)
	3: Soup G.Soup @Sona's 135 line simple EC without the S library that I use to create entities
	4: Components. They don't exist in this module but they exist in Soup. Also used in the creation of entities.
	5: Everything else is either a random global variable, a roblox service, or a helper function that i didn't want in G.Functions
]]

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

--Soup Imports
G.ArchSoup = require(script.Parent.ArchSoup)
G.EC = require(script.Parent.EC)
G.DefaultSoup = require(script.Parent.Soup)
G.Soup = G.DefaultSoup--require(script.Parent.EC)

--custom services
G.Enums = require(script.Parent.Enums)
G.TagService = require(script.Parent.TagService)
G.DebugDraw = require(script.Parent.DebugDraw)
G.SerializationUtility = require(script.Parent.SerializationUtility)
G.MoreMath = require(script.Parent.MoreMath)
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
G.Spaces = {}
G.Textures = {
	MouseIcons = {
		openHand = "rbxasset://textures/advCursor-openedHand.png",
		closedHand = "rbxasset://textures/advClosed-hand.png",
		resizeDiag = "rbxasset://textures/StudioUIEditor/icon_resize3.png",
		pointer = "rbxasset://textures/Cursors/KeyboardMouse/ArrowCursor.png",
		default = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png",
		drag = "rbxasset://textures/Cursors/mouseIconCameraTrack.png",
	},
	MenuStuff = {
		SettingsCogWheel = "rbxasset://textures/ui/Settings/MenuBarIcons/GameSettingsTab.png",
		Maximize = "rbxasset://textures/ui/Controls/key_single.png",
		CloseButton = "rbxasset://textures/ui/CloseButton_dn.png"
	},
	Ping = "rbxasset://textures/ui/waypoint.png",
	Search = "rbxasset://textures/ui/SearchIcon.png",
	DropDownArrow = "rbxasset://textures/ui/Settings/DropDown/DropDown.png",
	RightTriangle = "http://www.roblox.com/asset/?id=2952273043"
	
}
G.States = {
	DragginEntities = {},
	ResizinEntities = {},
	IconCapacitors = {}
}
if G.IsServer then 
	G.ServerECS = ServerFolder.ECS
	G.ReplicationFolder = game.ReplicatedStorage:FindFirstChild("ReplicationFolder") or Instance.new("Folder", game.ReplicatedStorage)
	G.ReplicationFolder.Name = "ReplicationFolder"
	--various sorted maps
	G.GlobalPlayerPosMap = MemoryStoreService:GetSortedMap("GlobalPlayerPosMap")
else
	G.ReplicationFolder = game.ReplicatedStorage:WaitForChild("ReplicationFolder",10)
	G.UserInputService = game:GetService("UserInputService")
	G.GuiService = game:GetService("GuiService")
	G.StarterGui = game:GetService("StarterGui")
	G.Mouse = game.Players.LocalPlayer:GetMouse()
	G.GuiInset = G.GuiService:GetGuiInset()
end

--ECS tables
G.Systems = {}
G.Functions = {}
G.EntityCaches = {
	Players = {},
	Unique = {},
	Serializable = {},
	Entities = {},
	Instances = {},
	GuiEntities = {}
}
G.MarkedForDelete = {}

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
G.Soup.Add = G.Soup.CreateComponent
G.Soup.Remove = G.Soup.DeleteComponent

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
	RequireComponents(G.SharedECS)
	RequireFunctions(G.SharedECS)
	RequireSystems(G.SharedECS)
	
	if G.IsServer then
		RequireComponents(G.ServerECS)
		RequireFunctions(G.ServerECS)
		RequireSystems(G.ServerECS)
		
	else
		--init base ui garbage
		G.MainScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("MainScreenGui", 60)
		
		G.MainGuiEntity = G.Soup.CreateEntity()
		G.Soup.CreateComponent(G.MainGuiEntity, "Frame", {
			mainUI = true,
			instance = G.MainScreenGui,
			size = {0, G.MainScreenGui.AbsoluteSize.X, 0, G.MainScreenGui.AbsoluteSize.Y}
			--globalSize = G.MainScreenGui.AbsoluteSize
		})
		require(SharedFolder.ClientGlobals)
	end
	G.Initialized = true
end

--global helper functions

G.ProfileCall = function(name, func, ...)
	debug.profilebegin(name)
	func(...)
	debug.profileend()
end

local call = true
--default soup query

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

--archSoup query
--[=[]]
G.Query = function(components, func)
    for _, enttiy in ipairs(G.Soup.GetCollection(components)) do
		func(enttiy)
    end
end
]=]



--EC Query
--[=[]]
G.Soup.OldOldDeleteEntity = G.Soup.DeleteEntity

G.Soup.DeleteEntity = function(entity)
	table.insert(G.MarkedForDelete, entity)
end

G.Query = function(components, func)
    for _, component in ipairs(G.Soup.Components[components[1]]) do
		local entity = G.Soup.Entities[component.EntityId]
		if not entity then continue end
		call = true
		for _,v in ipairs(components) do
			if not entity[v] then call = false break end
		end
		if call then
			func(entity)
		end
    end
	for _, entity in pairs(G.MarkedForDelete) do
		G.Soup.OldOldDeleteEntity(entity)
	end
	table.clear(G.MarkedForDelete)
end
]=]
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
	for k,v in entityIn do
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

G.ConstructInstance = function(className : string, instanceData : table)
	local instance = Instance.new(className)
	for key, value in pairs(instanceData) do
		if key == "Parent" then continue end
		local success,err = pcall(function()
			instance[key] = value
		end)
		if not success then
			warn(err)
		end
	end
	pcall(function()
		instance.Active = false
	end)
	instance.Parent = instanceData.Parent
	return instance
end

G.ConstructEntity = function(entityDataTable : table)
	local ent = G.Soup.CreateEntity()
	
	for componentName, componentData in pairs(entityDataTable) do
		G.Soup.CreateComponent(ent, componentName, componentData)
	end
	
	return ent
end

G.NilFunc = function()
	
end

return G