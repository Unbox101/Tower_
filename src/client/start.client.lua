local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Init()
require(script.Parent.InstanceInterpolation)

local UserInputToServer = function(actionName, inputState, inputObject : InputObject)
	
	if actionName == "Drop" and inputObject.UserInputState == Enum.UserInputState.Begin then
		G.RemoteCall.DropAllOneAtATime(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, G.GetMouseHitPos(100))--WARNING: This value must at minimum be the cameras distance from the player and the ground they are looking at
	elseif actionName == "PickUp" and inputObject.UserInputState == Enum.UserInputState.Begin then
		G.RemoteCall.PlayerPickupInstance(G.InteractInstance)
	elseif actionName == "GuiInteract" and inputObject.UserInputState == Enum.UserInputState.Begin then
		G.Functions.GuiInteract()
	elseif actionName == "GuiInteract" and inputObject.UserInputState == Enum.UserInputState.End then
		G.Functions.GuiInteractRelease()
	end
	
	return Enum.ContextActionResult.Pass
end

G.ContextActionService:BindAction("PickUp", UserInputToServer, false, Enum.KeyCode.E)
G.ContextActionService:BindAction("Drop", UserInputToServer, false, Enum.KeyCode.Q)
G.ContextActionService:BindAction("GuiInteract", UserInputToServer, false, Enum.UserInputType.MouseButton1)

require(script.Parent.TempNodeTest)

--local MainScreenGui : ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("MainScreenGui")

local viewportCam = Instance.new("Camera")
viewportCam.CFrame = CFrame.new()
viewportCam.Parent = game.ReplicatedFirst
viewportCam.FieldOfView = 50

local inventoryEntity = G.Soup.CreateEntity()
G.Soup.CreateComponent(inventoryEntity, "InventoryGui", {
	gui = G.MainScreenGui.InvFrame,
	inventoryCopy = {}
})
G.Functions.UpdateInventoryGuiSlots = function(inventoryTuple)
	
	local invGuiTuple = inventoryEntity.InventoryGui
	local invGui = invGuiTuple.gui
	for _,v in ipairs(invGui:GetChildren()) do--haha destroy all the things TODO: maybe dont destroy everything if we dont need to
		if not v:IsA("UIGridLayout") then
			v:Destroy()
		end
	end
	for key, _ in pairs(inventoryTuple.inventory) do
		local slotClone = G.ModelsFolder.InventorySlotPrefab:Clone()
		slotClone.Parent = invGui
		slotClone.ViewportFrame.CurrentCamera = viewportCam
		slotClone.Name = key
	end
end

G.Functions.UpdateInventoryGuiItems = function(inventoryTuple)
	
	local invGuiTuple = inventoryEntity.InventoryGui
	local invGui = invGuiTuple.gui
	
	for i,v in ipairs(invGui:GetChildren()) do
		if not v:IsA("UIGridLayout") then
			v.ViewportFrame:ClearAllChildren()
		end
	end
	
	for key, itemEntity in pairs(inventoryTuple.inventory) do
		local slot = invGui:FindFirstChild(key)
		local viewport = slot.ViewportFrame
		if itemEntity then
			if itemEntity.Instance then
				local modelClone = itemEntity.Instance.instance:Clone()
				modelClone.Parent = viewport
				local _, bounds = modelClone:GetBoundingBox()
				local zoomOut = (bounds).Magnitude
				modelClone:PivotTo(CFrame.new(viewportCam.CFrame.Position + viewportCam.CFrame.LookVector * zoomOut) * CFrame.fromAxisAngle(Vector3.xAxis, math.pi / 4) * CFrame.fromAxisAngle(Vector3.yAxis, math.pi / 4))--model:GetPivot().Rotation)
			end
		end
		
	end
	
end



G.RunService.RenderStepped:Connect(function(deltaTime)
	local mousePos = G.UserInputService:GetMouseLocation()
	
	G.ProfileCall("UpdateCursorIcon", G.Functions.UpdateCursorIcon)
	G.ProfileCall("HighlightInteractablesSystem", G.Systems.HighlightInteractablesSystem, deltaTime)
	G.ProfileCall("ApplyUITransforms", G.Systems.ApplyUITransforms, deltaTime)
	G.ProfileCall("HandleGuiConstraints", G.Systems.HandleGuiConstraints, deltaTime)
	G.ProfileCall("HandleDragging", G.Functions.HandleDragging, mousePos)
	G.ProfileCall("HandleResizing", G.Functions.HandleResizing, mousePos)
	
end)



local LodeStarGuiGroup = G.GuiPrefabs.MakeWindow()



--[=[]]
--make ui mumbo jumbo
local lodeStarUIEntity, subUiEntities = G.UIPrefabs.MakeWindow()


local window2ElectricBoogaloo, subStuff = G.UIPrefabs.MakeWindow()

window2ElectricBoogaloo.Frame.posParent = lodeStarUIEntity
--window2ElectricBoogaloo.Frame.sizeParent = lodeStarUIEntity
window2ElectricBoogaloo.Frame.localSize = Vector2.new(0.5,0.5)

local Resizer2 = G.ConstructEntity({
	Frame = {
		instance = G.ConstructInstance("Frame", {
			Parent = G.MainScreenGui,
			Name = "Resizerrrrr",
			BackgroundColor3 = Color3.fromRGB(0, 255, 38),
			BorderColor3 = Color3.fromRGB(64, 64, 64),
			BorderSizePixel = 0
		}),
		size = {0,20,0,20},
		pos = {1,-10,1,-10},
		parent = window2ElectricBoogaloo
	},
	Resizable = {
		adornee = window2ElectricBoogaloo
	}
})

local AppList = G.ConstructEntity({
	Frame = {
		instance = G.ConstructInstance("ScrollingFrame", {
			Parent = G.MainScreenGui,
			Name = "sideBar/appExplorer",
			BackgroundColor3 = Color3.fromRGB(32, 32, 32),--nice
			BorderColor3 = Color3.fromRGB(64, 64, 64),
			BorderSizePixel = 0
		}),
		size = {0.2,0,1,0},
		pos = {0,0,0,0},
		parent = subUiEntities.contentFrame
	}
})

local appList = {}
for i=1,10 do
	table.insert(appList, G.ConstructEntity({
		Frame = {
			instance = G.ConstructInstance("TextLabel", {
				Parent = G.MainScreenGui,
				Name = "appList_"..i,
				BackgroundColor3 = Color3.fromRGB(65, 65, 65),
				BorderColor3 = Color3.fromRGB(89, 89, 89),
				BorderMode = Enum.BorderMode.Inset,
				BorderSizePixel = 1,
				Text = math.random()
			}),
			size = {1,0,0.075,0},
			pos = {0,0,0,0},
			parent = AppList
		}
	}))
end
print(appList)
local UIList = G.ConstructEntity({
	GuiList = {
		list = appList
	}
})

local AppSearch = G.ConstructEntity({
	Frame = {
		instance = G.ConstructInstance("Frame", {
			Parent = G.MainScreenGui,
			Name = "sideBarSearch",
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			BorderColor3 = Color3.fromRGB(64, 64, 64),
			BorderSizePixel = 0
		}),
		size = {1,0,0.1,0},
		pos = {0,0,0,0},
		parent = AppList
	}
})

local Resizer = G.ConstructEntity({
	Frame = {
		instance = G.ConstructInstance("Frame", {
			Parent = G.MainScreenGui,
			Name = "Resizerrrrr",
			BackgroundColor3 = Color3.fromRGB(0, 255, 38),
			BorderColor3 = Color3.fromRGB(64, 64, 64),
			BorderSizePixel = 0
		}),
		size = {0,20,0,20},
		pos = {1,-10,1,-10},
		parent = lodeStarUIEntity
	},
	Resizable = {
		adornee = lodeStarUIEntity
	}
})
]=]




--[=[]]
task.spawn(function()
	while task.wait() do
		local newPos = Vector2.new(math.sin(G.Time()) * 200, math.cos(G.Time()) * 100)
		lodeStarUIEntity.Frame.globalPos = Vector2.new(newPos.X, newPos.Y)
	end
end)
]=]


G.RemoteCall.ReadyClient()