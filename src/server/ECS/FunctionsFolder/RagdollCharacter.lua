
local ragdollConstraintsTable = {
	Default = {
		LimitsEnabled = true,
		TwistLimitsEnabled = true,
		MaxFrictionTorque = 10,-- 15
		UpperAngle = 20,-- 15
		TwistLowerAngle = -20,-- -15
		TwistUpperAngle = 20,-- 15
	},
	Neck = {
		MaxFrictionTorque = 25,
		UpperAngle = 15,
		TwistLowerAngle = -15,
		TwistUpperAngle = 15
	},
	LeftShoulder = {
		UpperAngle = 100,
		TwistLowerAngle = -20,
		TwistUpperAngle = 20
	},
	RightShoulder = {
		UpperAngle = 100,
		TwistLowerAngle = -20,
		TwistUpperAngle = 20
	},
	LeftHip = {
		UpperAngle = 50
	},
	RightHip = {
		UpperAngle = 50
	},
	LeftKnee = {
		UpperAngle = 15,
		TwistLowerAngle = -90,
		TwistUpperAngle = 0
	},
	RightKnee = {
		UpperAngle = 15,
		TwistLowerAngle = -90,
		TwistUpperAngle = 0
	}
	
}

return function(character)
	pcall(function() character.Head.face:Destroy() end)
	
	for _, v in pairs(character:GetDescendants()) do
		if v:IsA("Motor6D") then
			if v.Name == "Root" then continue end
			local Attachment0, Attachment1 = Instance.new("Attachment"), Instance.new("Attachment")
			Attachment0.CFrame = v.C0
			Attachment1.CFrame = v.C1
			Attachment0.Parent = v.Part0
			Attachment1.Parent = v.Part1
			
			local ballConstraint = Instance.new("BallSocketConstraint")
			ballConstraint.Attachment0 = Attachment0
			ballConstraint.Attachment1 = Attachment1
			ballConstraint.Parent = v.Part0
			
			for key,val in pairs(ragdollConstraintsTable["Default"]) do
				ballConstraint[key] = val
			end
			if ragdollConstraintsTable[v.Name] then
				for key,val in pairs(ragdollConstraintsTable[v.Name]) do
					ballConstraint[key] = val
				end
			end
			v:Destroy()
		end
	end
	character.HumanoidRootPart.CanCollide = false
end