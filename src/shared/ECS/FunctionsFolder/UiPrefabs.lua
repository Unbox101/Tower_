local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))


G.UIPrefabs = {}

G.UIPrefabs.MakeWindow = function()
	
	
	
	local parentFrameEntity = G.ConstructEntity({
		Frame = {
			anchorPoint = Vector2.new(0.5,0.5),
			size = {0.6,0,0.6,0},
			pos = {0.5,0,0.5,0},
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "windowFrame",
				BackgroundColor3 = Color3.fromRGB(37, 37, 37),
				BorderColor3 = Color3.fromRGB(64, 64, 64),
				BorderSizePixel = 2,
			})
		}
	})
	
	
	
	local topBar = G.ConstructEntity({
		Frame = {
			anchorPoint = Vector2.new(0,0),
			size = {1,0,0,20},
			pos = {0,0,0,0},
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "caption/topBar/handle",
				BackgroundColor3 = Color3.fromRGB(53, 53, 53),
				BorderSizePixel = 0,
			}),
			parent = parentFrameEntity
			--posParent = parentFrameEntity,
		}
	})
	
	
	
	local closeButton = G.ConstructEntity({
		Frame = {
			anchorPoint = Vector2.new(1,0),
			size = {0,20,0,20},
			pos = {1,0,0,0},
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "closeButton",
				BackgroundColor3 = Color3.fromRGB(200,0,0),
				BorderSizePixel = 0
			}),
			parent = topBar
		}
	})
	
	
	
	local contentFrame = G.ConstructEntity({
		Frame = {
			anchorPoint = Vector2.new(0,0),
			size = {1,0,1,-20},
			pos = {0,0,0,20},
			instance = G.ConstructInstance("ScrollingFrame", {
				Name = "contentFrame",
				BackgroundColor3 = Color3.fromRGB(0, 170, 255),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Parent = G.MainScreenGui
			}),
			parent = parentFrameEntity
		}
	})
	
	
	
	return parentFrameEntity, {contentFrame = contentFrame, closeButton = closeButton, topBar = topBar}
end

return false