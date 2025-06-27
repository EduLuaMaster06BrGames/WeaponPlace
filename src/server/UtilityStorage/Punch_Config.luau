local ReplicatedStorage = game:GetService("ReplicatedStorage")

local punch_Data = {
	remoteEvent = ReplicatedStorage.UtilityEvents.Punch.CreatePunch,
	viewmodel = nil,
	animation = nil,
}

return punch_Data
