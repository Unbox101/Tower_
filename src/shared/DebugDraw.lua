local DebugDrawFolder = workspace:FindFirstChild("DebugDrawFolder") or Instance.new("Folder",workspace)
DebugDrawFolder.Name = "DebugDrawFolder"

local function DrawPart(tuple)
	local part = Instance.new("Part")
	part.Name = tuple.Name or "DebugPrintPart"
	part.Size = tuple.Size or Vector3.new(1,1,1)
	part.Color = tuple.Color or Color3.new(1,1,1)
	part.Shape = tuple.Shape or Enum.PartType.Block
	if tuple.Position ~= nil then
		tuple.CFrame = CFrame.new(tuple.Position)
	end
	part.CFrame = tuple.CFrame or CFrame.new()
	part.Transparency = tuple.Transparency or 0
	part.CanCollide = tuple.CanCollide or false
	part.CanTouch = tuple.CanTouch or false
	part.CanQuery = tuple.CanQuery or false
	part.Anchored = tuple.Anchored or true
	part.Parent = tuple.Parent or DebugDrawFolder
	if tuple.Destroy then
		task.delay(tuple.Destroy, function()
			part:Destroy()
		end)
	end
	return part
end

return {
	DrawPart = DrawPart
}
