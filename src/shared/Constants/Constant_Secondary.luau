local constant = {
	damage = 10,
	speed = 0.125,
	ammo = {
		current_ammo = 12,
		mag_size = 12,
		reserve_ammo = math.huge,
	},
	piersing = {
		strength_loss = 0.75,
		amount = 0,
	},
	accuracy = 0.75,
	reload_time = 0.5,
	mode = "Semi",
	type = "Secondary",
	multiplier = {
		head = 2,
		body = 1,
	},
}

return constant
