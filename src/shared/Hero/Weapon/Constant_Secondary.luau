local constant = {
	damage = 10,
	speed = 0.125,
	ammo = {
		current_ammo = 12,
		mag_size = 12,
		reserve_ammo = math.huge,
		max_reserve_ammo = math.huge,
	},
	piersing = {
		strength_loss = 0.75,
		amount = 0,
	},
	crit_chance = 50,
	accuracy = 0.75,
	reload_time = 0.5,
	draw_time = 0.25,
	mode = "Semi",
	type = "Secondary",
	pellets = 1,
	multiplier = {
		head = 2,
		body = 1,
		crit = 1.5,
	},
}

return constant
