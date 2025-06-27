local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local heroCreationEvents = ReplicatedStorage.HeroCreationEvents
local getHeroConfig: RemoteFunction = heroCreationEvents.GetHeroConfig

local weaponStorage = ServerScriptService.Server.WeaponStorage
local utilityStorage = ServerScriptService.Server.UtilityStorage
local humanoidStorage = ServerScriptService.Server.HumanoidStorage

local heroDataType = require(ReplicatedStorage.Shared.Hero.Types.HeroDataType)
type HeroData = heroDataType.HeroData
type HeroConfig = heroDataType.HeroConfig

function ManageHeroData(player: Player, heroData: HeroData)
	local heroConfig: HeroConfig = GetWeaponData(heroData)
	return heroConfig
end

function GetWeaponData(heroData: HeroData): HeroConfig
	local primaryConfig = require(weaponStorage.Primary:FindFirstChild(heroData.primary_weapon .. "_Config"))
	local secondaryConfig = require(weaponStorage.Secondary:FindFirstChild(heroData.secondary_weapon .. "_Config"))
	local utilityConfig = require(utilityStorage:FindFirstChild(heroData.utility .. "_Config"))

	local primaryVM = ReplicatedStorage.ViewmodelStorage.Primary:FindFirstChild("Viewmodel_" .. heroData.primary_weapon)
	local secondaryVM =
		ReplicatedStorage.ViewmodelStorage.Secondary:FindFirstChild("Viewmodel_" .. heroData.secondary_weapon)

	local newHeroConfig: HeroConfig = {
		weapon_constants = {
			primary = primaryConfig,
			secondary = secondaryConfig,
		},
		utility_constants = {
			utility = utilityConfig,
		},
		humanoid_constants = {
			humanoid = require(humanoidStorage.DefaultHumanoid_Config),
		},
		weapon_viewmodels = {
			primary = primaryVM,
			secondary = secondaryVM,
		},
		utility_viewmodels = {
			utility = nil,
		},
	}

	return newHeroConfig
end

getHeroConfig.OnServerInvoke = ManageHeroData
