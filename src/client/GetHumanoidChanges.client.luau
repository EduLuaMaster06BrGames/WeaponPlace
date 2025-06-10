local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local humanoidController = require(ReplicatedStorage.Shared.Hero.HumanoidController)
local player = Players.LocalPlayer
local character = player.Character

while not character do
	character = player.Character
	wait()
end

character.Humanoid.HealthChanged:Connect(function()
	humanoidController.UpdateUI()
end)
