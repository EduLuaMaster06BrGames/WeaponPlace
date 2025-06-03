local module = {}

export type Constant = {
	damage: number,
	speed: number,
	ammo: {
		current_ammo: number,
		mag_size: number,
		reserve_ammo: number,
	},
	piersing: {
		strength_loss: number,
		amount: number,
	},
	crit_chance: number,
	accuracy: number,
	reload_time: number,
	draw_time: number,
	mode: string,
	type: string,
	pellets: number,
	multiplier: {
		head: number,
		body: number,
		crit: number,
	},
}

return module
