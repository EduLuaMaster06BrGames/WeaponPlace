local utilityConstant = require(script.Parent.Constant_Utility)
local utilityBuffList = require(script.Parent.UtilityBuffsList)
local utilityConfig = require(script.Parent.Parent.Utility)

local UtilityController = {}
UtilityController.__index = UtilityController

function UtilityController.start()
	local self = {
		viewmodelController = nil,
		remoteEvent = utilityConfig.remoteEvent,
	}

	setmetatable(self, UtilityController)

	self:Inicialize()
end

function UtilityController:Inicialize()
	utilityConstant.last_use = os.clock()
	self:RunAnimation()
	self:CallServer()
end

function UtilityController:RunAnimation()
	wait(1)
end

function UtilityController:CallServer()
	local remoteEvent = self.remoteEvent

	if remoteEvent and remoteEvent:IsA("RemoteEvent") then
		remoteEvent:FireServer(utilityConstant, utilityBuffList)
	end
end

function UtilityController.AbleToInicialize(): boolean
	if os.clock() - utilityConstant.last_use >= utilityConstant.cooldown then
		return true
	else
		return false
	end
end

return UtilityController
