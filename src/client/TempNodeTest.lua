local G = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Globals"))

--[[
	
	Ok so basically node functionality happens in "2 steps" (ish), forward propogation and backward propogation.
	Forward propogation is sortof like entry points to the entire node graph.
	They are really only their to activate/stimulate the graph depending on your needs.
	
	Backward propogation happens automatically (and recursively) to every node when it's functional is called.
	
	Forward propogating nodes will be like "OnStart" and "Tick" and even "OnUserInput"
	Backward propogation happens in literally every node, even ones that forward propogate, when you call any nodes "functional"
	
--]]

local functionals = {
	
	Add = function(node)
		node.output = node.a + node.b
	end,
	Print = function(node)
		print(node.text)
	end,
	Call = function(node)
		for i,nodeToCall in pairs(node.callNodes) do
			CallFunctional(nodeToCall)
		end
	end
	
}

function CallFunctional(node)
	for i,input in pairs(node.inputs) do
		local inputNode = input.node
		local keyA = input.keyA
		local keyB = input.keyB
		CallFunctional(inputNode)
	 	node[keyB] = inputNode[keyA]
	end
	if functionals[node.functional] then
		functionals[node.functional](node)
	end
end



local initNode = {
	inputs = {},
	callNodes = {},
	functional = "Call"
}

local numNode = {
	inputs = {},
	calls = {},
	functional = nil,
	num = 300
}

local addNode = {
	inputs = {
		{node = numNode, keyA = "num", keyB = "a"}
	},
	calls = {},
	functional = "Add",
	a = 1,
	b = 2
}

local printNode = {
	inputs = {
		{node = addNode, keyA = "output", keyB = "text"}
	},
	calls = {},
	functional = "Print",
	text = "nil"
}
initNode.callNodes[1] = printNode


local allNodes = {
	initNode = initNode,
	numNode = numNode,
	addNode = addNode,
	printNode = printNode
}






CallFunctional(initNode)--haha init haha KEK

return false