local constant = {
	damage = 12,
	speed = 0.1,
	ammo = {
		current_ammo = 20,
		mag_size = 20,
		reserve_ammo = 300,
		max_reserve_ammo = 300,
	},
	piersing = {
		strength_loss = 0.2,
		amount = 0,
	},
	crit_chance = 10,
	accuracy = 1,
	reload_time = 1.2,
	draw_time = 0.7,
	mode = "Semi",
	type = "Primary",
	pellets = 1,
	multiplier = {
		head = 2.5,
		body = 1,
		crit = 0.7,
	},
}

return constant
