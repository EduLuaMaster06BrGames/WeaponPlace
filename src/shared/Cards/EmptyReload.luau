local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReloadEvent_Listeners = require(ReplicatedStorage.Shared.Events.ReloadEvent_Listeners)
local WeaponConstantType = require(ReplicatedStorage.Shared.Hero.Types.WeaponConstantType)
local weaponBuffs = require(ReplicatedStorage.Shared.Hero.WeaponBuffList)

type WeaponBuffs = weaponBuffs.WeaponBuffs
type ReloadData = ReloadEvent_Listeners.ReloadData
type Constant = WeaponConstantType.Constant

local onGoingBuff_Primary: boolean = false
local onGoingBuff_Secondary: boolean = false

local emptyReload_Module = {}

function emptyReload_Module.StartUp(data: ReloadData)
	if data.empty_mag then
		if not onGoingBuff_Primary or not onGoingBuff_Secondary then
			SetOnGoingBuff(data)
			local current_BuffList: WeaponBuffs = emptyReload_Module.GetBuffList(data)
			current_BuffList.reload_time -= 0.9
			task.spawn(emptyReload_Module.WaitForReload, data.constant, current_BuffList, data)
		end
	end
end

function SetOnGoingBuff(data: ReloadData)
	if data.constant.type == "Primary" then
		onGoingBuff_Primary = not onGoingBuff_Primary
	else
		onGoingBuff_Secondary = not onGoingBuff_Secondary
	end
end

function emptyReload_Module.WaitForReload(weaponConstant: Constant, current_BuffList: WeaponBuffs, data: ReloadData)
	repeat
		wait()
	until weaponConstant.ammo.current_ammo ~= 0

	SetOnGoingBuff(data)
	current_BuffList.reload_time += 0.9
	return
end

function emptyReload_Module.GetBuffList(data: ReloadData): WeaponBuffs
	if data.constant.type == "Primary" then
		return weaponBuffs.primaryWeapon
	else
		return weaponBuffs.secondaryWeapon
	end
end

function emptyReload_Module.AddAsListener()
	table.insert(ReloadEvent_Listeners, {
		id = HttpService:GenerateGUID(),
		method = emptyReload_Module.StartUp,
	})
end

return emptyReload_Module
