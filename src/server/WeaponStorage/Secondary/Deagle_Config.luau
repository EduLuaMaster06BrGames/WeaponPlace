local constant = {
	damage = 25,
	speed = 0.095,
	ammo = {
		current_ammo = 8,
		mag_size = 8,
		reserve_ammo = math.huge,
		max_reserve_ammo = math.huge,
	},
	piersing = {
		strength_loss = 0.5,
		amount = 1,
	},
	crit_chance = 0.1,
	accuracy = 0.75,
	reload_time = 1.5,
	draw_time = 0.75,
	mode = "Semi",
	type = "Secondary",
	pellets = 1,
	multiplier = {
		head = 1.5,
		body = 1,
		crit = 2,
	},
}

return constant
