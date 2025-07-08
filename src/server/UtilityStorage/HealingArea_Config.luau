local ReplicatedStorage = game:GetService("ReplicatedStorage")

local healingArea_Data = {
	utilityConfig = {
		remoteEvent = ReplicatedStorage.UtilityEvents.HealingArea.CreateHealingArea,
		viewmodel = nil,
		animation = nil,
	},
	utilityConstants = {
		power = nil,
		damage = nil,
		healing = 0.01,
		duration = 15,
		speed = nil,
		size = 16,
		cooldown = 30,
		last_use = 0,
	},
}

return healingArea_Data
