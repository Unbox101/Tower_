local CollectionService = game:GetService("CollectionService")
local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local bulkParts = {}
local bulkCFrames = {}
local models = {}

local mainParts = {}
local cloneParts = {}
local previousCFrames = {}
local motionVectors = {}

local instanceAdded = function(instance)
	if instance:IsA("BasePart") then
		mainParts[instance] = instance
		local clone = instance:Clone()
		CollectionService:RemoveTag(clone, "Interpolate")
		instance.Transparency = 1
		cloneParts[instance] = clone
		clone.CanCollide = false
		clone.CanTouch = false
		clone.Parent = instance.Parent
	end
end
local instanceRemoved = function(instance)
	if instance:IsA("BasePart") then
		mainParts[instance] = nil
		cloneParts[instance]:Destroy()
		instance.Transparency = 0
	end
end

G.RunService.RenderStepped:Connect(function(deltaTime)
	for i,mainPart in pairs(mainParts) do
		
		if previousCFrames[mainPart] then
			local motionVectorOffset = motionVectors[mainPart] or Vector3.zero--makes cloned part stick a little bit closer to the real part. (doesnt account for rotation tho. idk how on earth to do that)
			cloneParts[mainPart].CFrame = cloneParts[mainPart].CFrame:Lerp(mainPart.CFrame + motionVectorOffset, deltaTime)
		end
		
		if previousCFrames[mainPart] ~= mainPart.CFrame then
			if previousCFrames[mainPart] then
				motionVectors[mainPart] = (mainPart.Position - previousCFrames[mainPart].Position)
			end
			previousCFrames[mainPart] = mainPart.CFrame
		end
	end
end)



G.CollectionService:GetInstanceRemovedSignal("Interpolate"):Connect(function(instance)
	instanceRemoved(instance)
end)

G.CollectionService:GetInstanceAddedSignal("Interpolate"):Connect(function(instance)
	instanceAdded(instance)
end)

for i,v in pairs(G.CollectionService:GetTagged("Interpolate")) do
	instanceAdded(v)
end

return true