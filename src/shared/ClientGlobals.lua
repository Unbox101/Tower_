local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local defaultRayParams = RaycastParams.new()
defaultRayParams.IgnoreWater = true
defaultRayParams.FilterType = Enum.RaycastFilterType.Blacklist
defaultRayParams.FilterDescendantsInstances = G.TagService:GetTagged("Character")

G.GetMouseHitPos = function(distance, params)
	if not params then
		params = defaultRayParams
	end
	local mousePos = G.UserInputService:GetMouseLocation()
	local mouseToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mousePos.X, mousePos.Y)
	local rayResult = workspace:Raycast(mouseToWorldRay.Origin, mouseToWorldRay.Direction * distance, params)
	
	if not rayResult then rayResult = {Position = mouseToWorldRay.Origin + mouseToWorldRay.Direction * distance} end
	
	return rayResult.Position
	
end

return false