local constant = {
	damage = 7,
	speed = 0.075,
	ammo = {
		current_ammo = 25,
		mag_size = 35,
		reserve_ammo = 200,
	},
	piersing = {
		strength_loss = 0.25,
		amount = 4,
	},
	crit_chance = 50,
	accuracy = 1,
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
