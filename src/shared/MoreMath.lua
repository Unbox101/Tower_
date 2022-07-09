local MoreMath = {}

MoreMath.Bezier = function(points : table, progress : number)
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

MoreMath.ClampVector2 = function(n, min, max)
	
	if min.X > max.X then
		min = Vector2.new(max.X-1, min.Y)
	end
	if min.Y > max.Y then
		min = Vector2.new(min.X, max.Y-1)
	end
	
	return Vector2.new(
		math.clamp(n.X, min.X, max.X),
		math.clamp(n.Y, min.Y, max.Y)
	)
end


--made by @4thAxis#0337 on discord. Roblox Studio Community discord. they r cool math wizard
local function SlerpXY(Origin, GoalPos, GoalLook, Alpha)
    Alpha = math.clamp(Alpha or 0.5, 0, 1)
    local Theta = math.acos(Origin.lookVector:Dot(GoalLook)) -- LookVector of goal cframe
    if Theta < 0.01 then 
        return Origin
    else
        local Position = Origin.Position:Lerp(GoalPos, Alpha)
        local InvSin = 1/math.sin(Theta)
        local Rotation = math.sin((1-Alpha)*Theta)*InvSin*Origin.LookVector + math.sin(Alpha*Theta)*InvSin*GoalLook
        return CFrame.lookAt(
            Position, 
            Position + Rotation
        )
    end
end
--made by @4thAxis#0337 on discord. Roblox Studio Community discord. they r cool math wizard
local Epsilon = 1e-5
local function GetViewMatrix(Eye, Focus)
    -- Faster alternative to cframe.lookat for our case since we are more commonly prone to special cases such as: when focus is facing up/down or if focus and eye are colinear vectors
    local XAxis = Focus-Eye -- Lookvector
    if (XAxis:Dot(XAxis) <= Epsilon) then 
        return CFrame.new(Eye.X, Eye.Y, Eye.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1) 
    end
    XAxis = XAxis.Unit
    local Xx, Xy, Xz = XAxis.X, XAxis.Y, XAxis.Z
    local RNorm = (((Xz*Xz)+(Xx*Xx))) -- R:Dot(R), our right vector
    if RNorm <= Epsilon and math.abs(XAxis.Y) > 0 then
         return CFrame.fromMatrix(Eye, -math.sign(XAxis.Y)*Vector3.zAxis, Vector3.xAxis)
    end
    RNorm = 1/(RNorm^0.5) -- take the root of our squared norm and inverse division
    local Rx, Rz = -(Xz*RNorm), (Xx*RNorm) -- cross y-axis with right and normalize
    local Ux, Uy, Uz = -Rz*(Rz*Xx-Rx*Xz), -(Rz*Rz)*Xy-(Rx*Rx)*Xy, Rx*(Rz*Xx-Rx*Xz) -- cross right and up and normalize.
    local UNorm = 1/((Ux*Ux)+(Uy*Uy)+(Uz*Uz))^0.5 -- inverse division and multiply this ratio rather than dividing each component
    return CFrame.new(
        Eye.X,Eye.Y,Eye.Z,
        Rx, -Xy*Rz, Ux*UNorm, 
        0, (Rz*Xx)-Rx*Xz, Uy*UNorm,
        Rz, Xy*Rx, Uz*UNorm
    )
end

return MoreMath