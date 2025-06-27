local constant = {
	damage = 4,
	speed = 0.15,
	ammo = {
		current_ammo = 6,
		mag_size = 6,
		reserve_ammo = 150,
		max_reserve_ammo = 150,
	},
	piersing = {
		strength_loss = 0.7,
		amount = 0,
	},
	crit_chance = 0,
	accuracy = 5,
	reload_time = 2,
	draw_time = 0.5,
	mode = "Semi",
	type = "Primary",
	pellets = 5,
	multiplier = {
		head = 1.2,
		body = 1,
		crit = 0.5,
	},
}

return constant
