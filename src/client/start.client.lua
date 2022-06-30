local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Init()
require(script.Parent.InstanceInterpolation)
local ImGonneNeedThisLater = "i dont even remember whutduh hell goin on. bruh whutdahhellbruh"



local UserInputToServer = function(actionName, inputState, inputObject : InputObject)
	local inputObjectTable = {
		Delta = inputObject.Delta,
		KeyCode = inputObject.KeyCode,
		Position = inputObject.Position,
		UserInputState = inputObject.UserInputState,
		UserInputType = inputObject.UserInputType
	}
	local finalActionData = {
		thee = "control",
		actionName = actionName,
		inputState = inputState,
		inputObject = inputObjectTable,
		timestamp = G.Time()
	}
	
	if actionName == "Drop" and inputObjectTable.UserInputState == Enum.UserInputState.Begin then
		G.RemoteFunctions.DropSlot1(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
	end
	
	G.TheeRemoteEvent:FireServer(finalActionData)
	--print(finalActionData)
end

G.ContextActionService:BindAction("PickUp", UserInputToServer, false, Enum.KeyCode.F)
G.ContextActionService:BindAction("Drop", UserInputToServer, false, Enum.KeyCode.Q)



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
	
	for key, itemEntity in pairs(inventoryTuple.inventory) do
		local slot = invGui:FindFirstChild(key)
		if not slot then continue end
		local viewport = slot.ViewportFrame
		for _, v in ipairs(viewport:GetChildren()) do
			v:Destroy()
		end
		local modelClone = itemEntity.Instance.instance:Clone()
		modelClone.Parent = viewport
		local _, bounds = modelClone:GetBoundingBox()
		local zoomOut = (bounds).Magnitude
		modelClone:PivotTo(CFrame.new(viewportCam.CFrame.Position + viewportCam.CFrame.LookVector * zoomOut) * CFrame.fromAxisAngle(Vector3.xAxis, math.pi / 4) * CFrame.fromAxisAngle(Vector3.yAxis, math.pi / 4))--model:GetPivot().Rotation)
	end
	
end
print(G.Functions)
--local window2 = G.Functions.Guis.MakeNewWindowInstance(MainScreenGui)

G.RunService.RenderStepped:Connect(function(deltaTime)
	
	
	
end)