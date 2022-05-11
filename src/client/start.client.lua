local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

G.Init()
require(script.Parent.InstanceInterpolation)

G.TextChatService.OnIncomingMessage = function(textChatMessage : TextChatMessage)
	print("--------------------------------------")
	for i,v in ipairs({"MessageId", "Metadata","Name","PrefixText","Status", "Text", "TextChannel", "TextSource" ,"Timestamp"}) do
		print(v, " : ", textChatMessage[v])
	end
end
local command : TextChatCommand = G.TextChatService.BaginguleCommand

command.Triggered:Connect(function(origin : TextSource, text : string)
	print(origin, text)
	G.SystemChatChannel:DisplaySystemMessage("Fired Bagingule. Now Bagingule has no stable income!")
end)



local UserInputToServer = function(actionName, inputState, inputObject : InputObject)
	local inputObjectTable = {
		Delta = inputObject.Delta,
		KeyCode = inputObject.KeyCode,
		Position = inputObject.Position,
		UserInputState = inputObject.UserInputState,
		UserInputType = inputObject.UserInputType
	}
	G.TheeRemoteEvent:FireServer({
		actionName, inputState, inputObjectTable
	})
	print({
		actionName, inputState, inputObjectTable
	})
end

G.ContextActionService:BindAction("PickUp", UserInputToServer, false, Enum.KeyCode.F)