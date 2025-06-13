local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local utilityEvents = ReplicatedStorage.UtilityEvents
local healingAreaEvents = utilityEvents.HealingArea
local createHealingAreaEvent: RemoteEvent = healingAreaEvents.CreateHealingArea

local utilityStuff = ServerStorage.UtilityStuff
local healingAreaStorage = utilityStuff.HealingArea
local healingAreaModel: Model = healingAreaStorage.HealingAreaModel

local utilityConstantType = require(ReplicatedStorage.Shared.Hero.Utility.Default.Constant_Utility)
local utilityBuffListType = require(ReplicatedStorage.Shared.Hero.Utility.Default.UtilityBuffsList)

type UtilityConstant = utilityConstantType.UtilityConstant
type UtilityBuffs = utilityBuffListType.UtilityBuffs

function CreateHealingArea(player: Player, utilityConstant: UtilityConstant, buffList: UtilityBuffs)
	local character = player.Character
	local humanoid = character:FindFirstChild("Humanoid")

	if humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then
		local newHealingAreaModel = healingAreaModel:Clone()
		PlaceModel(newHealingAreaModel, character)
		task.spawn(HealingAreaTask, newHealingAreaModel, player, utilityConstantType, buffList)
		return
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
				Vector3.new(result.Position.X, result.Position.Y + 0.5, result.Position.Z)
			) * CFrame.fromOrientation(0, math.rad(90), math.rad(90))
			model:PivotTo(groundPos)
		end
	end
end

function HealingAreaTask(model: Model, Player: Player, utilityConstant: UtilityConstant, buffList: UtilityBuffs)
	print("Task started with model: ", model)
	local duration = utilityConstant.duration
	local startedAt = os.clock()
	local hitbox = model:FindFirstChild("Hitbox")

	repeat
		local healedPlayers = {}
		local partsInPart = workspace:GetPartsInPart(hitbox)
		for _, element in pairs(partsInPart) do
			if element.Parent:FindFirstChild("Humanoid") and not AlreadyHealed(healedPlayers, element.Parent.Name) then
				if
					element.Parent.Humanoid.Health > 0
					or element.Parent.Humanoid.Health == element.Parent.Humanoid.MaxHealth
				then
					table.insert(healedPlayers, element.Parent.Name)
					element.Parent.Humanoid.Health += utilityConstant.power * buffList.power
					print("Healing: ", element.Parent.Name, " for: ", utilityConstant.power * buffList.power)
				else
					table.insert(healedPlayers, element.Parent.Name)
				end
			end
		end
		table.clear(healedPlayers)
		wait(0.05)
	until (os.clock() - startedAt) >= duration

	model:Destroy()
	return
end

function AlreadyHealed(healedPlayers: { string }, name: string)
	for _, element in pairs(healedPlayers) do
		if element == name then
			return true
		end
	end

	return false
end

createHealingAreaEvent.OnServerEvent:Connect(CreateHealingArea)
