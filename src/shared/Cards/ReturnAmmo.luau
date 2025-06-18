local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shotEvent_Listeners = require(ReplicatedStorage.Shared.Events.ShotEvent_Listeners)
local UIController = require(ReplicatedStorage.Shared.Hero.UIController)

type ShotData = shotEvent_Listeners.ShotData

local returnAmmo_Module = {
	cardStack = 1,
}

function returnAmmo_Module.StartUp(data: ShotData)
	if data.target ~= nil and returnAmmo_Module.AmmoReturned() then
		data.constant.ammo.current_ammo += 1
		UIController.UpdateAmmoDisplay(data.constant)
	end
end

function returnAmmo_Module.AmmoReturned()
	local rng = math.random(1, 100)
	if rng <= returnAmmo_Module.cardStack * 5 then
		return true
	else
		return false
	end
end

function returnAmmo_Module.AddAsListener()
	table.insert(shotEvent_Listeners, {
		id = HttpService:GenerateGUID(),
		method = returnAmmo_Module.StartUp,
	})
end

return returnAmmo_Module
