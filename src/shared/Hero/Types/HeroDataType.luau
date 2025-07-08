local UtilityDataType = require(script.Parent.UtilityDataType)
local HumanoidConstantType = require(script.Parent.HumanoidConstantType)
local WeaponConstantType = require(script.Parent.WeaponConstantType)
type WeaponConstant = WeaponConstantType.Constant
type HumanoidConstant = HumanoidConstantType.HumanoidConstants
type UtilityData = UtilityDataType.UtilityData

local module = {}

export type HeroData = {
	primary_weapon: string,
	secondary_weapon: string,
	utility: string,
}

export type HeroConfig = {
	weapon_constants: {
		primary: WeaponConstant,
		secondary: WeaponConstant,
	},
	utility_constants: {
		utility: UtilityData,
	},
	weapon_viewmodels: {
		primary: Model,
		secondary: Model,
	},
	humanoid_constants: {
		humanoid: HumanoidConstant,
	},
	utility_viewmodels: {
		utility: Model,
	},
}

return module
