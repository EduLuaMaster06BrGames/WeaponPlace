local constant = {
	damage = 5,
	speed = 0.05,
	ammo = {
		current_ammo = 12,
		mag_size = 12,
		reserve_ammo = math.huge,
		max_reserve_ammo = math.huge,
	},
	piersing = {
		strength_loss = 0.8,
		amount = 0,
	},
	crit_chance = 0.3,
	accuracy = 0.3,
	reload_time = 1,
	draw_time = 0.4,
	mode = "Semi",
	type = "Secondary",
	pellets = 1,
	multiplier = {
		head = 1.2,
		body = 1,
		crit = 2,
	},
}

return constant
