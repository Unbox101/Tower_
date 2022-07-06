local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local redOne = Instance.new("Frame", G.MainScreenGui)
redOne.BackgroundColor3 = Color3.new(1,0,0)
redOne.BackgroundTransparency = 0.7
local greenOne = Instance.new("Frame", G.MainScreenGui)
greenOne.BackgroundColor3 = Color3.new(0,1,0)
greenOne.BackgroundTransparency = 0.7

local halfSizeEntity = G.Soup.CreateEntity()
G.Soup.CreateComponent(halfSizeEntity, "Frame", {
	localPos = Vector2.new(0.20,0),
	localSize = Vector2.new(0.5, 0.5),
	instance = redOne
})

local halfOfAHalfSizeEntity = G.Soup.CreateEntity()
G.Soup.CreateComponent(halfOfAHalfSizeEntity, "Frame", {
	localPos = Vector2.new(0.5, 0.5),
	localSize = Vector2.new(0.5, 0.5),
	instance = greenOne,
	posParent = halfSizeEntity,
	sizeParent = halfSizeEntity,
	anchorPoint = Vector2.new(0.5,0.5)
})

task.spawn(function()
	while task.wait() do
		
		halfSizeEntity.Frame.globalPos = Vector2.new(
			math.sin(G.Time())*200,
			0
		)
		halfOfAHalfSizeEntity.Frame.localPos = Vector2.new(
			(math.sin(G.Time()*3)+1)/2,
			0.5
		)
		
	end
end)

return false