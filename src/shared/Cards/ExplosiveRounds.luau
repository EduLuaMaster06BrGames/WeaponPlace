local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shotEvent_Listeners = require(ReplicatedStorage.Shared.Events.ShotEvent_Listeners)
local cardEvents = ReplicatedStorage.CardEvents
local explosiveRoundsEvent: RemoteEvent = cardEvents:FindFirstChild("ExplosiveRounds")

type ShotData = shotEvent_Listeners.ShotData

local explosiveRounds_Module = {
	cardStack = 5,
}

function explosiveRounds_Module.StartUp(data: ShotData)
	print(data.target)

	if data.hit ~= nil then
		if data.damage == 0 then
			data.damage = data.constant.damage / 2
		end

		explosiveRoundsEvent:FireServer(data.hit, data.damage, explosiveRounds_Module.cardStack)
	end
end

function explosiveRounds_Module.AddAsListener()
	table.insert(shotEvent_Listeners, {
		id = HttpService:GenerateGUID(),
		method = explosiveRounds_Module.StartUp,
	})
end

return explosiveRounds_Module
