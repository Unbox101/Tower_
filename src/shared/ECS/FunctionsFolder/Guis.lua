

return {
	MakeNewWindowInstance = function(parent)
		local window = Instance.new("Frame", parent)
		window.BackgroundColor3 = Color3.fromRGB(50,50,50)
		window.BorderSizePixel = 1
		window.BorderColor3 = Color3.new(0.01,0.01,0.01)
		window.Size = UDim2.new(0.7,0,0.7,0)
		window.Position = UDim2.new(0.5,0,0.5,0)
		window.AnchorPoint = Vector2.new(0.5,0.5)
		
		local topBar = Instance.new("Frame", window)
		topBar.BackgroundColor3 = Color3.fromRGB(18,18,18)
		topBar.BorderSizePixel = 0
		topBar.Size = UDim2.new(1,0,0,30)
		
		
		return {
			windowInstance = window,
			topBarInstance = topBar
		}
	end
}