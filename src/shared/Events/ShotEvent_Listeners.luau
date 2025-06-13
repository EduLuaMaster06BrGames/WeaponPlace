local ReplicatedStorage = game:GetService("ReplicatedStorage")
local weaponConstantType = require(ReplicatedStorage.Shared.Hero.Types.WeaponConstantType)

local listeners: { Listener } = {}

type Constant = weaponConstantType.Constant

export type Listener = {
	id: string,
	method: any,
}

export type ShotData = {
	hit: Vector3,
	target: Humanoid,
	headshot: boolean,
	damage: number,
	constant: Constant,
}

return listeners
