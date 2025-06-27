local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HumanoidConstantType = require(script.Parent.HumanoidConstantType)
local Constant_Humanoid = require(ReplicatedStorage.Shared.Hero.Humanoid.Constant_Humanoid)
local Constant_Utility = require(ReplicatedStorage.Shared.Hero.Utility.Default.Constant_Utility)
local WeaponConstantType = require(script.Parent.WeaponConstantType)
type WeaponConstant = WeaponConstantType.Constant
type UtilityConstant = Constant_Utility.UtilityConstant
type HumanoidConstant = HumanoidConstantType.HumanoidConstants

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
		utility: UtilityConstant,
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
