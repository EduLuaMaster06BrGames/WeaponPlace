local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant_Utility = require(ReplicatedStorage.Shared.Hero.Utility.Default.Constant_Utility)
type UtilityConstant = Constant_Utility.UtilityConstant

local module = {}

export type UtilityData = {
	utilityConfig: {
		remoteEvent: RemoteEvent,
		viewmodel: Model?,
		animation: string?,
	},
	utilityConstants: UtilityConstant,
}

return module
