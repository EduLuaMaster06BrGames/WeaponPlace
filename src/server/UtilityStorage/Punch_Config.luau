local ReplicatedStorage = game:GetService("ReplicatedStorage")

local punch_Data = {
	utilityConfig = {
		remoteEvent = ReplicatedStorage.UtilityEvents.Punch.CreatePunch,
		viewmodel = nil,
		animation = nil,
	},
	utilityConstants = {
		power = 100,
		damage = nil,
		healing = nil,
		duration = nil,
		speed = nil,
		size = 10,
		cooldown = 10,
		last_use = 0,
	},
}

return punch_Data
