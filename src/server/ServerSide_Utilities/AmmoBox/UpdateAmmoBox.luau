local ReplicatedStorage = game:GetService("ReplicatedStorage")
local utilityEvents = ReplicatedStorage.UtilityEvents
local reloadReserveRF: RemoteFunction = utilityEvents.AmmoBox.ReloadReserve
local sendAmmoEvent: RemoteEvent = utilityEvents.AmmoBox.SendAmmo

local updateAmmoBoxModule = {}

function updateAmmoBoxModule.UpdateAmmo(player: Player, ammoBox: Model)
	local ammoStoraged = ammoBox:FindFirstChild("AmmoStoraged")

	if ammoBox and ammoStoraged and ammoStoraged:IsA("IntValue") and ammoStoraged.Value > 0 then
		local ammoNeeded = reloadReserveRF:InvokeClient(player)

		if ammoNeeded and ammoNeeded > 0 then
			local ammoLeft = ammoStoraged.Value - ammoNeeded

			if ammoLeft > 0 then
				ammoStoraged.Value -= ammoNeeded
				UpdateAmmoBar(ammoBox)
				print("Sending: " .. tostring(ammoNeeded))
				sendAmmoEvent:FireClient(player, ammoNeeded)
			else
				ammoLeft = ammoStoraged.Value
				ammoStoraged.Value = 0
				UpdateAmmoBar(ammoBox)
				print("Sending: " .. tostring(ammoLeft))
				sendAmmoEvent:FireClient(player, ammoLeft)
			end
		end
	end
end

function UpdateAmmoBar(ammoBox: Model)
	local ammoStoraged = ammoBox:FindFirstChild("AmmoStoraged")
	local maxAmmoStoraged = ammoBox:FindFirstChild("MaxAmmoStoraged")
	local ammoBox_BillBoardUI = ammoBox:FindFirstChild("AmmoBox_BillBoardUI")

	if ammoBox and ammoStoraged and ammoStoraged:IsA("IntValue") and ammoStoraged.Value > 0 then
		local ammoBar_1 = ammoBox:FindFirstChild("AmmoBar_1")
		local ammoBar_2 = ammoBox:FindFirstChild("AmmoBar_2")

		if ammoBar_1 and ammoBar_2 and ammoBar_1:IsA("Part") and ammoBar_2:IsA("Part") then
			if maxAmmoStoraged and maxAmmoStoraged:IsA("IntValue") then
				local sizePercentage = ammoStoraged.Value / maxAmmoStoraged.Value
				ammoBar_1.Size = Vector3.new(ammoBar_1.Size.X * sizePercentage, ammoBar_1.Size.Y, ammoBar_1.Size.Z)
				ammoBar_2.Size = Vector3.new(ammoBar_2.Size.X * sizePercentage, ammoBar_2.Size.Y, ammoBar_2.Size.Z)

				if ammoBox_BillBoardUI then
					ammoBox_BillBoardUI.AmmoLabel.Text = tostring(ammoStoraged.Value)
						.. "/"
						.. tostring(maxAmmoStoraged.Value)
				end
			end
		end
	end
end

return updateAmmoBoxModule
