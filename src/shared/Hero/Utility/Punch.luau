local ReplicatedStorage = game:GetService("ReplicatedStorage")
local utilityEvetns = ReplicatedStorage.UtilityEvents
local createPunchEvent: RemoteEvent = utilityEvetns.Punch.CreatePunch

local utilityConstant = require(script.Parent.Default.Constant_Utility)
local utilityBuffList = require(script.Parent.Default.UtilityBuffsList)

local healingArea_Module = {}

function healingArea_Module.RunAction()
	healingArea_Module.RunAnimation()
	healingArea_Module.CallServer()
	return
end

function healingArea_Module.RunAnimation()
	wait(0.1)
end

function healingArea_Module.CallServer()
	createPunchEvent:FireServer(utilityConstant, utilityBuffList)
end

return healingArea_Module
