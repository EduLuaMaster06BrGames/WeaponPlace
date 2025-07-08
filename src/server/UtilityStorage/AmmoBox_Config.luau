local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ammoBox_Data = {
	utilityConfig = {
		remoteEvent = ReplicatedStorage.UtilityEvents.AmmoBox.CreateAmmoBox,
		viewmodel = nil,
		animation = nil,
	},
	utilityConstants = {
		power = 150,
		damage = nil,
		healing = nil,
		duration = nil,
		speed = nil,
		size = nil,
		cooldown = 20,
		last_use = 0,
	},
}

return ammoBox_Data
