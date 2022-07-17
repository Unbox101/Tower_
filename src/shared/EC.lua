local GuiService = game:GetService("GuiService")
local Module = {}

--Variables
local ComponentTemplates = {}
Module.Components = {}
Module.Entities = {}

--Helper Functions
local SwapPop = function(Array, i)
	local j = #Array
	Array[j]["_Index"] = i
	Array[i]._Version += 1
	Array[j]._Version += 1
	Array[i], Array[j] = Array[j], nil
end

--EC
Module.CreateComponent = function(Entity, Name, Table)
	local Template = ComponentTemplates[Name]
	if not Template then error("Attempting to create instance of non existant"..Name.." component") end
	if Entity[Name] then return end
	
	local Component = Template.Constructor(Entity, Table)
	Component.EntityId = Entity._Index
	
	local Index = #Module.Components[Name] + 1
	Module.Components[Name][Index] = Component
	Component._Index = Index
	Component._Version = 0--for symetry
	Entity[Name] = Component
end

Module.DeleteComponent = function(Entity, Name, ...)
	local Template = ComponentTemplates[Name]
	if not Template then error("Attempting to delete instance of non existant"..Name.." component") end
	
	local Component = Entity[Name]
	if not Component then return end
	Template.Destructor(Entity, Component, ...)
	
	SwapPop(Module.Components[Name], Component["_Index"])
	Entity[Name] = nil
end

Module.ConstructComponent = function(Name, Template)
	if Name == "EntityId" then error("You cannot construct a component with the name EntityId!") end
	if Name == "_Index" then error("You cannot construct a component with the name _Index!") end
	ComponentTemplates[Name] = {
		Constructor = Template.Constructor or Template.constructor or function() return {} end,
		Destructor = Template.Destructor or Template.destructor or function() return {} end,
	}
	Module.Components[Name] = {}
end

local metaTable = {
	__add = function(a, b)
		if typeof(b[1]) ~= "string" then error("You used the + operator incorrectly!") end
		if typeof(b[2]) ~= "table" then error("You used the + operator incorrectly!") end
		Module.CreateComponent(a, b[1], b[2])
		return a
	end,
	__sub = function(a, b)
		if typeof(b) == "table" then
			b = b[1]
		end
		if typeof(b) ~= "string" then
			error("You used the + operator incorrectly!")
		end
		Module.DeleteComponent(a, b)
		return a
	end
}

Module.CreateEntity = function(meta)
	local Index = #Module.Entities + 1
	local ReturnEntity = {_Index = Index, _Version = 0}
	Module.Entities[Index] = ReturnEntity
	
	if meta then--:trollgarlic:
		setmetatable(ReturnEntity, metaTable)
	end
	
	return ReturnEntity
end

Module.DeleteEntity = function(Entity)
	for key in pairs(Entity) do
		if key == "_Index" then continue end
		if key == "_Version" then continue end
		Module.DeleteComponent(Entity, key)
	end
	SwapPop(Module.Entities, Entity._Index)
end



--Tests
--[=[]]
local TestTable = {
	{name = 1, _ComponentIndex = 1},{name = 2, _ComponentIndex = 2}, {name = 3, _ComponentIndex = 3}
}

SwapPop(TestTable, 2)
print(TestTable)
print(#TestTable)
]=]
if game:GetService("RunService"):IsServer() then
	Module.ConstructComponent("Bagingule", {
		Constructor = function(entity, tuple)
			return tuple
		end
	})
	Module.ConstructComponent("Transform", {
		Constructor = function(entity, tuple)
			tuple.cframe = tuple.cframe or CFrame.new()
			return tuple
		end
	})
	Module.ConstructComponent("Instance", {
		Constructor = function(entity, tuple)
			tuple.instance = tuple.instance
			return tuple
		end
	})
	
	local testEnt2 = Module.CreateEntity(true)
	
	testEnt2 += {"Bagingule", {
		fortniteBattlepass = "haha"
	}}
	
	local testEnt = Module.CreateEntity(true)

	testEnt += {"Bagingule",{
		fortnite = "haha"
	}}
	testEnt += {"Transform",{
		cframe = CFrame.new(1,2,3)
	}}
	testEnt -= "Bagingule"
	print(testEnt)
	testEnt += {"Instance",{
		instance = "workspace.SomePart"
	}}
	testEnt += {"Bagingule",{
		fortnite = "haha"
	}}
	print(testEnt)
	Module.DeleteEntity(testEnt2)
end

return Module