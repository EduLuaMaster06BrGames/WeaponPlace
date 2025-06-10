local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = ReplicatedStorage.Events
local damageEvent: RemoteFunction = events.OnDamage

local constType = require(ReplicatedStorage.Shared.Hero.Types.WeaponConstantType)
type Constant = constType.Constant

damageEvent.OnServerInvoke = function(
	player: Player,
	humanoidInstance: Humanoid,
	damageDealt: number,
	weaponConstant: constType.Constant
)
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 and humanoidInstance.Health > 0 then
			local critHit = CritHit(weaponConstant)

			if critHit then
				damageDealt *= weaponConstant.multiplier.crit
			end

			humanoidInstance.Health -= damageDealt
			return
		end
	end
end

function CritHit(weaponConstant: Constant): boolean
	local rng = math.random(1, 100)
	if rng <= weaponConstant.crit_chance then
		return true
	else
		return false
	end
end
