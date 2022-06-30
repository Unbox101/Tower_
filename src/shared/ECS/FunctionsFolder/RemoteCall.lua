local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))
local module = {}
--set valid functions
local clientAllowedToCall = {
	"DropSlot1",
	"ReadyClient"
}
local serverAllowedToCall = {
	"UpdateInventoryGuiSlots",
	"UpdateInventoryGuiItems"
	
}

G.Functions.ReadyClient = function(playerhuh)
	print(playerhuh)
end

G.Functions.GetTestValue = function()
	return 2337
end

local playerCheck = function(playerIn)
	if typeof(playerIn) == "Instance" and playerIn:IsA("Player") then
		return true
	end
	return false
end

--setup the remote event and remote function
local remoteEvent
local remoteFunction
if G.IsServer then
	--create the RemoteEvent/Function
	remoteEvent = Instance.new("RemoteEvent",script)
	remoteEvent.Name = "RemoteEventCall"
	remoteFunction = Instance.new("RemoteFunction",script)
	remoteFunction.Name = "RemoteFunctionCall"
	--make them work
	--[=[]]
	remoteFunction.OnServerInvoke = function(player, funcName, ...)
		if not playerCheck(player) then error("player argument must be a player instance!") end
		return G.Functions[funcName](player, ...)
	end
	]=]
	remoteEvent.OnServerEvent:Connect(function(player, funcName, ...)
		if not playerCheck(player) then error("player argument must be a player instance!") end
		G.Functions[funcName](player, ...)
	end)
else
	--client rlly do be relying on the server right here doe
	remoteEvent = script:WaitForChild("RemoteEventCall",10)
	remoteFunction = script:WaitForChild("RemoteFunctionCall",10)
	
	remoteEvent.OnClientEvent:Connect(function(funcName, ...)
		print(G.Functions)
		if G.Functions[funcName] == nil then
			error("function with name " .. tostring(funcName).. " does not exist!" )
		end
		G.Functions[funcName](...)
	end)
end

--init all valid functions/events and put them in G
G.RemoteCall = {}


if G.IsClient then
	--client
	--handle Functions
	--[=[]]
	for _,funcName in pairs(clientAllowedToCall) do
		G.RemoteCall[funcName] = function(...)
			return remoteFunction:InvokeServer(funcName, ...)
		end
	end
	]=]
	print(G.Functions)
	--handle Events
	for _,funcName in pairs(clientAllowedToCall) do
		G.RemoteCall[funcName] = function(...)
			remoteEvent:FireServer(funcName, ...)
		end
	end
else
	--server
	--handle Events
	for _,funcName in ipairs(serverAllowedToCall) do
		G.RemoteCall[funcName] = function(player, ...)
			if not playerCheck(player) then error("player argument must be a player instance!") end
			print(...)
			remoteEvent:FireClient(player, funcName, ...)
		end
	end
	--No remote functions to be had here. cuz thats bad juju
end

return module