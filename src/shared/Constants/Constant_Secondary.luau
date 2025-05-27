local constant = {
	damage = 10,
	speed = 0.125,
	ammo = {
		current_ammo = 12,
		mag_size = 12,
		reserve_ammo = math.huge,
	},
	accuracy = {
		min_accuracy = 0,
		max_accuracy = 0,
		recovery_rate = 0,
		recoil_rate = 0,
	},
	reload_time = 0.5,
	mode = "Semi",
	type = "Secondary",
	multiplier = {
		head = 2,
		body = 1,
	},
}

return constant
