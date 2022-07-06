local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Init()
require(script.Parent.InstanceInterpolation)

local UserInputToServer = function(actionName, inputState, inputObject : InputObject)
	local inputObjectTable = {
		Delta = inputObject.Delta,
		KeyCode = inputObject.KeyCode,
		Position = inputObject.Position,
		UserInputState = inputObject.UserInputState,
		UserInputType = inputObject.UserInputType
	}
	
	if actionName == "Drop" and inputObjectTable.UserInputState == Enum.UserInputState.Begin then
		G.RemoteCall.DropAllOneAtATime(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, G.GetMouseHitPos(50))
	elseif actionName == "PickUp" and inputObjectTable.UserInputState == Enum.UserInputState.Begin then
		G.RemoteCall.PlayerPickupInstance(G.InteractInstance)
	elseif actionName == "UiInteract" and inputObjectTable.UserInputState == Enum.UserInputState.Begin then
		print("funnie left click")
		G.Functions.UIInteract()
	end
	
	return Enum.ContextActionResult.Pass
end

G.ContextActionService:BindAction("PickUp", UserInputToServer, false, Enum.KeyCode.E)
G.ContextActionService:BindAction("Drop", UserInputToServer, false, Enum.KeyCode.Q)
G.ContextActionService:BindAction("UiInteract", UserInputToServer, false, Enum.UserInputType.MouseButton1)


require(script.Parent.TempNodeTest)


local MainScreenGui : ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("MainScreenGui")

local viewportCam = Instance.new("Camera")
viewportCam.CFrame = CFrame.new()
viewportCam.Parent = game.ReplicatedFirst
viewportCam.FieldOfView = 50

local inventoryEntity = G.Soup.CreateEntity()
G.Soup.CreateComponent(inventoryEntity, "InventoryGui", {
	gui = MainScreenGui.InvFrame,
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
	
	G.Systems.ApplyUITransforms(deltaTime)
	
	debug.profilebegin("highlightInteractablesSystem")
	G.Systems.HighlightInteractablesSystem(deltaTime)
	debug.profileend()
end)


--make ui mumbo jumbo
local lodeStarUIEntity, subUiEntities = G.UIPrefabs.MakeWindow()


local AppList = G.ConstructEntity({
	Frame = {
		instance = G.ConstructInstance("Frame", {
			Parent = MainScreenGui,
			Name = "sideBar/appExplorer",
			BackgroundColor3 = Color3.fromRGB(69, 69, 69),--nice
			BorderColor3 = Color3.fromRGB(64, 64, 64),
			BorderSizePixel = 0
		}),
		size = {0.2,0,1,0},
		pos = {0,0,0,0},
		parent = subUiEntities.contentFrame
	}
})



local AppSearch = G.ConstructEntity({
	Frame = {
		instance = G.ConstructInstance("Frame", {
			Parent = MainScreenGui,
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



--[=[]]
task.spawn(function()
	while task.wait() do
		local newPos = Vector2.new(math.sin(G.Time()) * 200, math.cos(G.Time()) * 100)
		lodeStarUIEntity.Frame.globalPos = Vector2.new(newPos.X, newPos.Y)
	end
end)
]=]


G.RemoteCall.ReadyClient()