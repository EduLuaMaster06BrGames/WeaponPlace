local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character

local UpdateHumanoid: BindableFunction = script:WaitForChild("UpdateHumanoid")

local HConstantType = require(ReplicatedStorage.Shared.Types.HumanoidConstantType)
type HConstantType = HConstantType.HumanoidConstants

local humanoidConstant: HConstantType = require(ReplicatedStorage.Shared.Humanoid.Constant_Humanoid)
local humanoid: Humanoid = character:FindFirstChild("Humanoid")

while not character do
	character = player.Character
	wait()
end

humanoidConstant:SetBind(UpdateHumanoid)
