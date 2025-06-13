local constant = {
	power = 0.25,
	duration = 10,
	speed = 0,
	size = 16,
	cooldown = 15,
	last_use = 0,
}

export type UtilityConstant = {
	power: number,
	duration: number,
	speed: number,
	size: number,
	cooldown: number,
	last_use: number,
}

return constant
