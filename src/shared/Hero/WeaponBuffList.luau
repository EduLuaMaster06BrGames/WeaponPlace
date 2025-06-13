export type WeaponBuffs = {
	damage: number,
	speed: number,
	ammo: {
		mag_size: number,
		reserve_ammo: number,
		max_reserve_ammo: number,
	},
	piersing: {
		strength_loss: number,
		amount: number,
	},
	crit_chance: number,
	accuracy: number,
	reload_time: number,
	draw_time: number,
	pellets: number,
	multiplier: {
		head: number,
		body: number,
		crit: number,
	},
}

local weaponBuffs = {
	primaryWeapon = {
		damage = 1,
		speed = 1,
		ammo = {
			mag_size = 1,
			reserve_ammo = 1,
			max_reserve_ammo = 1,
		},
		piersing = {
			strength_loss = 1,
			amount = 0,
		},
		crit_chance = 1,
		accuracy = 1,
		reload_time = 1,
		draw_time = 1,
		pellets = 0,
		multiplier = {
			head = 1,
			body = 1,
			crit = 1,
		},
	},
	secondaryWeapon = {
		damage = 1,
		speed = 1,
		ammo = {
			mag_size = 1,
			reserve_ammo = 1,
			max_reserve_ammo = 1,
		},
		piersing = {
			strength_loss = 1,
			amount = 0,
		},
		crit_chance = 1,
		accuracy = 1,
		reload_time = 1,
		draw_time = 1,
		pellets = 0,
		multiplier = {
			head = 1,
			body = 1,
			crit = 1,
		},
	},
}

return weaponBuffs
