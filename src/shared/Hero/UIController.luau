local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGUI = player.PlayerGui
local weaponUI = playerGUI:WaitForChild("WeaponUI")
local ammoUI = weaponUI:WaitForChild("AmmoUI")
local primaryDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("PrimaryDisplay")
local secondaryDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("SecondaryDisplay")
local ammoDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("AmmoDisplay")
local reserveAmmoDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("ReserveAmmoDisplay")

local constType = require(ReplicatedStorage.Shared.Hero.Types.WeaponConstantType)
type Constant = constType.Constant

local UIController = {}
UIController.__index = UIController

function UIController.new(constant: Constant)
	local self = {
		constant = constant,
		humanoid_listener_id = "",
	}

	setmetatable(self, UIController)
	self:Inicialize()
	return self
end

function UIController:Inicialize()
	ammoUI.Enabled = true
	self:SetWeaponDisplay()
	self.UpdateAmmoDisplay(self.constant)
end

function UIController.UpdateAmmoDisplay(constant)
	ammoDisplay.Text = tostring(constant.ammo.current_ammo) .. "/" .. tostring(constant.ammo.mag_size)
	reserveAmmoDisplay.Text = tostring(constant.ammo.reserve_ammo)
end

function UIController:SetWeaponDisplay()
	if self.constant.type == "Primary" then
		primaryDisplay.TextTransparency = 0
		secondaryDisplay.TextTransparency = 0.6
	else
		primaryDisplay.TextTransparency = 0.6
		secondaryDisplay.TextTransparency = 0
	end
end

function UIController:UpdateConstant(newConstant: constType.Constant)
	self.constant = newConstant
	self:SetWeaponDisplay()
	self.UpdateAmmoDisplay(self.constant)
end

function UIController:Remove()
	self.constant = nil
	ammoUI.Enabled = false
	setmetatable(self, nil)
end

function UIController.UpdateHealthUI(_, newValue: number) end

return UIController
