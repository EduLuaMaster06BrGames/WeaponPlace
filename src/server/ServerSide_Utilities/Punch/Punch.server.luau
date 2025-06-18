local ReplicatedStorage = game:GetService("ReplicatedStorage")
local utilityEvetns = ReplicatedStorage.UtilityEvents
local createPunchEvent: RemoteEvent = utilityEvetns.Punch.CreatePunch

local utilityConstantType = require(ReplicatedStorage.Shared.Hero.Utility.Default.Constant_Utility)
local utilityBuffListType = require(ReplicatedStorage.Shared.Hero.Utility.Default.UtilityBuffsList)

local PUNCH_RANGE = 5

type UtilityConstant = utilityConstantType.UtilityConstant
type UtilityBuffs = utilityBuffListType.UtilityBuffs

function CreatePunch(player: Player, utilityConstant: UtilityConstant, buffList: UtilityBuffs)
	local character = player.Character

	if character then
		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then
			local humanoidRootPart = character.PrimaryPart

			if humanoidRootPart and humanoidRootPart:IsA("Part") then
				local origin: Vector3 = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 1
				local targets = EnemiesInRange(origin)

				for i = 1, #targets do
					if targets[i]:GetAttribute("Enemy") then
						FlingEnemy(targets[i], humanoidRootPart)
					end
				end
			end
		end
	end
end

function FlingEnemy(target, heroRootPart: Part)
	if not target or not target.PrimaryPart then
		return
	end

	target.Humanoid.Sit = true
	target.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	local heroPos = heroRootPart.Position
	local enemyPos = target.PrimaryPart.Position

	local baseDirection = (enemyPos - heroPos).Unit

	local randomAngle = math.rad(math.random(-15, 15))
	local axis = Vector3.new(0, 1, 0)
	local rotatedDirection = CFrame.fromAxisAngle(axis, randomAngle):VectorToWorldSpace(baseDirection)

	local upVector = Vector3.new(0, 1, 0)
	local finalDirection = (rotatedDirection + upVector * 0.5).Unit

	target.PrimaryPart:ApplyImpulse(finalDirection * 1000)
end

function EnemiesInRange(origin: Vector3)
	local partInRadius = workspace:GetPartBoundsInRadius(origin, PUNCH_RANGE)
	local targets = {}

	for _, element in pairs(partInRadius) do
		if element.Parent:FindFirstChild("Humanoid") and not AlreadyAdded(targets, element.Parent) then
			table.insert(targets, element.Parent)
		end
	end

	return targets
end

function AlreadyAdded(targets: {}, currentTarget)
	for _, element in pairs(targets) do
		if element == currentTarget then
			return true
		end
	end

	return false
end

createPunchEvent.OnServerEvent:Connect(CreatePunch)
