local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

local DeleteGui
DeleteGui = function(guiIn)
	
	if G.TypeOf(guiIn) == "table" then
		for _, value in pairs(guiIn) do
			DeleteGui(value)
		end
	elseif G.TypeOf(guiIn) == "Entity" then
		task.defer(function()
			G.Soup.DeleteEntity(guiIn)
		end)
	end
	
end
return DeleteGui