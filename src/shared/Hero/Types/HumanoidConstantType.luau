local module = {}

export type HumanoidConstants = {
	MaxHealth: number,
	WalkSpeed: number,
	BaseRegen: number,
	HealingMultiplier: number,
	DamageReduction: number,
}

export type Listener = {
	Method: (string, number) -> any,
	ListeningTo: { string },
	Id: string,
}

return module
