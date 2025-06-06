local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HConstantType = require(ReplicatedStorage.Shared.Types.HumanoidConstantType)
type HConstantType = HConstantType.HumanoidConstants

local listeners: { BindableFunction } = {}

local constant: HConstantType = {
	health = 100,
	walk_speed = 16,
	base_regen = 0.1,
	healing_multiplier = 1,
	damage_reduction = 1,
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
				listeners[i]:Invoke()
			end

			rawset(constant, key, newVal)
		end
	end,
})

function proxy:AddListeners(newBind: BindableFunction)
	table.insert(listeners, newBind)
end

return proxy
