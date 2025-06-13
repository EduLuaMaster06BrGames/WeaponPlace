local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local weaponController = require(ReplicatedStorage.Shared.Hero.WeaponController)
local constantPrimary = require(ReplicatedStorage.Shared.Hero.Weapon.Constant_Primary)
local constantSecondary = require(ReplicatedStorage.Shared.Hero.Weapon.Constant_Secondary)

local utilityFolder = ReplicatedStorage.Shared.Hero.Utility
local utilityController = require(utilityFolder.Default.UtilityController)

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local clicking = false

local current_WeaponController = nil

function ManageInput(input: InputObject)
	if input.KeyCode == Enum.KeyCode.One or input.KeyCode == Enum.KeyCode.Two then
		ChangeWeapon(input.KeyCode)
	elseif input.KeyCode == Enum.KeyCode.R then
		current_WeaponController:Reload()
	elseif input.KeyCode == Enum.KeyCode.E then
		UseUtility()
	end
end

function UseUtility()
	local previousWeaponConstant

	if utilityController.AbleToInicialize() then
		if current_WeaponController then
			previousWeaponConstant = current_WeaponController.constant
			current_WeaponController:Remove()
			current_WeaponController = nil
		end
		utilityController.start()
		current_WeaponController = weaponController.new(previousWeaponConstant)
	end
end

function ChangeWeapon(keyCode: Enum.KeyCode)
	if keyCode == Enum.KeyCode.One then
		if current_WeaponController and current_WeaponController.weapon_type ~= "Primary" then
			current_WeaponController:Remove()
			current_WeaponController = weaponController.new(constantPrimary)
		end
	else
		if current_WeaponController and current_WeaponController.weapon_type ~= "Secondary" then
			current_WeaponController:Remove()
			current_WeaponController = weaponController.new(constantSecondary)
		end
	end
end

function ManageMouseInput()
	if clicking then
		if current_WeaponController ~= nil and current_WeaponController.constant.mode == "Auto" then
			current_WeaponController:Shoot()
		elseif current_WeaponController ~= nil and current_WeaponController.constant.mode == "Semi" then
			current_WeaponController:Shoot()
			clicking = false
		end
	end
end

while player.Character == nil do
	wait()
end

print("Charcater loaded")
current_WeaponController = weaponController.new(constantPrimary)

mouse.Button1Down:Connect(function()
	clicking = true
end)
mouse.Button1Up:Connect(function()
	clicking = false
end)

UserInputService.InputBegan:Connect(ManageInput)
RunService.RenderStepped:Connect(ManageMouseInput)
