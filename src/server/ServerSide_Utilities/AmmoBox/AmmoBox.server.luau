local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local utilityEvents = ReplicatedStorage.UtilityEvents
local ammoBoxEvents = utilityEvents.AmmoBox
local createAmmoBoxEvent: RemoteEvent = ammoBoxEvents.CreateAmmoBox

local utilityStuff = ServerStorage.UtilityStuff
local ammoBoxStorage = utilityStuff.AmmoBox
local ammoBoxModel: Model = ammoBoxStorage.AmmoBox

local utilityConstantType = require(ReplicatedStorage.Shared.Hero.Utility.Default.Constant_Utility)
local utilityBuffListType = require(ReplicatedStorage.Shared.Hero.Utility.Default.UtilityBuffsList)

type UtilityConstant = utilityConstantType.UtilityConstant
type UtilityBuffs = utilityBuffListType.UtilityBuffs

function CreateAmmoBox(player: Player, utilityConstant: UtilityConstant, buffList: UtilityBuffs)
	local character = player.Character
	local humanoid = character:FindFirstChild("Humanoid")

	if humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then
		local newAmmoBoxModel = ammoBoxModel:Clone()
		PlaceModel(newAmmoBoxModel, character)
		SetAmmo(utilityConstant, buffList, newAmmoBoxModel)
		return
	end
end

function SetAmmo(utilityConstant: UtilityConstant, buffList: UtilityBuffs, ammoBox: Model)
	local ammoStoraged = ammoBox:FindFirstChild("AmmoStoraged")
	local maxAmmoStoraged = ammoBox:FindFirstChild("MaxAmmoStoraged")

	if ammoStoraged and ammoStoraged:IsA("IntValue") then
		ammoStoraged.Value = utilityConstant.power * buffList.power

		if maxAmmoStoraged and maxAmmoStoraged:IsA("IntValue") then
			maxAmmoStoraged.Value = utilityConstant.power * buffList.power
		end
	end
end

function PlaceModel(model: Model, character: Model)
	if character.PrimaryPart then
		local origin: Vector3 = character.PrimaryPart.Position
		local direction: Vector3 = Vector3.new(0, -1, 0)

		local params: RaycastParams = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { character }

		local result = workspace:Raycast(origin, direction * 100, params)

		if result then
			model.Parent = workspace
			local groundPos: CFrame = CFrame.new(
				Vector3.new(result.Position.X, result.Position.Y + 1.125, result.Position.Z)
			) * CFrame.fromOrientation(0, 0, 0)
			model:PivotTo(groundPos)
		end
	end
end

createAmmoBoxEvent.OnServerEvent:Connect(CreateAmmoBox)
