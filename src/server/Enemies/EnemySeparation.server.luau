local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local activeEnemiesData = require(replicatedStorage.Shared.Enemies.ActiveEnemies)
local hitboxes = {}

function ManageSeparation()
	UpdateHitboxList()
	ResetAll()
	SetSeparationForce()
end

function UpdateHitboxList()
	table.clear(hitboxes)

	for _, element: Model in pairs(activeEnemiesData.enemies) do
		local sepHitbox = element:FindFirstChild("SeparationHitbox")

		if sepHitbox then
			table.insert(hitboxes, sepHitbox)
		end
	end
end

function SetNetwork()
	for i = 1, #hitboxes do
		local enemy = hitboxes[i].Parent

		for _, element in pairs(enemy:GetDescendants()) do
			if element:IsA("Part") then
				element:SetNetworkOwner(nil)
			end
		end
	end
end

function ResetAll()
	for i = 1, #hitboxes do
		hitboxes[i].Parent:SetAttribute("SeparationForce", Vector3.new(0, 0, 0))
	end
end

function SetSeparationForce()
	for i = 1, #hitboxes do
		local sepHitbox = hitboxes[i]

		if
			sepHitbox:GetAttribute("SeparationHitbox") == true
			and sepHitbox
			and hitboxes[i].Parent.Humanoid.Health > 0
		then
			local params = OverlapParams.new()
			params.FilterType = Enum.RaycastFilterType.Include
			params.FilterDescendantsInstances = hitboxes
			local overlap = workspace:GetPartsInPart(sepHitbox, params)

			if #overlap > 0 then
				for i = 1, #overlap do
					local separationForce = overlap[i]:GetAttribute("SeparationHitbox")

					if separationForce then
						overlap[i].Parent:SetAttribute(
							"SeparationForce",
							(overlap[i].Position - sepHitbox.Position).Unit * 13
						)
					end
				end
			end
		end
	end
end

SetNetwork()
runService.Heartbeat:Connect(ManageSeparation)
