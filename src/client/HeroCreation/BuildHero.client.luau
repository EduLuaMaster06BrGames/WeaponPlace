local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local characterCreationModule = require(script.Parent.CharacterCreation)
local HeroSelectionUI = Players.LocalPlayer.PlayerGui:WaitForChild("HeroSelection")

local heroCreationEvents = ReplicatedStorage.HeroCreationEvents
local getHeroConfig: RemoteFunction = heroCreationEvents.GetHeroConfig

local hero = ReplicatedStorage.Shared.Hero
local clientScripts = Players.LocalPlayer.PlayerScripts.Client

local heroDataType = require(ReplicatedStorage.Shared.Hero.Types.HeroDataType)
type HeroData = heroDataType.HeroData
type HeroConfig = heroDataType.HeroConfig

function ManageHeroCreation()
	if characterCreationModule.ableToDeploy then
		local choosenPrimary = characterCreationModule.choosenPrimary
		local choosenSecondary = characterCreationModule.choosenSecondary
		local choosenUtility = characterCreationModule.choosenUtility
		local heroData: HeroData = {
			primary_weapon = choosenPrimary,
			secondary_weapon = choosenSecondary,
			utility = choosenUtility,
		}

		local heroConfig: HeroConfig = getHeroConfig:InvokeServer(heroData)

		if heroConfig then
			SetUpConfig(heroConfig)
			EnableWeapon()
			HeroSelectionUI.Enabled = false
		end
	end
end

function EnableWeapon()
	clientScripts.ActionController.Enabled = true
	clientScripts.GetHumanoidChanges.Enabled = true
	clientScripts.SetDefaultListeners.Enabled = true
end

function SetUpConfig(heroConfig: HeroConfig)
	SetUpViewmodels(heroConfig)
	SetUpConstantsConstants(heroConfig)
end

function SetUpViewmodels(heroConfig: HeroConfig)
	local newPrimaryVM = heroConfig.weapon_viewmodels.primary:Clone()
	local newSecondaryVM = heroConfig.weapon_viewmodels.secondary:Clone()

	newPrimaryVM.Parent = ReplicatedStorage.Viewmodels.Weapon
	newPrimaryVM.Name = "Viewmodel_Primary"
	newSecondaryVM.Parent = ReplicatedStorage.Viewmodels.Weapon
	newSecondaryVM.Name = "Viewmodel_Secondary"
end

function SetUpConstantsConstants(heroConfig: HeroConfig)
	local primaryModule = require(hero.Weapon.Constant_Primary)
	local newConstants_Primary = heroConfig.weapon_constants.primary

	local secondaryModule = require(hero.Weapon.Constant_Secondary)
	local newConstants_Secondary = heroConfig.weapon_constants.secondary

	local utilityModule = require(hero.Utility.Default.Constant_Utility)
	local utilityConfig = require(hero.Utility.Utility)
	local newConstants_Utility = heroConfig.utility_constants.utility.utilityConstants
	local newConfig_Utility = heroConfig.utility_constants.utility.utilityConfig

	local humanoidModule = require(hero.Humanoid.Constant_Humanoid)
	local newConstants_Humanoid = heroConfig.humanoid_constants.humanoid

	for key, value in pairs(newConstants_Primary) do
		primaryModule[key] = value
	end
	for key, value in pairs(newConstants_Secondary) do
		secondaryModule[key] = value
	end
	for key, value in pairs(newConfig_Utility) do
		utilityConfig[key] = value
	end
	for key, value in pairs(newConstants_Utility) do
		utilityModule[key] = value
	end
	for key, value in pairs(newConstants_Humanoid) do
		humanoidModule[key] = value
	end
end

characterCreationModule.SetViewportCameras()
characterCreationModule.SetClosures()
