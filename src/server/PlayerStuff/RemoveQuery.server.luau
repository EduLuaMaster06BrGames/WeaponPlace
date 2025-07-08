local Players = game:GetService("Players")

local function onCharacterAdded(character)
	for _, descendant in ipairs(character:GetDescendants()) do
		if not descendant:IsA("BasePart") and descendant:IsA("Instance") then
			local success = pcall(function()
				descendant.CanQuery = false
			end)
		end
	end
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
