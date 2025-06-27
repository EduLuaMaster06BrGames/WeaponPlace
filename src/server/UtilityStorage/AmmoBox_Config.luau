local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ammoBox_Data = {
	remoteEvent = ReplicatedStorage.UtilityEvents.AmmoBox.CreateAmmoBox,
	viewmodel = nil,
	animation = nil,
}

return ammoBox_Data
