local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))


G.GuiPrefabs = {}



G.GuiPrefabs.MakeWindow = function()
	local WindowGroupEntity = G.Soup.CreateEntity()
	
	local WindowTest1 = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = G.MainScreenGui.AbsoluteSize/2,
			override = function(guiTransform)
				local sinTimeMagnitude = (math.sin(G.Time()) + 1)/2
				--guiTransform.size = Vector2.new(sinTimeMagnitude * (G.MainScreenGui.AbsoluteSize.X - 200), sinTimeMagnitude * (G.MainScreenGui.AbsoluteSize.Y - 200))
				guiTransform.size = G.MoreMath.ClampVector2(guiTransform.size, Vector2.new(300,200), G.MainScreenGui.AbsoluteSize)
				guiTransform.position = G.MoreMath.ClampVector2(guiTransform.position, Vector2.new(0,0), G.MainScreenGui.AbsoluteSize - guiTransform.size)
				
			end
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "MainFrame",
				BackgroundColor3 = Color3.fromRGB(37, 37, 37),
				BorderSizePixel = 0
			}),
		}
	})

	local topBar = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = Vector2.new(WindowTest1.GuiTransform.size.X, 20),
			override = function(guiTransform)
				guiTransform.position = WindowTest1.GuiTransform.position--Vector2.new(math.sin(G.Time())*G.MainScreenGui.AbsoluteSize.X, 100)
				guiTransform.size = Vector2.new(WindowTest1.GuiTransform.size.X, guiTransform.size.Y)
			end
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "TopBar",
				BackgroundColor3 = Color3.fromRGB(53, 53, 53),
				BorderSizePixel = 0
			})
		},
		Draggable = {
			adornee = WindowTest1
		}
	})

	local closeButton = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = Vector2.new(20, 20),
			override = function(guiTransform)
				guiTransform.position = topBar.GuiTransform.position + topBar.GuiTransform.size - Vector2.new(20,20)
			end
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "closeButton",
				BackgroundColor3 = Color3.fromRGB(200,0,0),
				BorderSizePixel = 0
			}),
		},
		Clickable = {
			func = function()
				G.Soup.DeleteEntity(WindowGroupEntity)
			end
		}
	})
	local uiCorner = G.ConstructInstance("UICorner", {
		Parent = closeButton.Instance.instance,
		Name = "funnie corner",
		CornerRadius = UDim.new(1,0)
		
	})

	local maximizeButton = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = Vector2.new(20, 20),
			override = function(guiTransform)
				guiTransform.position = topBar.GuiTransform.position + topBar.GuiTransform.size - Vector2.new(20*2,20)
			end
		},
		Instance = {
			instance = G.ConstructInstance("ImageLabel", {
				Parent = G.MainScreenGui,
				Name = "maximizeButton",
				BackgroundColor3 = Color3.fromRGB(78, 131, 149),
				BorderSizePixel = 0
			}),
		},
		Clickable = {
			func = function()
				WindowGroupEntity.GuiGroup.group.Background.GuiTransform.size = G.MainScreenGui.AbsoluteSize
			end
		}
	})
	local uiCorner = G.ConstructInstance("UICorner", {
		Parent = maximizeButton.Instance.instance,
		Name = "funnie corner",
		CornerRadius = UDim.new(1,0)
		
	})

	local settingsButton = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = Vector2.new(20, 20),
			override = function(guiTransform)
				guiTransform.position = topBar.GuiTransform.position + topBar.GuiTransform.size - Vector2.new(20*3,20)
			end
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "settingsButton",
				BackgroundColor3 = Color3.fromRGB(222, 222, 222),
				BorderSizePixel = 0
			}),
		}
	})
	local uiCorner = G.ConstructInstance("UICorner", {
		Parent = settingsButton.Instance.instance,
		Name = "funnie corner",
		CornerRadius = UDim.new(1,0)
		
	})

	local AppList = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = Vector2.new(20, 20),
			override = function(guiTransform)
				guiTransform.position = WindowTest1.GuiTransform.position + Vector2.new(0,20)
				guiTransform.size = Vector2.new(
					200,
					WindowTest1.GuiTransform.size.Y - 20
				)
			end
		},
		Instance = {
			instance = G.ConstructInstance("ScrollingFrame", {
				Parent = G.MainScreenGui,
				Name = "sideBar/appExplorer",
				BackgroundColor3 = Color3.fromRGB(32, 32, 32),
				BorderColor3 = Color3.fromRGB(64, 64, 64),
				BorderSizePixel = 0
			}),
		}
	})

	local Resizer = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = Vector2.new(15, 15),
			override = function(guiTransform)
				guiTransform.position = WindowTest1.GuiTransform.position + WindowTest1.GuiTransform.size - Vector2.new(15,15)
			end
		},
		Instance = {
			instance = G.ConstructInstance("ImageLabel", {
				Parent = G.MainScreenGui,
				Name = "Resizerrrrr",
				ImageColor3 = Color3.fromRGB(106, 106, 106),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = G.Textures.RightTriangle,
				Rotation = -90
			}),
		},
		Resizable = {
			adornee = WindowTest1
		}
	})


	G.Soup.CreateComponent(WindowGroupEntity, "GuiGroup", {
		group = {
			Background = WindowTest1,
			TopBar = topBar,
			AppList = AppList,
			
			Resizer = Resizer,
			CloseButton = closeButton,
			MaximizeButton = maximizeButton,
			SettingsButton = settingsButton
		}
	})
	return WindowGroupEntity
end

return false