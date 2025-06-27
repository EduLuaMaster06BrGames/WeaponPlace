local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HConstantType = require(ReplicatedStorage.Shared.Hero.Types.HumanoidConstantType)

type HConstantType = HConstantType.HumanoidConstants
type Listener = HConstantType.Listener

local listeners: { Listener } = {}

local constant: HConstantType = {
	MaxHealth = nil,
	WalkSpeed = nil,
	BaseRegen = nil,
	HealingMultiplier = nil,
	DamageReduction = nil,
}

local proxy = {} :: HConstantType
setmetatable(proxy, {
	__index = function(_, key)
		return constant[key]
	end,
	__newindex = function(_, key, newVal)
		local oldVal = constant[key]
		if oldVal ~= newVal then
			for i = 1, #listeners do
				local currentListener = listeners[i]

				for j = 1, #currentListener.ListeningTo do
					if currentListener.ListeningTo[j] == key then
						currentListener.Method(key, newVal)
					end
				end
			end

			rawset(constant, key, newVal)
		end
	end,
})

function proxy:AddListener(newListener: Listener)
	table.insert(listeners, newListener)
	print("New Listener Added / Id: ", newListener.Id, " Listening to: ", newListener.ListeningTo)
end

return proxy
