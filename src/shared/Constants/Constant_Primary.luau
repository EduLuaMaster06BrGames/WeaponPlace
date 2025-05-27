local constant = {
	damage = 15,
	speed = 0.1,
	ammo = {
		current_ammo = 25,
		mag_size = 25,
		reserve_ammo = 200,
	},
	accuracy = {
		min_accuracy = 0.25,
		max_accuracy = 1,
		recovery_rate = 0.025,
		recoil_rate = 0.15,
	},
	reload_time = 1,
	mode = "Auto",
	type = "Primary",
	multiplier = {
		head = 2,
		body = 1,
	},
}

return constant
