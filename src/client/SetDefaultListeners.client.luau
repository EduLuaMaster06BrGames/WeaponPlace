-- DISABLED

-- File used for testing, will probably be removed later
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local humanoidController = require(ReplicatedStorage.Shared.Hero.HumanoidController)
local humanoidConstant = require(ReplicatedStorage.Shared.Hero.Humanoid.Constant_Humanoid)
local HumanoidConstantType = require(ReplicatedStorage.Shared.Hero.Types.HumanoidConstantType)

-- testing cards
local emptyReload = require(ReplicatedStorage.Shared.Cards.EmptyReload)
local returnAmmoCard = require(ReplicatedStorage.Shared.Cards.ReturnAmmo)
local explosiveRounds = require(ReplicatedStorage.Shared.Cards.ExplosiveRounds)

type Listener = HumanoidConstantType.Listener

local defaultListener: Listener = {
	Id = HttpService:GenerateGUID(),
	ListeningTo = {
		"MaxHealth",
		"WalkSpeed",
	},
	Method = humanoidController.ApplyToHumanoid,
}

humanoidConstant:AddListener(defaultListener)

emptyReload.AddAsListener()
returnAmmoCard.AddAsListener()
explosiveRounds.AddAsListener()

task.spawn(humanoidController.RegenTask)

-- DISABLED
