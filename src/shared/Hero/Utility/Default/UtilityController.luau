local utilityConstant = require(script.Parent.Constant_Utility)
local utility = require(script.Parent.Parent.AmmoBox)

local UtilityController = {}
UtilityController.__index = UtilityController

function UtilityController.start()
	local self = {
		viewmodelController = nil, -- to do
	}

	setmetatable(self, UtilityController)

	self:Inicialize()
end

function UtilityController:Inicialize()
	utilityConstant.last_use = os.clock()
	self.viewmodelController = nil -- to do
	utility.RunAction()
end

function UtilityController.AbleToInicialize(): boolean
	if os.clock() - utilityConstant.last_use >= utilityConstant.cooldown then
		return true
	else
		return false
	end
end

return UtilityController
