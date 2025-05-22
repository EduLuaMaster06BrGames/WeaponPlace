local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local weaponController = require(ReplicatedStorage.Shared.WeaponController)
local constantPrimary = require(ReplicatedStorage.Shared.Constants.Constant_Primary)
local constantSecondary = require(ReplicatedStorage.Shared.Constants.Constant_Secondary)

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local current_WeaponController = nil

function ManageInput(input: InputObject)
	if input.KeyCode == Enum.KeyCode.One or input.KeyCode == Enum.KeyCode.Two then
		ChangeWeapon(input.KeyCode)
	elseif input.KeyCode == Enum.KeyCode.R then
		current_WeaponController:Reload()
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
	if current_WeaponController then
		current_WeaponController:Shoot()
	end
end

while player.Character == nil do
	wait()
end

print("Charcater loaded")
current_WeaponController = weaponController.new(constantPrimary)

mouse.Button1Down:Connect(ManageMouseInput)
UserInputService.InputBegan:Connect(ManageInput)
