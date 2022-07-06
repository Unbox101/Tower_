local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local funcs = {
	closestPointOnLine = function(
		point1x, point1y, point1z,
		point2x, point2y, point2z,
		point3x, point3y, point3z
	)
		
	end,
	constrainToSegment = function (lineStart : Vector3, lineEnd : Vector3, constrainPoint : Vector3)
		local ba = lineEnd - lineStart
		local t = (constrainPoint - lineStart):Dot(ba) / ba:Dot(ba)
		return lineStart:Lerp(lineEnd, math.clamp(t,0,1));
	end
}
--maths test.
--[=[]]
if G.IsServer then
	local point1 = Vector3.new(-20,5,5)
	local point2 = Vector3.new(20,5,-5)
	local point3 = point1:Lerp(point2, 0.5) + Vector3.new(0,5,0)
	local point4 = Vector3.zero
	local points = {point1, point2, point3, point4}
	local pointParts = {}

	for i, point in ipairs(points) do
		local part = Instance.new("Part", workspace)
		part.Anchored = true
		part.Size = Vector3.new(3,3,3)
		part.Color = Color3.new(0,1,0)
		part.Position = point
		pointParts[i] = part
	end

	task.spawn(function()
		pointParts[4].Color = Color3.new(1,0,0)
		pointParts[3].Color = Color3.new(0,0,1)
		while task.wait() do
			points[3] = Vector3.new(math.sin(G.Time()) * 20, 7, 0)
			--points[1] += Vector3.new(0.01,0,0.05)
			points[4] = funcs.constrainToSegment(points[1], points[2], points[3])
			pointParts[4].Position = points[4]
			for i, point in ipairs(points) do
				pointParts[i].Position = point
			end
		end
	end)
end
]=]


return funcs