local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = ReplicatedStorage.Events
local damageEvent: RemoteFunction = events.OnDamage

local shotDataType = require(ReplicatedStorage.Shared.Events.ShotEvent_Listeners)
local weaponConstantType = require(ReplicatedStorage.Shared.Hero.Types.WeaponConstantType)
local weaponBuffs = require(ReplicatedStorage.Shared.Hero.WeaponBuffList)

type ShotData = shotDataType.ShotData
type Constant = weaponConstantType.Constant
type WeaponBuffs = weaponBuffs.WeaponBuffs

damageEvent.OnServerInvoke = function(player: Player, shotData: ShotData, buffList: WeaponBuffs)
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 and shotData.target.Health > 0 then
			local critHit = CritHit(shotData.constant)

			if critHit then
				shotData.damage *= shotData.constant.multiplier.crit
			end

			shotData.target.Health -= shotData.damage
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
