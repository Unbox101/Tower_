local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local ZIndex = 0

local GetZIndex = function()
	ZIndex += 1
	return ZIndex
end

G.GuiPrefabs = {}

G.GuiPrefabs.MakeWindow = function(windowName)
	--local WindowGroupEntity = G.Soup.CreateEntity()
	windowName = windowName or "Window"
	local WindowGroup = {}
	
	WindowGroup.background = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(100,100),
			size = G.MainScreenGui.AbsoluteSize/2,
			--[=[]]
			override = function(guiTransform)
				--local sinTimeMagnitude = (math.sin(G.Time()) + 1)/2
				--guiTransform.size = Vector2.new(sinTimeMagnitude * (G.MainScreenGui.AbsoluteSize.X - 200), sinTimeMagnitude * (G.MainScreenGui.AbsoluteSize.Y - 200))
				guiTransform.size = G.MoreMath.ClampVector2(guiTransform.size, Vector2.new(300,200), G.MainScreenGui.AbsoluteSize)
				guiTransform.position = G.MoreMath.ClampVector2(guiTransform.position, Vector2.new(0,0), G.MainScreenGui.AbsoluteSize - guiTransform.size)
			end,
			doOverride = true
			]=]
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "MainFrame",
				BackgroundColor3 = Color3.fromRGB(37, 37, 37),
				BorderSizePixel = 0,
				ZIndex = GetZIndex()
			}),
		}
	})
	
	WindowGroup.contentFrame = G.ConstructEntity({
		GuiTransform = {
			override = function(guiTransform)
				guiTransform.size = WindowGroup.background.GuiTransform.size - Vector2.new(0,20)
				guiTransform.position = WindowGroup.background.GuiTransform.position + Vector2.new(0,20)
			end
		}
	})
	
	WindowGroup.topBar = G.ConstructEntity({
		GuiTransform = {
			size = Vector2.new(0, 20)
		},
		GuiLocalTransform = {
			parent = WindowGroup.background,
			localPos = Vector2.new(0,0),
			localSize = Vector2.new(1, 0)
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "TopBar",
				BackgroundColor3 = Color3.fromRGB(53, 53, 53),
				BorderSizePixel = 0,
				ZIndex = GetZIndex()
			})
		},
		Draggable = {
			adornee = WindowGroup.background
		}
	})

	WindowGroup.name = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(0,0),
			size = Vector2.new(100, 20)
		},
		GuiLocalTransform = {
			parent = WindowGroup.background
		},
		Instance = {
			instance = G.ConstructInstance("TextLabel", {
				Parent = G.MainScreenGui,
				Name = "closeButton",
				BackgroundTransparency = 1,
				Text = windowName,
				TextScaled = true,
				TextColor3 = Color3.new(0.9,0.9,0.9),
				ZIndex = GetZIndex()
			}),
		},
	})
	
	WindowGroup.closeButton = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(-20,-20),
			size = Vector2.new(20, 20)
		},
		GuiLocalTransform = {
			parent = WindowGroup.topBar,
			localPos = Vector2.new(1,1)
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "closeButton",
				BackgroundColor3 = Color3.fromRGB(200,0,0),
				BorderSizePixel = 0,
				ZIndex = GetZIndex()
			}),
		},
		GuiClickable = {
			func = function()
				print(WindowGroup)
				G.Functions.ToggleGuiVisibility(WindowGroup)
				--[=[]]
				for i,v in pairs(WindowGroup) do
					G.Soup.DeleteEntity(v)
				end
				]=]
			end
		}
	})
	local uiCorner = G.ConstructInstance("UICorner", {
		Parent = WindowGroup.closeButton.Instance.instance,
		Name = "funnie corner",
		CornerRadius = UDim.new(1,0)
		
	})

	WindowGroup.maximizeButton = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(-20*2,-20),
			size = Vector2.new(20, 20)
		},
		GuiLocalTransform = {
			parent = WindowGroup.topBar,
			localPos = Vector2.new(1,1)
		},
		Instance = {
			instance = G.ConstructInstance("ImageLabel", {
				Parent = G.MainScreenGui,
				Name = "maximizeButton",
				BackgroundColor3 = Color3.fromRGB(78, 131, 149),
				BorderSizePixel = 0,
				ZIndex = GetZIndex()
			}),
		},
		GuiClickable = {
			func = function()
				WindowGroup.background.GuiTransform.size = G.MainScreenGui.AbsoluteSize
			end
		}
	})
	local uiCorner = G.ConstructInstance("UICorner", {
		Parent = WindowGroup.maximizeButton.Instance.instance,
		Name = "funnie corner",
		CornerRadius = UDim.new(1,0)
		
	})

	WindowGroup.settingsButton = G.ConstructEntity({
		GuiTransform = {
			position = Vector2.new(-20*3,-20),
			size = Vector2.new(20, 20)
		},
		GuiLocalTransform = {
			parent = WindowGroup.topBar,
			localPos = Vector2.new(1,1)
		},
		Instance = {
			instance = G.ConstructInstance("Frame", {
				Parent = G.MainScreenGui,
				Name = "settingsButton",
				BackgroundColor3 = Color3.fromRGB(222, 222, 222),
				BorderSizePixel = 0,
				ZIndex = GetZIndex()
			}),
		}
	})
	local uiCorner = G.ConstructInstance("UICorner", {
		Parent = WindowGroup.settingsButton.Instance.instance,
		Name = "funnie corner",
		CornerRadius = UDim.new(1,0)
		
	})

	

	WindowGroup.resizer = G.ConstructEntity({
		GuiTransform = {
			position = -Vector2.new(15,15),
			size = Vector2.new(15, 15)
		},
		GuiLocalTransform = {
			parent = WindowGroup.background,
			localPos = Vector2.new(1,1)
		},
		Instance = {
			instance = G.ConstructInstance("ImageLabel", {
				Parent = G.MainScreenGui,
				Name = "Resizerrrrr",
				ImageColor3 = Color3.fromRGB(106, 106, 106),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = G.Textures.RightTriangle,
				Rotation = -90,
				ZIndex = GetZIndex()
			}),
		},
		Resizable = {
			adornee = WindowGroup.background
		}
	})


	return WindowGroup
end

G.GuiPrefabs.MakeNodeList = function(spawnPos)
	local nodelist = G.GuiPrefabs.MakeWindow()
	nodelist.background.GuiTransform.position = spawnPos - Vector2.new(10,10)
	nodelist.background.GuiTransform.size = Vector2.new(150,250)
	G.Systems.ApplyUITransforms()
	G.Soup.Add(nodelist.background, "DeleteGuiOnMouseLeave", {
		mouseLeaveAdornee = nodelist.background,
		deleteAdornee = nodelist,
		hoveringOver = true,
		spawnTimestamp = os.clock()
	})
	
	return nodelist
end

G.GuiPrefabs.MakeLodestarGui = function()
	local GuiTable = G.GuiPrefabs.MakeWindow()
	
	G.Soup.Add(GuiTable.background, "CreateGuiOnInteract2", {
		guiToCreate = "MakeNodeList"
	})
	return GuiTable
end

return false