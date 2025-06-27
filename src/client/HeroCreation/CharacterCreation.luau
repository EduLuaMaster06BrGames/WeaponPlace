local Players = game:GetService("Players")

local HeroSelectionUI = Players.LocalPlayer.PlayerGui:WaitForChild("HeroSelection")

local primaryFrame = HeroSelectionUI:WaitForChild("PrimaryWeapon_Frame")
local utilityFrame = HeroSelectionUI:WaitForChild("Utility_Frame")
local secondaryFrame = HeroSelectionUI:WaitForChild("SecondaryWeapon_Frame")

local deployButton: TextButton = HeroSelectionUI:WaitForChild("Deploy_Button")

local shotgunButton: TextButton = primaryFrame:WaitForChild("Shotgun_Button")
local rifleButton: TextButton = primaryFrame:WaitForChild("Rifle_Button")
local dmrButton: TextButton = primaryFrame:WaitForChild("DMR_Button")

local pistolButton: TextButton = secondaryFrame:WaitForChild("Pistol_Button")
local deagleButton: TextButton = secondaryFrame:WaitForChild("Deagle_Button")

local ammoBoxButton: TextButton = utilityFrame:WaitForChild("AmmoBox_Button")
local healingAreaButton: TextButton = utilityFrame:WaitForChild("HealingArea_Button")
local punchButton: TextButton = utilityFrame:WaitForChild("Punch_Button")

local UIController = {
	primaryButtons = { shotgunButton, rifleButton, dmrButton },
	secondaryButtons = { pistolButton, deagleButton },
	utilityButtons = { ammoBoxButton, healingAreaButton, punchButton },
	ableToDeploy = false,
	choosenPrimary = nil,
	choosenSecondary = nil,
	choosenUtility = nil,
}

function UIController.UpdateDeployStatus()
	if UIController.choosenPrimary and UIController.choosenSecondary and UIController.choosenUtility then
		deployButton.BackgroundColor3 = Color3.fromRGB(10, 255, 10)
		UIController.ableToDeploy = true
	end
end

function UIController.RemoveBorders(buttonList: { TextButton })
	for _, element in pairs(buttonList) do
		element.BorderSizePixel = 0
	end
end

function UIController.SetBorder(button: TextButton, buttonList: { TextButton })
	UIController.RemoveBorders(buttonList)
	button.BorderSizePixel = 3
end

function UIController.UpdatePrimary(button: TextButton, buttonList: { TextButton })
	UIController.choosenPrimary = button.Name:gsub("_Button", "")
	UIController.SetBorder(button, buttonList)
end

function UIController.UpdateUtility(button: TextButton, buttonList: { TextButton })
	UIController.choosenUtility = button.Name:gsub("_Button", "")
	UIController.SetBorder(button, buttonList)
end

function UIController.UpdateSecondary(button: TextButton, buttonList: { TextButton })
	UIController.choosenSecondary = button.Name:gsub("_Button", "")
	UIController.SetBorder(button, buttonList)
end

function UIController.ConnectButton(buttonList, callback)
	for _, button in buttonList do
		button.MouseButton1Click:Connect(function()
			callback(button, buttonList)
			UIController.UpdateDeployStatus()
		end)
	end
end

return UIController
