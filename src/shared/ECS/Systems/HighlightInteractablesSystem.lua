local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local currentCamCFrame = game.Workspace.CurrentCamera.CFrame
local itemInstances = G.TagService:GetTagged("Storable")

local itemHighlightRayParams = RaycastParams.new()
itemHighlightRayParams.IgnoreWater = true
itemHighlightRayParams.FilterType = Enum.RaycastFilterType.Blacklist
itemHighlightRayParams.FilterDescendantsInstances = G.TagService:GetTagged("ItemHighlightIgnore")

local highlightInstance = Instance.new("Highlight", game.ReplicatedFirst)
highlightInstance.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlightInstance.FillColor = Color3.fromRGB(169, 169, 169)
highlightInstance.FillTransparency = 0.5

local tempGetNearestInstance = function(instanceList, point : Vector3)
	local nearestDist = 99999
	local nearestInstance = instanceList[1]
	
	for _,instance in ipairs(instanceList) do
		local nearestDistCandidate = (instance:GetPivot().Position - point).Magnitude
		if nearestDistCandidate < nearestDist then
			nearestInstance = instance
			nearestDist = nearestDistCandidate
		end
	end
	
	return nearestInstance
	
end



return function(deltaTime)
	itemHighlightRayParams.FilterDescendantsInstances = G.TagService:GetTagged("ItemHighlightIgnore")-- why is this necessary
	do--TEMP highlight items
		currentCamCFrame = game.Workspace.CurrentCamera.CFrame
		local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then return end
		local mousePos = G.UserInputService:GetMouseLocation()
		local mouseToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mousePos.X, mousePos.Y)
		local rayResult = workspace:Raycast(mouseToWorldRay.Origin, mouseToWorldRay.Direction * 100, itemHighlightRayParams)
		
		if not rayResult then rayResult = {Position = mouseToWorldRay.Origin + mouseToWorldRay.Direction * 100} end
		
		--local noLineOfSight = workspace:Raycast(humanoidRootPart.Position, (rayResult.Position - humanoidRootPart.Position) / ((rayResult.Position - humanoidRootPart.Position).Unit * 1e-5) , itemHighlightRayParams)
		
		local lineStart = currentCamCFrame.Position
		local lineEnd = rayResult.Position
		
		local nearestInstance = tempGetNearestInstance(itemInstances, lineEnd)
		
		local constrainPoint = nearestInstance:GetPivot().Position
		
		local lineConstrainedPoint = G.Functions.CollisionEverything.constrainToSegment(lineStart, lineEnd, constrainPoint)
		
		local noLineOfSight = workspace:Raycast(humanoidRootPart.Position, (constrainPoint - humanoidRootPart.Position), itemHighlightRayParams)
		
		if
			not noLineOfSight and--must be in line of sight
			(lineConstrainedPoint - constrainPoint).Magnitude < 3 and --TODO: the 3 here is the "range from the center point of an item to which you can select it for interaction". Some more work needs to be done here involving multiple selection points per item. Meaning each selection point must have some sort of adornee property pointing to the actual entity in question.
			(humanoidRootPart.Position - nearestInstance:GetPivot().Position).Magnitude < 10--must be within 10 studs of the player
		then
			highlightInstance.Adornee = nearestInstance
			G.InteractInstance = nearestInstance
		else
			highlightInstance.Adornee = nil
			G.InteractInstance = nil
		end
		
	end
end