local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character

while not character do
	character = player.Character
	wait()
end

local playerUI = player.PlayerGui
local humanoidUI = playerUI.HumanoidUI
local mainFrame = humanoidUI.MainFrame
local healthBar: Frame = mainFrame.HealthBar
local healthLabel: TextLabel = mainFrame.HealthLabel

local HConstantType = require(ReplicatedStorage.Shared.Hero.Types.HumanoidConstantType)
type HConstantType = HConstantType.HumanoidConstants

local humanoidConstant: HConstantType = require(ReplicatedStorage.Shared.Hero.Humanoid.Constant_Humanoid)
local humanoid: Humanoid = character:FindFirstChild("Humanoid")

local humanoidController = {}

function humanoidController.UpdateUI(newVal: number?)
	if newVal then
		healthLabel.Text = math.round(character.Humanoid.Health) .. "/" .. tostring(newVal)
		UpdateHealthBar(character.Humanoid.Health, humanoidConstant.MaxHealth)
	else
		healthLabel.Text = math.round(character.Humanoid.Health) .. "/" .. tostring(humanoidConstant.MaxHealth)
		UpdateHealthBar(character.Humanoid.Health, humanoidConstant.MaxHealth)
	end
end

function UpdateHealthBar(health, maxHealth)
	local porcentagem = math.clamp(health / maxHealth, 0, 1)

	healthBar.Size = UDim2.new(porcentagem, 0, 0.131, 0)
end

function humanoidController.ApplyToHumanoid(key: string, newVal: number)
	humanoid[key] = newVal
	humanoidController.UpdateUI(newVal)
end

function humanoidController.RegenTask()
	while wait(0.1) do
		if humanoid.Health < humanoid.MaxHealth then
			humanoid.Health += humanoidConstant.BaseRegen
		end
	end
end

return humanoidController
