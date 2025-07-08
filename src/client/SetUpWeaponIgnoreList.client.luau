local ReplicatedStorage = game:GetService("ReplicatedStorage")
local heroFolder = ReplicatedStorage.Shared.Hero
local ignoreList = require(heroFolder.WeaponIgnoreList)

local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
local updateWIL_Event: RemoteEvent = eventsFolder:FindFirstChild("UpdateWeaponIgnoreList")

function UpdateList(parent: Instance, childName: string, add: boolean)
	local element = parent:WaitForChild(childName)

	if element and element:IsA("Part") then
		if add then
			print("new element added: ", element)
			table.insert(ignoreList, element)
		else
			for i = 1, #ignoreList do
				if ignoreList[i] == element then
					print("new element removed: ", element)
					table.remove(ignoreList, i)
					break
				end
			end
		end
	end
end

updateWIL_Event.OnClientEvent:Connect(UpdateList)
