local constant = {
	power = 500,
	damage = 0,
	healing = 0.25,
	duration = 10,
	speed = 0,
	size = 20,
	cooldown = 1,
	last_use = 0,
}

export type UtilityConstant = {
	power: number,
	damage: number,
	healing: number,
	duration: number,
	speed: number,
	size: number,
	cooldown: number,
	last_use: number,
}

return constant
