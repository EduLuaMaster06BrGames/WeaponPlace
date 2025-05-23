local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGUI = player.PlayerGui
local weaponUI = playerGUI:WaitForChild("WeaponUI")
local ammoUI = playerGUI:WaitForChild("AmmoUI")

local UIController = {}
UIController.__index = UIController

function UIController.new()
	local self = {
		constant = ReplicatedStorage.Shared.Constants.Constant_Primary,
	}

	setmetatable(self, UIController)
	self:Inicialize()
	return self
end

function UIController:Inicialize() end
