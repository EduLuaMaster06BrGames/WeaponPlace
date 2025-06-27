local constant: UtilityConstant = {
	power = nil,
	damage = nil,
	healing = nil,
	duration = nil,
	speed = nil,
	size = nil,
	cooldown = nil,
	last_use = nil,
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
