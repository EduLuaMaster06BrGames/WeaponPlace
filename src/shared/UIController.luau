local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGUI = player.PlayerGui
local weaponUI = playerGUI:WaitForChild("WeaponUI")
local ammoUI = weaponUI:WaitForChild("AmmoUI")
local primaryDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("PrimaryDisplay")
local secondaryDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("SecondaryDisplay")
local ammoDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("AmmoDisplay")
local reserveAmmoDisplay: TextLabel = ammoUI.MainFrame:FindFirstChild("ReserveAmmoDisplay")

export type Constant = {
	damage: number,
	speed: number,
	ammo: {
		current_ammo: number,
		mag_size: number,
		reserve_ammo: number,
	},
	accuracy: {
		min_accuracy: number,
		max_accuracy: number,
		recovery_rate: number,
		recoil_rate: number,
	},
	reload_time: number,
	mode: string,
	type: string,
	multiplier: {
		head: number,
		body: number,
	},
}

local UIController = {}
UIController.__index = UIController

function UIController.new(constant: Constant)
	local self = {
		constant = constant,
	}

	setmetatable(self, UIController)
	self:Inicialize()
	return self
end

function UIController:Inicialize()
	ammoUI.Enabled = true
	self:SetWeaponDisplay()
	self:UpdateAmmoDisplay()
end

function UIController:UpdateAmmoDisplay()
	ammoDisplay.Text = tostring(self.constant.ammo.current_ammo) .. "/" .. tostring(self.constant.ammo.mag_size)
	reserveAmmoDisplay.Text = tostring(self.constant.ammo.reserve_ammo)
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

function UIController:UpdateConstant(newConstant: Constant)
	self.constant = newConstant
	self:SetWeaponDisplay()
	self:UpdateAmmoDisplay()
end

function UIController:Remove()
	self.constant = nil
	ammoUI.Enabled = false
	setmetatable(self, nil)
end

return UIController
