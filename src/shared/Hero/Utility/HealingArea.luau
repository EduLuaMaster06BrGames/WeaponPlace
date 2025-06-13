local ReplicatedStorage = game:GetService("ReplicatedStorage")
local utilityEvetns = ReplicatedStorage.UtilityEvents
local createHealingAreaEvent: RemoteEvent = utilityEvetns.HealingArea.CreateHealingArea

local utilityConstant = require(script.Parent.Default.Constant_Utility)
local utilityBuffList = require(script.Parent.Default.UtilityBuffsList)

local healingArea_Module = {}

function healingArea_Module.RunAction()
	healingArea_Module.RunAnimation()
	healingArea_Module.CallServer()
	return
end

function healingArea_Module.RunAnimation()
	print("Start")
	wait(1)
	print("End")
end

function healingArea_Module.CallServer()
	createHealingAreaEvent:FireServer(utilityConstant, utilityBuffList)
end

return healingArea_Module
