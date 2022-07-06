local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local MoreMath = {}

function MoreMath.Bezier(points : table, progress : number)
	--Calculate number of final points and prepare an array for them
	local points = points
	local nPoints = #points - 1
	
	--Reduce number of points until there's only one left
	--With only one remaining point, nPoints will be 0 since it's
	--the number of points to be stored in the next iteration
	while (nPoints > 0) do
		local pointsOut = table.create(nPoints, Vector3.new())
		local i
		for i = 1, nPoints do
			--Get points
			local p0 = points[i]
			local p1 = points[i+1]
			
			--Store linearly interpolated point
			pointsOut[i] = p1*progress + p0*(1-progress)
		end
		
		--Store new points and number of points for the next iteration
		points = pointsOut
		nPoints = nPoints - 1
	end
	
	--Return the last point
	return points[1]
end

G.MoreMath = MoreMath

return false