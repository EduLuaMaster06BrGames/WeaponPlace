local Players = game:GetService("Players")

local HeroSelectionUI = Players.LocalPlayer.PlayerGui:WaitForChild("HeroSelection")

local mainFrame = HeroSelectionUI.Frame
local primaryFrame = mainFrame:WaitForChild("PrimaryViewportFrame")
local secondaryFrame = mainFrame:WaitForChild("SecondaryViewportFrame")
local utilityFrame = mainFrame:WaitForChild("UtilityViewportFrame")

local nextButton_Primary: TextButton = primaryFrame.NextButton
local nextButton_Secondary: TextButton = secondaryFrame.NextButton
local nextButton_Utility: TextButton = utilityFrame.NextButton

local previousButton_Primary: TextButton = primaryFrame.PreviousButton
local previousButton_Secondary: TextButton = secondaryFrame.PreviousButton
local previousButton_Utility: TextButton = utilityFrame.PreviousButton

local currentLabel_Primary = primaryFrame.CurrentLabel
local currentLabel_Secondary = secondaryFrame.CurrentLabel
local currentLabel_Utility = utilityFrame.CurrentLabel

local viewportCamera_Primary
local viewportCamera_Secondary
local viewportCamera_Utility

type UIConnector = {
	reference: Part,
	value: string,
}

local shotgun: UIConnector = {
	reference = primaryFrame.Models.Shotgun_Viewframe.Reference,
	value = "Shotgun",
}

local rifle: UIConnector = {
	reference = primaryFrame.Models.Rifle_Viewframe.Reference,
	value = "Rifle",
}

local dmr: UIConnector = {
	reference = primaryFrame.Models.DMR_Viewframe.Reference,
	value = "DMR",
}

local pistol: UIConnector = {
	reference = secondaryFrame.Models.Pistol_Viewframe.Reference,
	value = "Pistol",
}

local deagle: UIConnector = {
	reference = secondaryFrame.Models.Deagle_Viewframe.Reference,
	value = "Deagle",
}

local ammoBox: UIConnector = {
	reference = utilityFrame.Models.AmmoBox_Viewframe.Reference,
	value = "AmmoBox",
}

local healingArea: UIConnector = {
	reference = utilityFrame.Models.HealingArea_Viewframe.Reference,
	value = "HealingAreaa",
}

local UIConfig: { { UIConnector } } = {
	[1] = { shotgun, rifle, dmr },
	[2] = { pistol, deagle },
	[3] = { ammoBox, healingArea },
}

local UIController = {
	choosenPrimary = "Shotgun",
	choosenSecondary = "Pistol",
	choosenUtility = "AmmoBox",
	currentIndex_Primary = 1,
	currentIndex_Secondary = 1,
	currentIndex_Utility = 1,
	ableToDeploy = false,
}

function UpdateViewportCamera(camera: Camera, uiConnector: UIConnector)
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = uiConnector.reference.CFrame
end

function UpdatePrimary(moveBy: number)
	UIController.currentIndex_Primary += moveBy

	if moveBy > 0 then
		UIController.currentIndex_Primary = math.min(UIController.currentIndex_Primary, 3)
	else
		UIController.currentIndex_Primary = math.max(UIController.currentIndex_Primary, 1)
	end

	local uiConnector: UIConnector = GetUIConnectorByIndex(UIConfig[1], UIController.currentIndex_Primary)
	UpdateViewportCamera(viewportCamera_Primary, uiConnector)

	currentLabel_Primary.Text = uiConnector.value
end

function UpdateSecondary(moveBy: number)
	UIController.currentIndex_Secondary += moveBy

	if moveBy > 0 then
		UIController.currentIndex_Secondary = math.min(UIController.currentIndex_Secondary, 2)
	else
		UIController.currentIndex_Secondary = math.max(UIController.currentIndex_Secondary, 1)
	end
	local uiConnector: UIConnector = GetUIConnectorByIndex(UIConfig[2], UIController.currentIndex_Secondary)
	UpdateViewportCamera(viewportCamera_Secondary, uiConnector)

	currentLabel_Secondary.Text = uiConnector.value
end

function UpdateUtility(moveBy: number)
	UIController.currentIndex_Utility += moveBy

	if moveBy > 0 then
		UIController.currentIndex_Utility = math.min(UIController.currentIndex_Utility, 2)
	else
		UIController.currentIndex_Utility = math.max(UIController.currentIndex_Utility, 1)
	end

	local uiConnector: UIConnector = GetUIConnectorByIndex(UIConfig[3], UIController.currentIndex_Utility)
	UpdateViewportCamera(viewportCamera_Utility, uiConnector)

	currentLabel_Utility.Text = uiConnector.value
end

function GetUIConnectorByIndex(list: { UIConnector }, index: number)
	local counter = 1
	for _, element: UIConnector in pairs(list) do
		if counter == index then
			return element
		end

		counter += 1
	end
	return
end

function UIController.SetViewportCameras()
	viewportCamera_Primary = Instance.new("Camera", primaryFrame)
	viewportCamera_Secondary = Instance.new("Camera", secondaryFrame)
	viewportCamera_Utility = Instance.new("Camera", utilityFrame)

	primaryFrame.CurrentCamera = viewportCamera_Primary
	secondaryFrame.CurrentCamera = viewportCamera_Secondary
	utilityFrame.CurrentCamera = viewportCamera_Utility

	UpdateViewportCamera(viewportCamera_Primary, GetUIConnectorByIndex(UIConfig[1], 1))
	UpdateViewportCamera(viewportCamera_Secondary, GetUIConnectorByIndex(UIConfig[2], 1))
	UpdateViewportCamera(viewportCamera_Utility, GetUIConnectorByIndex(UIConfig[3], 1))
end

function UIController.SetClosures()
	print("set closures")
	nextButton_Primary.MouseButton1Click:Connect(function()
		UpdatePrimary(1)
	end)
	previousButton_Primary.MouseButton1Click:Connect(function()
		UpdatePrimary(-1)
	end)

	nextButton_Secondary.MouseButton1Click:Connect(function()
		UpdateSecondary(1)
	end)
	previousButton_Secondary.MouseButton1Click:Connect(function()
		UpdateSecondary(-1)
	end)

	nextButton_Utility.MouseButton1Click:Connect(function()
		UpdateUtility(1)
	end)
	previousButton_Utility.MouseButton1Click:Connect(function()
		UpdateUtility(-1)
	end)
end

return UIController
