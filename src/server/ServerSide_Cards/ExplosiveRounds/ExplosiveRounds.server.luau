local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local cardEvents = ReplicatedStorage.CardEvents
local explosiveRoundsEvent: RemoteEvent = cardEvents.ExplosiveRounds

local cardStorage = ReplicatedStorage.CardStuff
local explosionPart = cardStorage.ExplosiveRounds.ExplosionPart

function CreateExplosion(player: Player, hitPos: Vector3, damageDelt: number, cardStack: number)
	local explosionRadius = cardStack * 1.5 / 2
	local partsInPart = workspace:GetPartBoundsInRadius(hitPos, explosionRadius)
	local alreadyDamagedEnemies = {}

	for _, element in pairs(partsInPart) do
		if
			element.Parent:FindFirstChild("Humanoid")
			and not AlreadyDamaged(alreadyDamagedEnemies, element.Parent.Name)
		then
			element.Parent.Humanoid.Health -= damageDelt * 0.15 * cardStack
			table.insert(alreadyDamagedEnemies, element.Parent.Name)
		end
	end

	SetExplosionVisual(hitPos, Vector3.new(explosionRadius, explosionRadius, explosionRadius))
end

function AlreadyDamaged(damagedPlayers: { string }, name: string)
	for _, element in pairs(damagedPlayers) do
		if element == name then
			return true
		end
	end

	return false
end

function SetExplosionVisual(hitPos: Vector3, explosionRadius: Vector3)
	local newExplosionPart: Part = explosionPart:Clone()
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local goals = {
		Size = explosionRadius,
		Transparency = 1,
	}

	newExplosionPart.Parent = workspace
	newExplosionPart.Position = hitPos
	local tween = TweenService:Create(newExplosionPart, tweenInfo, goals)
	tween:Play()

	tween.Completed:Connect(function()
		newExplosionPart:Destroy()
	end)
end

explosiveRoundsEvent.OnServerEvent:Connect(CreateExplosion)
