local constant = {
	damage = 7,
	speed = 0.095,
	ammo = {
		current_ammo = 25,
		mag_size = 25,
		reserve_ammo = 300,
		max_reserve_ammo = 300,
	},
	piersing = {
		strength_loss = 0.45,
		amount = 4,
	},
	crit_chance = 25,
	accuracy = 1.5,
	reload_time = 1,
	draw_time = 0.5,
	mode = "Auto",
	type = "Primary",
	pellets = 1,
	multiplier = {
		head = 2,
		body = 1,
		crit = 1.5,
	},
}

return constant
