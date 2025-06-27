local ReplicatedStorage = game:GetService("ReplicatedStorage")

local healingArea_Data = {
	remoteEvent = ReplicatedStorage.UtilityEvents.HealingArea.CreateHealingArea,
	viewmodel = nil,
	animation = nil,
}

return healingArea_Data
