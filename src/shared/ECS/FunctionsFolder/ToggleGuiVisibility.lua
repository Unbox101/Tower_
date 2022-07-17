local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
local internal
internal = function(guiEnt)
	if guiEnt.Instance then
		pcall(function()
			guiEnt.Instance.instance.Visible = not guiEnt.Instance.instance.Visible
		end)
	elseif guiEnt.GuiGroup then
		for _,groupElement in pairs(guiEnt.GuiGroup.group) do
			internal(groupElement)
		end
	end
end
local ToggleGuiVisibility
ToggleGuiVisibility = function(guiIn)
	
	if G.TypeOf(guiIn) == "table" then
		for _, value in pairs(guiIn) do
			ToggleGuiVisibility(value)
		end
	elseif G.TypeOf(guiIn) == "Entity" then
		internal(guiIn)
	end
	
end

return ToggleGuiVisibility